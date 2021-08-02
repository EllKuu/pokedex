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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    // MARK: - Properties
    
    var pokemonDetailsModel: PokemonDetails! {
        didSet{
            titleLabel.text = "\(pokemonDetailsModel.id).\(pokemonDetailsModel.name)"
            pokemonImage.image = UIImage(systemName: "house")
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
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = .systemBlue
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.frame.size.width = 300
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pokemonImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "house")
        image.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
}

// MARK: - UI Setup
extension PokemonCollectionViewCell {
    private func setupUI() {
        self.contentView.addSubview(roundedBackgroundView)
        roundedBackgroundView.addSubview(pokemonImage)
        roundedBackgroundView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            roundedBackgroundView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            roundedBackgroundView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            roundedBackgroundView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5),
            roundedBackgroundView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5),
            
            pokemonImage.centerXAnchor.constraint(equalTo: roundedBackgroundView.centerXAnchor),
            //            pokemonImage.centerYAnchor.constraint(equalTo: roundedBackgroundView.centerYAnchor),
            pokemonImage.bottomAnchor.constraint(equalTo: self.titleLabel.topAnchor, constant: 100),
            
            titleLabel.centerXAnchor.constraint(equalTo: roundedBackgroundView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: roundedBackgroundView.centerYAnchor)
        ])
        
    }
}
