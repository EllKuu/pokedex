//
//  PokemonEvolutionsTableViewCell.swift
//  pokedex
//
//  Created by elliott kung on 2021-08-10.
//

import UIKit

class PokemonEvolutionsTableViewCell: UITableViewCell {

   static let identifier = "PokemonEvolutionsTableViewCell"
   
    
    var pokemonEvolutionsModel: PokemonEvolutionsViewModel! {
        didSet{

            textLabel?.text = pokemonEvolutionsModel.name.capitalized
            textLabel?.textAlignment = .center
                
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
