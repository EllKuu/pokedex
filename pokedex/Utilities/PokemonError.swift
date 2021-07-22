//
//  PokemonError.swift
//  pokedex
//
//  Created by elliott kung on 2021-07-19.
//

import Foundation

enum PokemonError: String, Error {
    case unableToComplete = "Unable to complete request."
    case invalidResponse = "Invalid response from server."
    case invalidData = "Data received from server is invalid."
    case invalidMime = "Response from server is invalid"
    case pokemonDetailDataInvalid = "Pokemon url data is invalid."
}
