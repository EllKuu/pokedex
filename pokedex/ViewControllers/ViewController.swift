//
//  ViewController.swift
//  pokedex
//
//  Created by elliott kung on 2021-07-18.
//

import UIKit

class ViewController: UIViewController {
    
    var array = [PokemonDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NetworkEngine.shared.getPokemonData { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result{
                case .success(let pokemonDetails):
                    //print(pokemonDetails.types)
                    self?.array.append(pokemonDetails)
                case .failure(let error):
                    print(error.rawValue)
            }
            
            //print("\(self?.array[0].name) - \(self?.array[0].id)")
        }
        
       
        
    }


}

