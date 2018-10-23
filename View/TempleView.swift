//
//  TempleView.swift
//  TempleFlashCards
//
//  Created by Emily Prigmore on 10/22/18.
//  Copyright © 2018 IS 543. All rights reserved.
//

import UIKit

class TempleView: UIView {
    
    
    // MARK:- Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK:- Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "TempleView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        //contentView.frame = bounds
        addSubview(contentView)
    }
    var caption: String? {
        get { return label?.text }
        set { label.text = newValue }
    }
    
    var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }
    
    func addConstraints() {
        invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        if let image = imageView.image {
             return CGSize(width: image.size.width, height: 150.0)
        }
        else {
            return CGSize(width: 150.0, height: 150.0)
        }
    }
}
