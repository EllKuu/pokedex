//
//  NetworkEngine.swift
//  pokedex
//
//  Created by elliott kung on 2021-07-18.
//

import Foundation

class NetworkEngine{
    
    func getPokemonData(){
        
        //1: create HTTP request
        
        let session = URLSession.shared
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=898&offset=0")!
        
        //2: make the request
        let task = session.dataTask(with: url) { data, response, error in
           
            // check errors
            if error != nil {
                print(error as Any)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                print(response as Any)
                return
            }
            
            guard let mime = response?.mimeType, mime == "application/json" else{
                print("wrong mime type")
                return
            }
            
           
            do{
                let pokemonDecoder = JSONDecoder()
                
//                let json = try JSONSerialization.jsonObject(with: data!, options: [])
//                print(json as Any)
                
                let pokemonResult = try pokemonDecoder.decode(Pokemon.self, from: data!)
                print(pokemonResult.results as Any)
            }catch{
                print("JSON Error \(error.localizedDescription)")
                print(error)
            }
           
        }
        
        task.resume()
        
    }
    
}
