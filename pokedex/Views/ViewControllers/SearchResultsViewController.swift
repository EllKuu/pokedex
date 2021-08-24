//
//  SearchResultsViewController.swift
//  pokedex
//
//  Created by elliott kung on 2021-08-24.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView{
    static let identifier = "HeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "header"
        label.textAlignment = .center
        label.textColor = .black
        
        return label
    }()
    
    public func configure(title: String){
        label.text = title
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
}

class SearchResultsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    //MARK: Properties
    
    let pokemonTypeCategory: [String] = ["bug", "dark", "dragon", "electric", "fairy", "fighting", "fire", "flying", "ghost", "grass", "ground", "ice", "normal", "poison", "psychic", "rock", "steel", "water"]
    
    let pokemonRegions: [String] = ["kanto", "johto", "hoenn", "sinnoh", "unova", "kalos", "alola", "galar"]
    

    //MARK: Components
    
    lazy var searchOptionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cellWidthHeightConstant: CGFloat = view.frame.size.width / 5
        
        layout.sectionInset = UIEdgeInsets(top: 10,
                                           left: 5,
                                           bottom: 10,
                                           right: 5)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.itemSize = CGSize(width: cellWidthHeightConstant, height: cellWidthHeightConstant)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
       
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        //collectionView.isUserInteractionEnabled = true
        //collectionView.bringSubviewToFront(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(SearchCategoryCollectionViewCell.self, forCellWithReuseIdentifier: SearchCategoryCollectionViewCell.identifier)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        view.addSubview(searchOptionsCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchOptionsCollectionView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/2)
    }
    
    func activateConstraints(){
        NSLayoutConstraint.activate([
            searchOptionsCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchOptionsCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            searchOptionsCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            searchOptionsCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    
    //MARK: CollectinView functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 18
        }
        else if section == 1 {
            return 8
        }
        
        return 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
        
        if indexPath.section == 0{
            header.configure(title: "Types")
        }
        else if indexPath.section == 1{
            header.configure(title: "Region")
        }
        
        return header
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, referenceSizeForHeaderInSection: Int) -> CGSize{
        return CGSize(width: view.frame.size.width, height: 50)
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCategoryCollectionViewCell.identifier, for: indexPath) as! SearchCategoryCollectionViewCell
        
        if indexPath.section == 0 {
            cell.titleLabel.text = pokemonTypeCategory[indexPath.row].capitalized
            cell.categoryImage.image = UIImage(named: pokemonTypeCategory[indexPath.row])
        }
        else if indexPath.section == 1{
            cell.titleLabel.text = pokemonRegions[indexPath.row].capitalized
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("category selected")
    }
    
    
    

}
