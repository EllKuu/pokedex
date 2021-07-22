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
    private let pokemonSpeciesUrl = "https://pokeapi.co/api/v2/pokemon-species/{id}"
    private let pokemonEvolutionsUrl = "https://pokeapi.co/api/v2/evolution-chain/{id}"
    
    /* idea: setup other functions to get data when url
     -return in success case one pokemon detail object with all values needed
     -use dispatch group in api caller so it ony returns success case after all process have completed.
     
     */
    
    let session = URLSession.shared
    let pokemonDecoder = JSONDecoder()
    
    func getPokemonList(completed: @escaping (Result<Pokemon, PokemonError>) -> Void){
        
        //1: create HTTP request
        let url = URL(string: baseUrl)!
        
        //2: make the request
        let task = session.dataTask(with: url) { data, response, error in
           
            // check errors
            if error != nil {
                completed(.failure(.unableToComplete))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                completed(.failure(.invalidData))
                return
            }
            
            guard let mime = response?.mimeType, mime == "application/json" else{
                completed(.failure(.invalidMime))
                return
            }
            
           // decode the JSON
            do{
    
                let pokemonResult = try self.pokemonDecoder.decode(Pokemon.self, from: data!)
                //print(pokemonResult.results) sends back 1 object with neted list of all pokemon in it
                completed(.success(pokemonResult))
            }
            catch{
                print("JSON Error \(error.localizedDescription)")
                completed(.failure(.invalidData))
                
            }
        }
        task.resume()
    
    }// end of getPokemonList
    
    
    func getPokemonDetails(pokemonList: Pokemon, completed: @escaping(Result<PokemonDetails, PokemonError>) -> Void){
        // use url to get pokemon details
        
        for (index, pokemon) in pokemonList.results.enumerated(){
            //print(poke.url)
            guard let pokemonUrl = pokemon.url else { continue }
            let newUrl = URL(string: pokemonUrl)
            
            session.dataTask(with: newUrl!) { data, response, error in

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
                    
                    let pokemonDetails = try self.pokemonDecoder.decode(PokemonDetails.self, from: data!)
                    completed(.success(pokemonDetails))

                }catch{
                    print("JSON Error \(error.localizedDescription)")
                    print(error)
                    completed(.failure(.invalidData))
                }

            }.resume()
            
        }
        
    } // end of getPokemonDetails
    
    
    func getPokemonSpeciesDetails(speciesUrl: String, completed: @escaping( Result<PokemonSpecies, PokemonError>) -> Void){
        
        //guard let urlString = speciesUrl else { return }
        //print(speciesUrl)
        
        let pokemonSpeciesUrl = URL(string: speciesUrl)
        
        session.dataTask(with: pokemonSpeciesUrl!) { data, response, error in
            if error != nil {
                print(error as Any)
                completed(.failure(.unableToComplete))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                
                completed(.failure(.invalidData))
                return
            }
            
            do{
                let pokemonSpecies = try self.pokemonDecoder.decode(PokemonSpecies.self, from: data!)
                completed(.success(pokemonSpecies))
            }catch {
                print("JSON Error \(error.localizedDescription)")
                print(error)
                completed(.failure(.invalidData))
            }

        }.resume()
            
        
    } // end of getPokemonSpeciesDetails
    
    func getPokemonEvolutionChain(pokemonEvolutionUrl: String, completed: @escaping(Result<PokemonEvolutions, PokemonError>) -> Void){
        
        let evolutionUrl = URL(string: pokemonEvolutionUrl)
        
        session.dataTask(with: evolutionUrl!) { data, response, error in
            if error != nil {
                print(error as Any)
                completed(.failure(.unableToComplete))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                
                completed(.failure(.invalidData))
                return
            }
            
            do{
                let pokemonEvolutionChain = try self.pokemonDecoder.decode(PokemonEvolutions.self, from: data!)
                completed(.success(pokemonEvolutionChain))
            }catch {
                print("JSON Error \(error.localizedDescription)")
                print(error)
                completed(.failure(.invalidData))
            }

        }.resume()
    } // end of getPokemonEvolutionChain
    
    
    
    
    
    
    
    
    
    
}
