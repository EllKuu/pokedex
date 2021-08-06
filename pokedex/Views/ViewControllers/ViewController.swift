//
//  ViewController.swift
//  pokedex
//
//  Created by elliott kung on 2021-07-18.
//

import UIKit
import Foundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var pokemonListResult: PokemonList?
    private var pokemonDetailsArray = [PokemonDetails]()
  
    
    
    
    private var isWaiting = false{
        didSet{
            self.updateUI()
        }
    }
    
    private lazy var pokemonCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cellWidthHeightConstant: CGFloat = view.frame.size.width / 3

                layout.sectionInset = UIEdgeInsets(top: 0,
                                                   left: 5,
                                                   bottom: 0,
                                                   right: 5)
                layout.scrollDirection = .vertical
                layout.minimumInteritemSpacing = 1
                layout.minimumLineSpacing = 1
                layout.itemSize = CGSize(width: cellWidthHeightConstant-4, height: cellWidthHeightConstant-4)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: "PokemonCollectionViewCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isWaiting = true
        self.view.backgroundColor = .red
        title = "PokeDex"
        navigationController?.navigationBar.prefersLargeTitles = true
        fetchData()
    }// end of view did load
    
    func updateUI(){
        if isWaiting{
            print("API running")
        }else{
            self.view.addSubview(pokemonCollectionView)
            
            NSLayoutConstraint.activate([
                pokemonCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                pokemonCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                pokemonCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                pokemonCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
            
            
            self.view.backgroundColor = .white
            print(self.pokemonListResult?.results.count)
            //print(self.pokemonDetailsArray)
            
            self.pokemonDetailsArray.sort(by: {$0.id < $1.id})
            
//            for p in self.pokemonDetailsArray {
//                print(p.id, p.name)
//            }
        }
    }
    
    func fetchData(){
        NetworkEngine.shared.getPokemonList { [weak self] result in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                switch result{
                case .success(let pokemonDetails):
                    strongSelf.pokemonListResult = pokemonDetails
                    
                    
                    // Get pokemon Details from PokemonList
                    NetworkEngine.shared.getPokemonDetails(pokemonList: pokemonDetails) { [weak self] result in
                        guard let strongSelf = self else { return }

                        DispatchQueue.main.async {
                            switch result{
                            case .success(let pokemonDetails):
                                strongSelf.pokemonDetailsArray = pokemonDetails
                                
                                strongSelf.isWaiting = false

                            case .failure(let error):
                                print("Details - \(error.rawValue)")
                            }
                        }
                    }// end of getPokemonDetails
                
                case .failure(let error):
                    print("PokemonList - \(error.rawValue)")
                }
            }
        }// end of getPokemonList
    }
    
    
    // MARK: UICollectionView Functions
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonDetailsArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as! PokemonCollectionViewCell
        //cell.pokemonDetailsModel = pokemonDetailsArray[indexPath.row]
        cell.pokemonDetailsModel = PokemonViewModel(pokemonDetailsArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PokemonDetailsViewController()
        // call pokemonVC fetch function and send url for species from indexpath
        vc.modalPresentationStyle = .formSheet
        vc.title = "\(pokemonDetailsArray[indexPath.row].name.capitalized)"
        vc.pokemonDetail = pokemonDetailsArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
} // end of class VC

