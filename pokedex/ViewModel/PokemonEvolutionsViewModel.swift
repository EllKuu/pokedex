//
//  PokemonEvolutionsViewModel.swift
//  pokedex
//
//  Created by elliott kung on 2021-08-10.
//

import Foundation
import UIKit

struct PokemonEvolutionsViewModel{
    
    
    let name: String
    let pokemonImage: UIImage
    let evolutionLevel: Int
    
    init(_ pokemonSprites: UIImage, _ pokemonHierarchy: PokemonEvolutionHierarchy ) {
        
        name = pokemonHierarchy.pokemonName
        pokemonImage = pokemonSprites
        evolutionLevel = pokemonHierarchy.evolutionLevel
        
        
    }
    
    

    
    
    
    
    
}
