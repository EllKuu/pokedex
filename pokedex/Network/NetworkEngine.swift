//
//  NetworkEngine.swift
//  pokedex
//
//  Created by elliott kung on 2021-07-18.
//

import Foundation

class NetworkEngine{
    
    static let shared = NetworkEngine()
    private let baseUrl = "https://pokeapi.co/api/v2/pokemon?limit=898&offset=0"
    
    private let pokemonResourceUrl = "https://pokeapi.co/api/v2/pokemon/{id or name}"
    private let pokemonLocationUrl = "https://pokeapi.co/api/v2/pokemon/{id or name}/encounters"
    private let pokemonEvolutionsUrl = "https://pokeapi.co/api/v2/evolution-chain/{id}"
    
    
    
    func getPokemonData(completed: @escaping (Result<PokemonDetails, PokemonError>) -> Void){
        
        //1: create HTTP request
        
        let session = URLSession.shared
        let url = URL(string: baseUrl)!
        
        //2: make the request
        let task = session.dataTask(with: url) { data, response, error in
           
            // check errors
            if error != nil {
                //print(error as Any)
                completed(.failure(.unableToComplete))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                completed(.failure(.invalidData))
                return
            }
            
            guard let mime = response?.mimeType, mime == "application/json" else{
                //print("wrong mime type")
                completed(.failure(.invalidData))
                return
            }
            
           
            do{
                let pokemonDecoder = JSONDecoder()
                
                let pokemonResult = try pokemonDecoder.decode(Pokemon.self, from: data!)
                //completed(.success(pokemonResult))
                
                // use url to get pokemon details
                for pokemon in pokemonResult.results{
                    guard let pokemonUrl = pokemon.url else { continue }
                    let newUrl = URL(string: pokemonUrl)
                    
                    let detailResult = session.dataTask(with: newUrl!) { data, response, error in
                        
                        if error != nil {
                            //print(error as Any)
                            completed(.failure(.unableToComplete))
                            return
                        }
                        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                            completed(.failure(.invalidData))
                            return
                        }
                        
                        do{
                            let pokemonDetails = try pokemonDecoder.decode(PokemonDetails.self, from: data!)
                            completed(.success(pokemonDetails))
                        }catch{
                            print("JSON Error \(error.localizedDescription)")
                            print(error)
                            completed(.failure(.invalidData))
                        }
                       
                    }.resume()
                }// end of for loop
                
                
            }
            catch{
                print("JSON Error \(error.localizedDescription)")
                completed(.failure(.invalidData))
                
            }
        }
        task.resume()
    
    }// end of getData
    
    func getPokemonLocationArea(){
        
    }
    
    func getPokemonEvolutionChain(){
        
    }
    
    
    
    
    
    
    
    
    
    
}
