//
//  ViewController.swift
//  pokedex
//
//  Created by elliott kung on 2021-07-18.
//

import UIKit

class ViewController: UIViewController {
    
    var pokemonListResult: PokemonList?
    
    var pokemonDetailsArray = [PokemonDetails]()
    var pokemonSpeciesDetailsArray = [PokemonSpecies]()
    var pokemonEvolutionDetailsArray = [PokemonEvolutions]()
    
    let group = DispatchGroup()
    let queue = DispatchQueue.global()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .utility).async {
            NetworkEngine.shared.getPokemonList { [weak self] result in
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    switch result{
                    case .success(let pokemonListRes):
                        strongSelf.pokemonListResult = pokemonListRes
                    case .failure(let error):
                        print(error.rawValue)
                    }
                }
                
            }// end of getPokemonList
            
            
            DispatchQueue.main.async {
                guard let pkr = self.pokemonListResult else {
                    print("problem")
                    return

                }
                print("Hello - \(pkr.results)")
            }
            
            
            NetworkEngine.shared.getPokemonDetails(pokemonList: self.pokemonListResult!) { [weak self] result in
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    switch result{
                    case .success(let pokemonDetails):
                        strongSelf.pokemonDetailsArray = pokemonDetails
                    case .failure(let error):
                        print(error.rawValue)
                    }
                }
                
            }// end of getPokemonDetails
            
            DispatchQueue.main.async {
                for p in self.pokemonDetailsArray{
                    print("\(p.species.url) - Details Array")
                }
            }
            
            
            NetworkEngine.shared.getPokemonSpeciesDetails(speciesList: self.pokemonDetailsArray) { [weak self] result in
                guard let strongSelf = self else { return }

                DispatchQueue.main.async {
                    switch result{
                    case .success(let pokemonSpecies):
                        strongSelf.pokemonSpeciesDetailsArray = pokemonSpecies
                        print(pokemonSpecies)
                    case .failure(let error):
                        print(error.rawValue)
                    }
                }
            } // end of getPokemonSpeciesDetails

            DispatchQueue.main.async {
                for p in self.pokemonSpeciesDetailsArray{
                    print("\(p.name) - Species Array")
                }
            }
            
//            NetworkEngine.shared.getPokemonEvolutionChain(pokemonEvolutionList: self.pokemonSpeciesDetailsArray) { [weak self] result in
//                guard let strongSelf = self else { return }
//
//                DispatchQueue.main.async {
//                    switch result{
//                    case .success(let pokemonEvolutions):
//                        strongSelf.pokemonEvolutionDetailsArray = pokemonEvolutions
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//            }// end of getPokemonEvolutionChain
//
//            DispatchQueue.main.async {
//                for p in self.pokemonEvolutionDetailsArray{
//                    print("\(p.chain) - evolution chain")
//                }
//            }
            
            
        }// end of async
        
        
        
        
        
        
        
        
        
        
        
        
        
        //        NetworkEngine.shared.getPokemonList { [weak self] result in
        //            guard let strongSelf = self else { return }
        //
        //            switch result{
        //                case .success(let pokemonDetails):
        //                    //print(pokemonDetails.results)
        //                    NetworkEngine.shared.getPokemonDetails(pokemonList: pokemonDetails) { [weak self] result in
        //                        guard let strongSelf = self else { return }
        //
        //                        switch result{
        //                            case .success(let pokemonDetails):
        //                                for i in pokemonDetails{
        //                                    print(i.name)
        //                                }
        //                                strongSelf.pokemonDetailsArray = pokemonDetails
        //
        //                                // get species details
        
        //
        
        //                                            NetworkEngine.shared.getPokemonEvolutionChain(pokemonEvolutionUrl: pokemonSpecies.evolution_chain.url) { [weak self] result in
        //                                                guard let strongSelf = self else { return }
        //
        //                                                switch result{
        //                                                case .success(let pokemonEvolutions):
        //                                                    //print(pokemonEvolutions.chain.evolves_to)
        //                                                    strongSelf.pokemonEvolutionDetailsArray.append(pokemonEvolutions)
        //
        //                                                case .failure(let error):
        //                                                    print(error)
        //
        //                                                }
        //
        //
        //                                            }// end of getPokemonEvolutionChain
        //
        //
        
        //
        //                            case .failure(let error):
        //                                print(error.rawValue)
        //                        }
        //                    }// end of getPokemonDetails
        //
        //                case .failure(let error):
        //                    print(error.rawValue)
        //            }
        //        }// end of getPokemonList
        
        
        
        //        group.notify(queue: .main) {
        //         print("\(self.pokemonDetailsArray.count) + Details")
        //         print("\(self.pokemonSpeciesDetailsArray.count) + Species")
        //         print("\(self.pokemonEvolutionDetailsArray.count) + Evolutions")
        //         }
        
    }// end of view did load
    
    
    
    
    
    //    func addToList(pokemon: Pokemon){
    //        self.pokemonListArray.append(pokemon)
    //        //print(self.pokemonListArray[0].results)
    //
    //        for (index, poke) in self.pokemonListArray[0].results.enumerated(){
    //            //print(poke.url)
    //        }
    //    }
    
    
}

