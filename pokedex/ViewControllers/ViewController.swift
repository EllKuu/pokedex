//
//  ViewController.swift
//  pokedex
//
//  Created by elliott kung on 2021-07-18.
//

import UIKit

class ViewController: UIViewController {
    
    var pokemonListArray = [Pokemon]()
    
    var pokemonDetailsArray = [PokemonDetails]()
    var pokemonSpeciesDetailsArray = [PokemonSpecies]()
    var pokemonEvolutionDetailsArray = [PokemonEvolutions]()
    
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkEngine.shared.getPokemonList { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result{
                case .success(let pokemonDetails):
                    
                    NetworkEngine.shared.getPokemonDetails(pokemonList: pokemonDetails) { [weak self] result in
                        guard let strongSelf = self else { return }

                        switch result{
                            case .success(let pokemonDetails):
                                strongSelf.pokemonDetailsArray.append(pokemonDetails)
                                
                                // get species details
                                NetworkEngine.shared.getPokemonSpeciesDetails(speciesUrl: pokemonDetails.species.url) { [weak self] result in
                                    guard let strongSelf = self else { return }
                                    
                                    switch result{
                                        case .success(let pokemonSpecies):
                                            //print(pokemonSpecies.evolution_chain.url)
                                            strongSelf.pokemonSpeciesDetailsArray.append(pokemonSpecies)
                                            
                                            NetworkEngine.shared.getPokemonEvolutionChain(pokemonEvolutionUrl: pokemonSpecies.evolution_chain.url) { [weak self] result in
                                                guard let strongSelf = self else { return }
                                                
                                                switch result{
                                                case .success(let pokemonEvolutions):
                                                    //print(pokemonEvolutions.chain.evolves_to)
                                                    strongSelf.pokemonEvolutionDetailsArray.append(pokemonEvolutions)
                                                    
                                                case .failure(let error):
                                                    print(error)
                                                    
                                                }
                                                
                                                
                                            }// end of getPokemonEvolutionChain
                                            
                                            
                                        case .failure(let error):
                                            print(error.rawValue)
                                    }
                                } // end of getPokemonSpeciesDetails
                                
                            case .failure(let error):
                                print(error.rawValue)
                        }
                    }// end of getPokemonDetails
                    
                case .failure(let error):
                    print(error.rawValue)
            }
        }// end of getPokemonList
        
        
       
        
        group.notify(queue: .main) {
         print("\(self.pokemonDetailsArray.count) + Details")
         print("\(self.pokemonSpeciesDetailsArray.count) + Species")
         print("\(self.pokemonEvolutionDetailsArray.count) + Evolutions")
         }
        
    }// end of view did load
    
   
    
    
    func addToList(pokemon: Pokemon){
        self.pokemonListArray.append(pokemon)
        //print(self.pokemonListArray[0].results)
        
        for (index, poke) in self.pokemonListArray[0].results.enumerated(){
            //print(poke.url)
        }
    }
    
    
}

