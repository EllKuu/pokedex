//
//  PokemonCollectionViewCell.swift
//  pokedex
//
//  Created by elliott kung on 2021-08-01.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PokemonCollectionViewCell"
    
    
    // MARK: - Properties
    
    var colors = [UIColor]()
    var gradient: CAGradientLayer?
    
    var pokemonDetailsModel: PokemonViewModel! {
        didSet{
            titleLabel.text = pokemonDetailsModel.title
            pokemonImage.image = pokemonDetailsModel.pokemonImage
            colors = pokemonDetailsModel.pokemonTypeColors
        }
    }
    
    lazy var roundedBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "arial", size: 14)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var pokemonImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "house")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    // MARK: Initialization and LayoutSubviews
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
        

        
        if let sublayers = roundedBackgroundView.layer.sublayers{
            for sublayer in sublayers{
                sublayer.removeFromSuperlayer()
            }
        }
    
        if let existingLayer = (roundedBackgroundView.layer.sublayers?.compactMap { $0 as? CAGradientLayer })?.first {
            gradient = existingLayer
        }else{
            gradient = CAGradientLayer()
            var cgColors: [CGColor] = colors.map({ $0.cgColor })
            if cgColors.count == 1 {
                cgColors.insert(UIColor.white.cgColor, at: 0)
            }
            gradient?.colors =  cgColors
            gradient?.frame = roundedBackgroundView.frame
            gradient?.cornerRadius = 10
        }
      
        roundedBackgroundView.layer.insertSublayer(gradient!, at: 0)
    }
    
   
    
}
