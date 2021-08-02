//
//  PokemonCollectionViewCell.swift
//  pokedex
//
//  Created by elliott kung on 2021-08-01.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PokemonCollectionViewCell"
    
    // Initialization
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(roundedBackgroundView)
        contentView.addSubview(pokemonImage)
        contentView.addSubview(titleLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        roundedBackgroundView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        titleLabel.frame = CGRect(x: 5, y: contentView.frame.size.height-50, width: frame.size.width-10, height: 50)
        pokemonImage.frame = CGRect(x: 5, y: 0, width: frame.size.width-10, height: contentView.frame.size.height-50)
        
    }
    
    // MARK: - Properties
    
    var pokemonDetailsModel: PokemonViewModel! {
        didSet{
            titleLabel.text = pokemonDetailsModel.title
            pokemonImage.image = pokemonDetailsModel.pokemonImage
        }
    }
    
    lazy var roundedBackgroundView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 10)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pokemonImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "house")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
}
