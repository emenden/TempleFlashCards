//
//  ViewController.swift
//  TempleFlashCards
//
//  Created by Emily Prigmore on 10/11/18.
//  Copyright © 2018 IS 543. All rights reserved.
//

import UIKit

class TempleFlashcardsViewController: UIViewController {
    
    private struct Storyboard {
        static let CollectionCellReuseIdentifier = "TempleCollectionCell"
        static let TableCellReuseIdentifier = "TempleTableCell"
    }
    
    // MARK:- Properties
    
    var deck = TempleDeck()
    var inMatchMode: Bool = true
    
    var selectedTemple: String? = nil
    var selectedTempleIndex: IndexPath? = nil
    var selectedTempleName: String? = nil
    var selectedTempleNameIndex: IndexPath? = nil
    
    var correctGuesses: Int = 0
    var incorrectGuesses: Int = 0
    
    // MARK:- Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var toggleModeButton: UIBarButtonItem!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIBarButtonItem!
    
    @IBOutlet weak var tableViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewTrailingConstraint: NSLayoutConstraint!
    
    // MARK:- Actions
    
    @IBAction func toggleMode(_ sender: Any) {
        collectionView.layoutIfNeeded()
        
        UIView.animate(withDuration: Animation.Duration,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        if self.inMatchMode {    // switching to study mode
                            self.collectionViewTrailingConstraint.constant = 0
                            self.tableViewWidthConstraint.constant = 0
                            self.inMatchMode = false
                            self.enableResetButton(isEnabled: false)
                            self.displayScore(isDisplayed: false)
                            self.setToggleButton(toMode: "Match")
                        }
                        else {  // switching to match mode
                            self.collectionViewTrailingConstraint.constant = 170
                            self.tableViewWidthConstraint.constant = 170
                            self.inMatchMode = true
                            self.enableResetButton(isEnabled: true)
                            self.displayScore(isDisplayed: true)
                            self.setToggleButton(toMode: "Study")
                        }
                        
                        self.collectionView.reloadData()
                        self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func reset(_ sender: Any) {
        correctGuesses = 0
        incorrectGuesses = 0
        displayScore(isDisplayed: true)
        deck.resetTempleList()
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    // MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 45
        
        displayScore(isDisplayed: true)
    }
    
    // MARK:- Helpers
    
    private func enableResetButton(isEnabled enabled: Bool) {
        resetButton.isEnabled = enabled
    }
    
    private func displayScore(isDisplayed displayed: Bool) {
        if displayed == true {
            scoreLabel.isHidden = false
            scoreLabel.text = "Correct: \(correctGuesses) Incorrect: \(incorrectGuesses)"
        }
        else {
            scoreLabel.isHidden = true
        }
    }
    
    private func setToggleButton(toMode mode: String) {
        toggleModeButton.title = mode
    }
    
    fileprivate func showAlert(message: String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    fileprivate func verifyGuesses() {
        // check the user's guess
        if selectedTempleName == selectedTemple {
            // tell the user the guess was correct
            showAlert(message: "Correct!")
            
            // increment the score
            correctGuesses += 1
            
            // take the cell and row out of set
            // TODO index will be different if we shuffle the decks for both locations and images
            if let templeIndex = selectedTempleIndex {
                deck.remove(index: templeIndex.row)
                collectionView.performBatchUpdates({
                    collectionView.deleteItems(at: [templeIndex])
                })
                tableView.performBatchUpdates({
                    self.tableView.deleteRows(at: [templeIndex], with: .automatic)
                })
            }
        }
        else {
            // tell the user the guess was incorrect
            showAlert(message: "Incorrect")
            // decrement the score
            incorrectGuesses += 1
        }
        // update all values
        displayScore(isDisplayed: true)
        selectedTemple = nil
        selectedTempleIndex = nil
        selectedTempleName = nil
        selectedTempleNameIndex = nil
    }
}

// MARK:- CollectionView datasource

extension TempleFlashcardsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deck.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.CollectionCellReuseIdentifier, for: indexPath) as! TempleCell
        
        let temple = deck.temples[(indexPath as IndexPath).row]
        
        // set up image display
        cell.imageView.image = UIImage(named: temple.image)
        cell.imageView.layer.borderColor = UIColor.gray.cgColor
        cell.imageView.layer.borderWidth = 1
        
        // set up label display
        if inMatchMode {
            cell.locationLabel.backgroundColor = UIColor.clear
            cell.locationLabel.text = ""
        }
        else {
            cell.locationLabel.backgroundColor = UIColor.white.withAlphaComponent(0.75)
            cell.locationLabel.text = temple.location
        }

        cell.backgroundColor = UIColor.white
        return cell
    }
}

// MARK:- CollectionView delegate

extension TempleFlashcardsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let setImageHeight = 150.0
        
        let image = UIImage(named: deck.temples[indexPath.row].image)
        if let imageWidthPoints = image?.size.width {
            let imageWidth = Double(imageWidthPoints)
            if let imageHeightPoints = image?.size.height {
                let imageHeight = Double(imageHeightPoints)
                let width = imageWidth/imageHeight * setImageHeight
                return CGSize(width: width, height: setImageHeight)
            }
        }
        return CGSize(width: 150.0, height: 150.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTemple = deck.temples[indexPath.row].location
        selectedTempleIndex = indexPath
        if inMatchMode == true {
            if selectedTempleName != nil && selectedTemple != nil {
                verifyGuesses()
            }
        }
    }
}

// MARK:- TableView datasource

extension TempleFlashcardsViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deck.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TableCellReuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = deck.temples[(indexPath as IndexPath).row].location
        return cell
    }
}

// MARK:- TableView delegate

extension TempleFlashcardsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTempleName = deck.temples[indexPath.row].location
        selectedTempleNameIndex = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        if inMatchMode == true {
            verifyGuesses()
        }
    }
}
