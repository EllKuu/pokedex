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
                    NetworkEngine.shared.getPokemonDetails(pokemonList: pokemonDetails) { [weak self] result in
                        guard let strongSelf = self else { return }
                        
                        DispatchQueue.main.async {
                            switch result{
                            case .success(let pokemonDetails):
                                strongSelf.pokemonDetailsArray = pokemonDetails
                                
                                
                                // get species details
                                NetworkEngine.shared.getPokemonSpeciesDetails(speciesList: pokemonDetails) { [weak self] result in
                                    guard let strongSelf = self else { return }
                                    
                                    DispatchQueue.main.async {
                                        switch result{
                                        case.success(let pokemonSpecies):
                                            strongSelf.pokemonSpeciesDetailsArray = pokemonSpecies
                                            
                                            NetworkEngine.shared.getPokemonEvolutionChain(pokemonEvolutionList: pokemonSpecies) { [weak self] result in
                                                guard let strongSelf = self else { return }
                                                DispatchQueue.main.async {
                                                    switch result{
                                                    case .success(let pokemonEvolutions):
                                                        strongSelf.pokemonEvolutionDetailsArray = pokemonEvolutions
                                                        strongSelf.isWaiting = false
                                                        
                                                    case .failure(let error):
                                                        print(error)
                                                    }
                                                    
                                                }
                                            }
                                            
                                            
                                        case .failure(let error):
                                            print(error)
                                        }
                                    }
                                    
                                }
                            case .failure(let error):
                                print(error.rawValue)
                            }
                        }
                    }// end of getPokemonDetails
                
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        }// end of getPokemonList
        
        self.view.backgroundColor = .blue

        
    }// end of view did load
    
    func updateUI(){
        if isWaiting{
            print("API running")
        }else{
            self.view.backgroundColor = .red
            print(self.pokemonListResult)
            print(self.pokemonDetailsArray.count)
            print(self.pokemonSpeciesDetailsArray.count)
            //print(self.pokemonEvolutionDetailsArray)
            
            for p in self.pokemonEvolutionDetailsArray{
                print(p.chain)
            }
        }
       
    }
    
    
}

