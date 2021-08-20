//
//  PokemonFlavorTextTableViewCell.swift
//  pokedex
//
//  Created by elliott kung on 2021-08-09.
//

import UIKit

protocol PokemonFlavorTextTableViewCellDelegate: AnyObject{
    func pokemonFlavorTextTableViewCell(_ cell: PokemonFlavorTextTableViewCell, didTapWith viewModel: PokemonFlavorTextViewModel)
    
}

class PokemonFlavorTextTableViewCell: UITableViewCell {
    
    static let identifier = "PokemonFlavorTextTableViewCell"
    
    weak var delegate: PokemonFlavorTextTableViewCellDelegate?
    
    private var viewModel: PokemonFlavorTextViewModel?
    
    var changeFactBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("New Fact", for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 15
        
        return btn
        
    }()
    
    private let pokemonFact: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Hello"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var pokemonFlavorTextViewModel: PokemonFlavorTextViewModel!{
        didSet{
            pokemonFact.text = pokemonFlavorTextViewModel.flavorText
            viewModel = pokemonFlavorTextViewModel
        }
    }
    
    // MARK: Initialization and Layout
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(pokemonFact)
        contentView.addSubview(changeFactBtn)
        changeFactBtn.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
    }
    
    @objc private func didTapButton(){
        print("fact btn tapped")
        pokemonFlavorTextViewModel.changeFlavorText()
        guard let viewModel = viewModel else { return }
        
        var newViewModel = viewModel
        newViewModel.flavorText = viewModel.flavorText
        delegate?.pokemonFlavorTextTableViewCell(self, didTapWith: newViewModel)
    }
    
    func setInitialFlavorText() -> String{
        guard let viewModel = viewModel else { return "nothing" }
        
        var newViewModel = viewModel
        newViewModel.flavorText = viewModel.flavorText
        
        return newViewModel.flavorText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        pokemonFact.frame = CGRect(x: 0, y: 0, width: contentView.frame.size
                                    .width, height: 200)
        changeFactBtn.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: 100)
        
        NSLayoutConstraint.activate([
            
            pokemonFact.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            pokemonFact.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            pokemonFact.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            pokemonFact.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            changeFactBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            changeFactBtn.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            changeFactBtn.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pokemonFact.text = ""
    }

}
