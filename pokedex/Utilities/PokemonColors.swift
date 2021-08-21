//
//  PokemonColors.swift
//  pokedex
//
//  Created by elliott kung on 2021-08-08.
//

import Foundation
import UIKit

struct PokemonColors {
    
    static let shared = PokemonColors()
    
    func pokemonGradientColors(pokemonType: String) -> UIColor{
        switch pokemonType {
        case "normal":
            return (UIColor(hex: "#A8A77Aff")!)
        case "fire":
            return (UIColor(hex: "#EE8130ff")!)
        case "water":
            return (UIColor(hex: "#6390F0ff")!)
        case "electric":
            return (UIColor(hex: "#F7D02Cff")!)
        case "grass":
            return (UIColor(hex: "#7AC74Cff")!)
        case "ice":
            return (UIColor(hex: "#96D9D6ff")!)
        case "fighting":
            return (UIColor(hex: "#C22E28ff")!)
        case "poison":
            return (UIColor(hex: "#A33EA1ff")!)
        case "ground":
            return (UIColor(hex: "#E2BF65ff")!)
        case "flying":
            return (UIColor(hex: "#A98FF3ff")!)
        case "psychic":
            return (UIColor(hex: "#F95587ff")!)
        case "bug":
            return (UIColor(hex: "#A6B91Aff")!)
        case "rock":
            return (UIColor(hex: "#B6A136ff")!)
        case "ghost":
            return (UIColor(hex: "#735797ff")!)
        case "dragon":
            return (UIColor(hex: "#6F35FCff")!)
        case "dark":
            return (UIColor(hex: "#705746ff")!)
        case "steel":
            return (UIColor(hex: "#B7B7CEff")!)
        case "fairy":
            return (UIColor(hex: "#D685ADff")!)
        default:
            return (UIColor(hex: "#000000ff")!)
        }
    }
    
    func createPokemonTypesGradient(colors: [UIColor], startCoordinate: CGPoint, endCoordinate: CGPoint, frame: CGRect) -> CAGradientLayer{
        
        let gradient = CAGradientLayer()
        
        var cgColors: [CGColor] = colors.map({ $0.cgColor })
        if cgColors.count == 1 {
            cgColors.insert(UIColor.systemGray2.cgColor, at: 0)
        }
        gradient.colors = cgColors
        gradient.startPoint = startCoordinate
        gradient.endPoint = endCoordinate
        gradient.frame = frame
        
        return gradient
        
    }
    
}
