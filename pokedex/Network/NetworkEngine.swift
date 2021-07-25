//
//  NetworkEngine.swift
//  pokedex
//
//  Created by elliott kung on 2021-07-18.
//

import Foundation

class NetworkEngine{
    
    static let shared = NetworkEngine()
    private let baseUrl = "https://pokeapi.co/api/v2/pokemon?limit=150&offset=0"
    
    private let pokemonResourceUrl = "https://pokeapi.co/api/v2/pokemon/{id or name}"
    private let pokemonSpeciesUrl = "https://pokeapi.co/api/v2/pokemon-species/{id}"
    private let pokemonEvolutionsUrl = "https://pokeapi.co/api/v2/evolution-chain/{id}"

    
    let session = URLSession.shared
    let pokemonDecoder = JSONDecoder()
    let resultQueue: DispatchQueue = .main
    
    func getPokemonList(completed: @escaping (Result<PokemonList, PokemonError>) -> Void){
        
        //1: create HTTP request
        let url = URL(string: baseUrl)!
        
       let semaphore = DispatchSemaphore(value: 0)
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
    
                let pokemonResult = try self.pokemonDecoder.decode(PokemonList.self, from: data!)
                    completed(.success(pokemonResult))
            }
            catch{
                print("JSON Error \(error.localizedDescription)")
                completed(.failure(.invalidData))
                
            }
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
    
    }// end of getPokemonList
    
    
    func getPokemonDetails(pokemonList: PokemonList, completed: @escaping(Result<[PokemonDetails], PokemonError>) -> Void){
        
        var pokemonDetailsArray = [PokemonDetails]()
        let semaphore = DispatchSemaphore(value: 0)
        
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

                do{
                    let pokemonDetails = try self.pokemonDecoder.decode(PokemonDetails.self, from: data!)
                    pokemonDetailsArray.append(pokemonDetails)
                    //completed(.success(pokemonDetailsArray))

                }catch{
                    print("JSON Error \(error.localizedDescription)")
                    print(error)
                    completed(.failure(.invalidData))
                }
                semaphore.signal()
            }.resume()
            _ = semaphore.wait(wallTimeout: .distantFuture)
            
        }
        completed(.success(pokemonDetailsArray))
        
    } // end of getPokemonDetails
    
    
    func getPokemonSpeciesDetails(speciesList: [PokemonDetails], completed: @escaping( Result<[PokemonSpecies], PokemonError>) -> Void){
        
        var pokemonSpeciesArray = [PokemonSpecies]()
        let semaphore = DispatchSemaphore(value: 0)
        
        for pokemon in speciesList{
            let pokemonSpeciesUrl = URL(string: pokemon.species.url)
            
            
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
                    pokemonSpeciesArray.append(pokemonSpecies)
                   
                }catch {
                    print("JSON Error \(error.localizedDescription)")
                    print(error)
                    completed(.failure(.invalidData))
                }
                semaphore.signal()

            }.resume()
            _ = semaphore.wait(wallTimeout: .distantFuture)
        }
        completed(.success(pokemonSpeciesArray))
    } // end of getPokemonSpeciesDetails
    
    
    func getPokemonEvolutionChain(pokemonEvolutionList: [PokemonSpecies], completed: @escaping(Result<[PokemonEvolutions], PokemonError>) -> Void){
        
        var pokemonEvolutionArray = [PokemonEvolutions]()
        let semaphore = DispatchSemaphore(value: 0)
       
        
        for pokemon in pokemonEvolutionList{
            
            let evolutionUrl = URL(string: pokemon.evolution_chain.url)
            
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
                    pokemonEvolutionArray.append(pokemonEvolutionChain)
                    
                }catch {
                    print("JSON Error \(error.localizedDescription)")
                    print(error)
                    completed(.failure(.invalidData))
                }
                semaphore.signal()
            }.resume()
            _ = semaphore.wait(wallTimeout: .distantFuture)
        } // end of getPokemonEvolutionChain
        completed(.success(pokemonEvolutionArray))
        
    }
        
       
    
    
    
    
    
    
    
    
    
    
}
