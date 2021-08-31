//
//  PokemonFlavorTextViewModel.swift
//  pokedex
//
//  Created by elliott kung on 2021-08-09.
//

import Foundation
import UIKit

struct PokemonFlavorTextViewModel{
    var flavorText: String
    var englishText: [String] = []
    var idx: Int = 0
    
    init(_ pokemonSpeciesFlavorText: PokemonSpecies) {
        
        for text in pokemonSpeciesFlavorText.flavor_text_entries{
            
            if text.language.name == "en"{
                let trimmed = text.flavor_text.replacingOccurrences(of: "\n", with: " ")
                englishText.append(trimmed)
            }
           
        }
        
        englishText = Array(Set(englishText))
        flavorText = englishText[idx]
        
    }
    
    public mutating func changeFlavorText(){
        idx += 1
        if idx == englishText.count{
            idx = 0
        }
        flavorText = englishText[idx]
        //print(flavorText)
        
    }
    
    
    
    
}
