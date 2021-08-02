//
//  PokemonViewModel.swift
//  pokedex
//
//  Created by elliott kung on 2021-08-02.
//

import Foundation
import UIKit

struct PokemonViewModel{
    
    let title: String
    let pokemonImage: UIImage
    
    
    init(_ pokemonDetailModel: PokemonDetails){
        title = "\(pokemonDetailModel.id).\(pokemonDetailModel.name.capitalized)"
        
        let url = URL(string: pokemonDetailModel.sprites.front_default ?? "")
        let data = try? Data(contentsOf: url!)
        pokemonImage = UIImage(data: data!) ?? UIImage(systemName: "questionmark.circle")!
    }
    
}
