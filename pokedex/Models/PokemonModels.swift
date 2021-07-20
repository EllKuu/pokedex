//
//  Pokemon.swift
//  pokedex
//
//  Created by elliott kung on 2021-07-18.
//

import Foundation


/* Model for Pokemon list endpoint */
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

/* Model for Pokemon Detail endpoint */
class PokemonDetails: Codable{
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    let types: [Types]
    
    struct Sprites: Codable{
        let back_default: String?
        let front_default: String?
    }
    
    struct Types: Codable {
        let slot: Int
        let type: Type
    }
    
    struct `Type`: Codable{
        let name: String
    }
}

/* Model for Pokemon region endpoint */
class PokemonRegion: Codable{
    let location_area: LocationArea
    
    struct LocationArea:Codable {
        let name: String
        let url: String
    }
}

/* Model for Pokemon evolution endpoint */
class PokemonEvolutions: Codable{
    let chain: [ChainLink]
    
    struct ChainLink: Codable{
        let species: [Species]
        let evolves_to: [ChainLink]
    }
    
    struct Species:Codable {
        let name: String
    }
    
    
}
