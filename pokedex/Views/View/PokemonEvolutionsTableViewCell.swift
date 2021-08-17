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
            
            pokemonName.text = "\(pokemonEvolutionsModel.evolutionLevel).  \(pokemonEvolutionsModel.name.capitalized)"
            pokemonImage.image = pokemonEvolutionsModel.pokemonImage
                
        }
    }
    
    private let pokemonName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Hello"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let pokemonImage: UIImageView = {
        let pkImage = UIImageView(image: UIImage(systemName: "house"))
        pkImage.contentMode = .scaleAspectFit
        pkImage.clipsToBounds = true
        pkImage.translatesAutoresizingMaskIntoConstraints = false
        return pkImage
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(pokemonName)
        contentView.addSubview(pokemonImage)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pokemonName.frame = CGRect(x: 0, y: 0, width: contentView.frame.size
                                    .width, height: contentView.frame.size.height)
        pokemonImage.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.height-10, height: contentView.frame.size.height-10)
        
        NSLayoutConstraint.activate([
            pokemonImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            
            pokemonName.leftAnchor.constraint(equalTo: pokemonImage.rightAnchor, constant: 25),
            pokemonName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
