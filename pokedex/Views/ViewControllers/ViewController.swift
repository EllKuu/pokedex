//
//  ViewController.swift
//  pokedex
//
//  Created by elliott kung on 2021-07-18.
//

import UIKit
import Foundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, SelectedCategoryProtocol, UIScrollViewDelegate {
    
   // MARK: Properties and UIComponents
    var pokemonListResult: PokemonList?
    private var pokemonDetailsArray = [PokemonDetails]()
    var filteredPokemonDetailsArray = [PokemonDetails]()
    
    var isSearchBarEmpty: Bool{
        return searchResultsController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchResultsController.isActive && !isSearchBarEmpty
    }
    
    private var isWaiting = false{
        didSet{
            self.updateUI()
        }
    }
    
    private lazy var pokemonCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cellWidthHeightConstant: CGFloat = view.frame.size.width / 2.5
        
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: 5,
                                           bottom: 0,
                                           right: 5)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 6
        layout.itemSize = CGSize(width: cellWidthHeightConstant + 30, height: cellWidthHeightConstant)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: "PokemonCollectionViewCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.keyboardDismissMode = .onDrag
        
        return collectionView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .blue
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    

    let resultsController = SearchResultsViewController()
    var searchResultsController = UISearchController()
    var searchController = UISearchController()

    // MARK: Loading and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isWaiting = true
        self.view.backgroundColor = .white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        title = "PokeDex"
        fetchData()
        activateIndicatorConstraints()
    }
    
    func setupNavigationAndSearchbar(){
        resultsController.delegate = self
        searchResultsController = UISearchController(searchResultsController: resultsController)
        navigationItem.searchController = searchResultsController
        self.definesPresentationContext = true
        searchResultsController.searchResultsUpdater = self
        searchResultsController.delegate = self
        searchResultsController.searchBar.delegate = self
        searchResultsController.obscuresBackgroundDuringPresentation = false
        searchResultsController.searchBar.placeholder = "Search Pokemon"
        searchResultsController.showsSearchResultsController = true
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    func updateUI(){
        if isWaiting{
            print("API running")
        }else{
            activityIndicator.stopAnimating()
            setupNavigationAndSearchbar()
            self.view.addSubview(pokemonCollectionView)
            self.view.backgroundColor = .white
            self.pokemonDetailsArray.sort(by: {$0.id < $1.id})
            activateCollectionViewConstraints()
        }
    }
    
    func activateIndicatorConstraints(){
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
    }
    
    func activateCollectionViewConstraints(){
        NSLayoutConstraint.activate([
            pokemonCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            pokemonCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            pokemonCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            pokemonCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
                                self?.pokemonErrorAlertUser(title: "Error", message: error.rawValue)
                            }
                        }
                    }// end of getPokemonDetails
                
                case .failure(let error):
                    print("PokemonList - \(error.rawValue)")
                    self?.pokemonErrorAlertUser(title: "Error", message: error.rawValue)
                }
            }
        }// end of getPokemonList
    }
    
    
    // MARK: UICollectionView Functions
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering{
            return filteredPokemonDetailsArray.count
        }
        return pokemonDetailsArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as! PokemonCollectionViewCell
        
        if isFiltering{
            cell.pokemonDetailsModel = PokemonViewModel(filteredPokemonDetailsArray[indexPath.row])
        }else{
            cell.pokemonDetailsModel = PokemonViewModel(pokemonDetailsArray[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PokemonDetailsViewController()
        
        vc.modalPresentationStyle = .formSheet
        vc.pokemonList = pokemonDetailsArray
        if isFiltering{
            vc.title = "\(filteredPokemonDetailsArray[indexPath.row].name.capitalized)"
            vc.pokemonDetail = filteredPokemonDetailsArray[indexPath.row]
            vc.pokemonImage = filteredPokemonDetailsArray[indexPath.row].sprites.front_default
        }else{
            vc.title = "\(pokemonDetailsArray[indexPath.row].name.capitalized)"
            vc.pokemonDetail = pokemonDetailsArray[indexPath.row]
            vc.pokemonImage = pokemonDetailsArray[indexPath.row].sprites.front_default
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: Searching Functions
    
    func didSelectCategory(text: String) {
        searchResultsController.searchBar.text = text
        searchResultsController.showsSearchResultsController = false
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
        filterPokemonForSearchText(text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("search began")
        if searchBar.searchTextField.text == "" {
            searchResultsController.showsSearchResultsController = true
        }
        else{
            searchResultsController.showsSearchResultsController = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.searchTextField.text == "" {
            searchResultsController.showsSearchResultsController = true
        }
        else{
            searchResultsController.showsSearchResultsController = false
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search clicked")
        searchResultsController.showsSearchResultsController = false
    }
    
    
    
    func filterPokemonForSearchText(_ searchText: String){
        print("filtering")
        filteredPokemonDetailsArray = pokemonDetailsArray.filter({ (pokemon: PokemonDetails) -> Bool in
            let type = pokemon.types.contains { pokemon in
                pokemon.type.name.lowercased() == searchText.lowercased()
            }
            
            let name =  pokemon.name.lowercased().contains(searchText.lowercased())
            
            let region = findPokemonByRegion(region: searchText)
            let pokemonByRegion = region.contains(pokemon.id)
            
            return type || name || pokemonByRegion
            
        })
        pokemonCollectionView.reloadData()
    }
    
    func findPokemonByRegion(region: String) -> [Int]{
        var regionRange = [Int]()
        switch region.lowercased() {
        case "kanto":
            regionRange = Array(1...151)
        case "johto":
            regionRange = Array(152...251)
        case "hoenn":
            regionRange = Array(252...386)
        case "sinnoh":
            regionRange = Array(387...493)
        case "unova":
            regionRange = Array(494...649)
        case "kalos":
            regionRange = Array(650...721)
        case "alola":
            regionRange = Array(722...809)
        case "galar":
            regionRange = Array(810...898)
        default:
            regionRange = []
        }
        return regionRange
    }
    
    
    
} // end of class VC

