//
//  Pokemon.swift
//  pokedex
//
//  Created by elliott kung on 2021-07-18.
//

import Foundation

class Pokemon: Codable{
        let count: Int?
        let next: String?
        let previous: Bool?
        let results: [Results]
   
    
    struct Results: Codable{
        let name: String
        let url: String?
    }
    
   
}
