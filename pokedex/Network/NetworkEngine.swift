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
    
    
    let session = URLSession.shared
    let pokemonDecoder = JSONDecoder()
    
    func testFunc(){
        for i in 1...5{
            print("\(i) - Count")
        }
    }
    
    func getPokemonList(completed: @escaping (Result<PokemonList, PokemonError>) -> Void){
        
        //1: create HTTP request
        let url = URL(string: baseUrl)!
        
        //2: make the request
        let task = session.dataTask(with: url) { data, response, error in
            
            // check errors
            if error != nil {
                completed(.failure(.unableToComplete))
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
            DispatchQueue.main.async {
                do{
                    let pokemonResult = try self.pokemonDecoder.decode(PokemonList.self, from: data!)
                    completed(.success(pokemonResult))
                }
                catch{
                    print("JSON Error \(error.localizedDescription)")
                    completed(.failure(.invalidData))
                }
            }
        }
        task.resume()
        
    }// end of getPokemonList
    
    
    func getPokemonDetails(pokemonList: PokemonList, completed: @escaping(Result<[PokemonDetails], PokemonError>) -> Void){
        
        var pokemonDetailsArray = [PokemonDetails]()
        let listCount = pokemonList.results.count
        var counter = 0
        
        print("List Count: \(listCount)")
        
        for pokemon in pokemonList.results{
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
                
                DispatchQueue.main.async {
                    do{
                        let pokemonDetails = try self.pokemonDecoder.decode(PokemonDetails.self, from: data!)
                        pokemonDetailsArray.append(pokemonDetails)
                        counter += 1
                        
                        if counter == listCount{
                            completed(.success(pokemonDetailsArray))
                        }
                    }catch{
                        print("JSON Error \(error.localizedDescription)")
                        completed(.failure(.invalidData))
                    }
                    
                    
                }
            }.resume()
        }
    } // end of getPokemonDetails
    
    
    func getPokemonSpeciesDetails(pokemonSpecies: PokemonDetails, completed: @escaping( Result<PokemonSpecies, PokemonError>) -> Void){
        
        let pokemonSpeciesUrl = URL(string: pokemonSpecies.species.url)
        
        
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
            
            DispatchQueue.main.async {
                do{
                    let pokemonSpecies = try self.pokemonDecoder.decode(PokemonSpecies.self, from: data!)
                    
                    completed(.success(pokemonSpecies))
                }catch {
                    print("JSON Error \(error.localizedDescription)")
                    completed(.failure(.invalidData))
                }
            }
        }.resume()
        
    } // end of getPokemonSpeciesDetails
    
    
    func getPokemonEvolutionChain(pokemonEvolutionList: PokemonSpecies, completed: @escaping(Result<PokemonEvolutions, PokemonError>) -> Void){
        
        let evolutionUrl = URL(string: pokemonEvolutionList.evolution_chain.url)
        
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
            
            DispatchQueue.main.async {
                do{
                    let pokemonEvolutionChain = try self.pokemonDecoder.decode(PokemonEvolutions.self, from: data!)
                    
                    completed(.success(pokemonEvolutionChain))
                }catch {
                    print("JSON Error \(error.localizedDescription)")
                    completed(.failure(.invalidData))
                }
            }
        }.resume()
        
        
    }// end of getPokemonEvolutionChain
    
    
    
    
    
    
    
    
    
    
    
    
}
