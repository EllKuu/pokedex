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
    
    var pokemonTypeColors: [UIColor] = []
    
    
    init(_ pokemonDetailModel: PokemonDetails){
        title = "\(pokemonDetailModel.id).\(pokemonDetailModel.name.capitalized)"
        
        let url = URL(string: pokemonDetailModel.sprites.front_default ?? "")
        let data = try? Data(contentsOf: url!)
        pokemonImage = UIImage(data: data!) ?? UIImage(systemName: "questionmark.circle")!
        
        
        for type in pokemonDetailModel.types{
            //print(type.type.name)
            let pokemonType = type.type.name
            
            switch pokemonType {
            case "normal":
                pokemonTypeColors.append(UIColor(hex: "#A8A77Aff")!)
            case "fire":
                pokemonTypeColors.append(UIColor(hex: "#EE8130ff")!)
            case "water":
                pokemonTypeColors.append(UIColor(hex: "#6390F0ff")!)
            case "electric":
                pokemonTypeColors.append(UIColor(hex: "#F7D02Cff")!)
            case "grass":
                pokemonTypeColors.append(UIColor(hex: "#7AC74Cff")!)
            case "ice":
                pokemonTypeColors.append(UIColor(hex: "#96D9D6ff")!)
            case "fighting":
                pokemonTypeColors.append(UIColor(hex: "#C22E28ff")!)
            case "poison":
                pokemonTypeColors.append(UIColor(hex: "#A33EA1ff")!)
            case "ground":
                pokemonTypeColors.append(UIColor(hex: "#E2BF65ff")!)
            case "flying":
                pokemonTypeColors.append(UIColor(hex: "#A98FF3ff")!)
            case "psychic":
                pokemonTypeColors.append(UIColor(hex: "#F95587ff")!)
            case "bug":
                pokemonTypeColors.append(UIColor(hex: "#A6B91Aff")!)
            case "rock":
                pokemonTypeColors.append(UIColor(hex: "#B6A136ff")!)
            case "ghost":
                pokemonTypeColors.append(UIColor(hex: "#735797ff")!)
            case "dragon":
                pokemonTypeColors.append(UIColor(hex: "#6F35FCff")!)
            case "dark":
                pokemonTypeColors.append(UIColor(hex: "#705746ff")!)
            case "steel":
                pokemonTypeColors.append(UIColor(hex: "#B7B7CEff")!)
            case "fairy":
                pokemonTypeColors.append(UIColor(hex: "#D685ADff")!)
            default:
                pokemonTypeColors.append(UIColor(hex: "#000000ff")!)
            }
        }
        //print(pokemonTypeColors)
        
    }
    
}
