//
//  TempleDeck.swift
//  TempleFlashCards
//
//  Created by Emily Prigmore on 10/13/18.
//  Copyright © 2018 IS 543. All rights reserved.
//

import Foundation

class TempleDeck {
    
    // MARK:- Properties
    
    var masterTempleList: [Temple] = [
        Temple(image: "birmingham", location: "Birmingham, Alabama"),
        Temple(image: "bismarck", location: "Bismarck, South Dakota"),
        Temple(image: "bogota-columbia", location: "Bogota, Columbia"),
        Temple(image: "boise", location: "Boise, Idaho"),
        Temple(image: "boston", location: "Boston, Massachusetts"),
        Temple(image: "bountiful", location: "Bountiful, Utah"),
        Temple(image: "brigham-city", location: "Brigham City, Utah"),
        Temple(image: "brisbane-australia", location: "Brisbane, Australia"),
        Temple(image: "buenos-aires-argentina", location: "Buenos Aires, Argentina"),
        Temple(image: "calgary-alberta", location: "Canada, Alberta"),
        Temple(image: "campinas-brazil", location: "Campinas, Brazil"),
        Temple(image: "caracas-venezuela", location: "Caracas, Venezuela"),
        Temple(image: "cardston-alberta", location: "Cardston, Alberta"),
        Temple(image: "cebu-philippines", location: "Cebu, Philippines"),
        Temple(image: "cochabamba-bolivia", location: "Cochabamba, Bolivia"),
        Temple(image: "san-diego", location: "San Diego, California"),
        Temple(image: "provo-city-center", location: "Provo City Center, Utah")
    ]
    
    var temples: [Temple] = []
    
    init() {
        temples = masterTempleList
    }
    
    var count: Int {
        return temples.count
    }
    
    // MARK:- Methods
    func remove(index: Int) {
        temples.remove(at: index)
    }
    
    func resetTempleList() {
        temples = masterTempleList
    }
}
