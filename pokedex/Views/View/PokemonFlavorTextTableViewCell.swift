//
//  PokemonFlavorTextTableViewCell.swift
//  pokedex
//
//  Created by elliott kung on 2021-08-09.
//

import UIKit

class PokemonFlavorTextTableViewCell: UITableViewCell {
    
    static let identifier = "PokemonFlavorTextTableViewCell"
    
    var pokemonFlavorTextViewModel: PokemonFlavorTextViewModel!{
        didSet{
            textLabel?.text = pokemonFlavorTextViewModel.flavorText
            textLabel?.numberOfLines = 0
            textLabel?.textAlignment = .center
        }
    }
    
    // MARK: Initialization and Layout
    
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
