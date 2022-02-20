//
//  pokedexTests.swift
//  pokedexTests
//
//  Created by elliott kung on 2021-07-18.
//

import XCTest
@testable import pokedex

class pokedexTests: XCTestCase {
    
    
    func testCanParsePokeList() throws {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "pokeapi", ofType: "json") else {
            fatalError("json not found")
        }
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("unable to convert json to string")
        }
        
        let jsonData = json.data(using: .utf8)!
        let result = try! JSONDecoder().decode(PokemonList.self, from: jsonData)
        
        XCTAssertEqual(result.results.count, 898)
        
    }
    
    func testCanParsePokeDetails() throws {
        let json = """
        {
            "id" : 1,
            "name" : "bulbasaur",
            "height" : 7,
            "weight":69,
            "species" : {
                "name" : "bulbasaur",
                "url":"https://pokeapi.co/api/v2/pokemon-species/1/"
            },
            "sprites" : {
                "back_default" : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png","front_default" : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
            },
            "types" : [
                {
                    "slot":1,
                    "type":{
                        "name":"grass",
                        "url":"https://pokeapi.co/api/v2/type/12/"
                    }
                },
                {
                    "slot":2,
                    "type":{
                        "name":"poison",
                        "url":"https://pokeapi.co/api/v2/type/4/"
                    }
                }
            ],
            
        }
        """
        
        let jsonData = json.data(using: .utf8)!
        let result = try! JSONDecoder().decode(PokemonDetails.self, from: jsonData)
        
        XCTAssertEqual(result.name, "bulbasaur")
        XCTAssertEqual(result.types[0].type.name, "grass")
        XCTAssertEqual(result.types[1].type.name, "poison")
        
    }
    
    
    func testCanParsePokemonSpecies() throws{
        let json = """
        {
            "id":1,
            "name":"bulbasaur",
            "order":1,
            "is_baby":false,
            "is_legendary":false,
            "is_mythical":false,
            "generation":{
                "name":"generation-i"
            },
            "evolution_chain":{
                "url":"https://pokeapi.co/api/v2/evolution-chain/1/"
            },
            
                "flavor_text_entries":[
                    {
                        "flavor_text":"A see on its back gives it           energy",
                        "language":{"name":"en"}
                    }
                ]
        }
        
        """
        
        let jsonData = json.data(using: .utf8)!
        let result = try! JSONDecoder().decode(PokemonSpecies.self, from: jsonData)
        
        XCTAssertEqual(result.name, "bulbasaur")
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.flavor_text_entries.isEmpty, false)
        
    }
    
    func testCanParsePokemonEvolutionChain() throws{
        let json = """
        {
        "chain":{
            "evolves_to":[
                {
                    "evolves_to":[
                        {
                            "evolution_details":[
                                {
                                    "gender":null,
                                    "held_item":null,
                                    "item":null,
                                    "known_move":null,
                                    "known_move_type":null,
                                    "location":null,
                                    "min_affection":null,
                                    "min_beauty":null,
                                    "min_happiness":null,
                                    "min_level":32,
                                    "needs_overworld_rain":false,
                                    "party_species":null,
                                    "party_type":null,
                                    "relative_physical_stats":null,
                                    "time_of_day":"",
                                    "trade_species":null,
                                    "trigger":{
                                        "name":"level-up",
                                        "url":"https://pokeapi.co/api/v2/evolution-trigger/1/"
                                    },
                                    "turn_upside_down":false
                                }
                            ],
                            "evolves_to":[
                            ],
                            "is_baby":false,
                            "species":{
                                "name":"venusaur",
                                "url":"https://pokeapi.co/api/v2/pokemon-species/3/"
                            }
                        }
                    ],
                    "is_baby":false,
                    "species":{
                        "name":"ivysaur",
                        "url":"https://pokeapi.co/api/v2/pokemon-species/2/"
                    }
                }
            ],
            "is_baby":false,
            "species":{
                "name":"bulbasaur",
                "url":"https://pokeapi.co/api/v2/pokemon-species/1/"
            }
        }
        }
        """
        
        let jsonData = json.data(using: .utf8)!
        let result = try! JSONDecoder().decode(PokemonEvolutions.self, from: jsonData)
        
        XCTAssertEqual(result.chain.species.name, "bulbasaur")
       
        
    }
    
   
}

