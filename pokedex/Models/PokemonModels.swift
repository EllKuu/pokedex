//
//  Pokemon.swift
//  pokedex
//
//  Created by elliott kung on 2021-07-18.
//

import Foundation


/* Model for Pokemon list endpoint */
class PokemonList: Codable{
        let results: [Results]
   
    struct Results: Codable{
        let name: String
        let url: String?
    }
    
}

/* Model for Pokemon Detail endpoint */
class PokemonDetails: Codable{
    let id: Int
    let order: Int
    let name: String
    let height: Int
    let weight: Int
    let species: Species
    let sprites: Sprites
    let types: [Types]
}

struct Species: Codable{
    let url: String
}

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


/* Pokemon Species details */
class PokemonSpecies: Codable{
    let id: Int
    let name: String
    let order: Int
    let is_baby: Bool
    let is_legendary: Bool
    let is_mythical: Bool
    let generation: Generation
    let flavor_text_entries: [FlavorTextEntries]
    let evolution_chain: EvolutionChain
}

struct Generation: Codable{
    let name: String
}

struct FlavorTextEntries:Codable {
    let flavor_text: String
    let language: Language
}

struct Language: Codable {
    let name: String
}

struct EvolutionChain: Codable{
    let url: String
}



/* Model for Pokemon evolution endpoint */
class PokemonEvolutions: Codable{
    let chain: Chain
    
    struct Chain: Codable{
        let evolves_to: [ChainLink]
    }
    
    struct ChainLink: Codable {
        let evolves_to: [ChainLink]
        let species: Species
    }
    
    struct Species: Codable {
        let name: String
    }
    
    
}

