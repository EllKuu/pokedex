//
//  PokemonEvolutionsViewModel.swift
//  pokedex
//
//  Created by elliott kung on 2021-08-10.
//

import Foundation

struct PokemonEvolutionsViewModel{
    
    
    var pokemonEvolutionChain: [String] = []
    
    init(_ pokemonEvolutions: PokemonEvolutions) {
        
        getEvolutionNames(evolutionChain: pokemonEvolutions.chain)
        
        print(pokemonEvolutionChain)
        
    }
    
    
    
    
    mutating func getEvolutionNames(evolutionChain: PokemonEvolutions.Chain){
        //extract chains species name
        pokemonEvolutionChain.append(evolutionChain.species.name)
        
        //check if chain has any chainlinks in evolve to
        if !evolutionChain.evolves_to.isEmpty{
            traverseChain(chainLink: evolutionChain.evolves_to)
        }
    }
    
    mutating func traverseChain(chainLink: [PokemonEvolutions.ChainLink]){
        for item in chainLink{
            pokemonEvolutionChain.append(item.species.name)
            if !item.evolves_to.isEmpty{
                traverseChain(chainLink: item.evolves_to)
            }
        }
    }
    
    
    
    
    
}
