//
//  ViewController.swift
//  pokedex
//
//  Created by elliott kung on 2021-07-18.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    var pokemonListResult: PokemonList?
    
    var pokemonDetailsArray = [PokemonDetails]()
    var pokemonSpeciesDetailsArray = [PokemonSpecies]()
    var pokemonEvolutionDetailsArray = [PokemonEvolutions]()
    
    let group = DispatchGroup()
    let queue = DispatchQueue.global(qos: .background)
    let pokemonQueue = OperationQueue()
    
    private var isWaiting = false{
        didSet{
            self.updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isWaiting = true
        
        
        NetworkEngine.shared.getPokemonList { [weak self] result in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                switch result{
                case .success(let pokemonDetails):
                    strongSelf.pokemonListResult = pokemonDetails
                    
                    
                    // Get pokemon Details from PokemonList
                    NetworkEngine.shared.getPokemonDetails(pokemonList: pokemonDetails) { [weak self] result in
                        guard let strongSelf = self else { return }

                        DispatchQueue.main.async {
                            switch result{
                            case .success(let pokemonDetails):
                                strongSelf.pokemonDetailsArray = pokemonDetails
                                strongSelf.isWaiting = false

                            case .failure(let error):
                                print("Details - \(error.rawValue)")
                            }
                        }
                    }// end of getPokemonDetails
                
                case .failure(let error):
                    print("PokemonList - \(error.rawValue)")
                }
            }
        }// end of getPokemonList
        
        self.view.backgroundColor = .red

        
    }// end of view did load
    
    func updateUI(){
        if isWaiting{
            print("API running")
        }else{
            self.view.backgroundColor = .green
            print(self.pokemonListResult?.results.count)
            //print(self.pokemonDetailsArray)
//            for p in self.pokemonDetailsArray {
//                print(p.name, p.types)
//            }

        }
       
    }
    
    
} // end of class VC

