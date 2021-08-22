//
//  PokemonDetailsViewController.swift
//  pokedex
//
//  Created by elliott kung on 2021-08-05.
//

import UIKit

struct PokemonEvolutionHierarchy{
    var pokemonName: String
    var evolutionLevel: Int
}

class PokemonDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    // MARK: UI Components
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .blue
        indicator.style = .large
        indicator.hidesWhenStopped = true
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var pokemonTableView: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), style: .insetGrouped)
        table.backgroundColor = .clear
        table.dataSource = self
        table.delegate = self
        table.layer.cornerRadius = 25
        table.layer.borderWidth = 5
        table.layer.borderColor = UIColor.white.cgColor
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    private lazy var pokemonView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        view.backgroundColor = .clear
        //view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var pokemonImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.contentMode = .scaleAspectFill
        //imageView.backgroundColor = .cyan
        let url = URL(string: pokemonImage ?? "")
        let data = try? Data(contentsOf: url!)
        imageView.image = UIImage(data: data!) ?? UIImage(systemName: "questionmark.circle")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Properties
    var pokemonDetail: PokemonDetails?
    var pokemonList: [PokemonDetails] = []
    var pokemonSpeciesDetails: PokemonSpecies?
    var pokemonEvolutionDetails: PokemonEvolutions?
    var pokemonImage: String?
    var pokemonTypeColors: [UIColor] = []
    var pokemonTypes: [String] = []
    var pokemonEvolutionImage: [UIImage] = []
    var evolutionLevel = 1
    var pokemonEvolutions: [PokemonEvolutionHierarchy] = []
    var pokemonFact: String?
    
    private var isWaiting = false{
        didSet{
            self.updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activateIndicatorConstraints()
        isWaiting = true
        guard let pokemonDetail = pokemonDetail else { return }
        fetchData(speciesUrl: pokemonDetail)
        setupViewController()
        
    }
    
    // MARK: ViewController Setup
    private func setupViewController(){
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: Fetch Data and UIUpdate
    
    private func updateUI(){
        if isWaiting{
            print("API running")
        }else{
            view.backgroundColor = .clear
            activityIndicator.stopAnimating()
            getEvolutionNames(evolutionChain: pokemonEvolutionDetails!.chain)
            getSpriteImage(pokemonNames: pokemonEvolutions)
            setupPokemonTypesAndColors()
            
            view.addSubview(pokemonView)
            pokemonView.addSubview(pokemonImageView)
            view.addSubview(pokemonTableView)
            registerCells()
            activateDetailConstraints()
            
            pokemonView.layer.insertSublayer(PokemonColors.shared.createPokemonTypesGradient(
                                                colors: pokemonTypeColors,
                                                startCoordinate: .unitCoordinate(.topLeft),
                                                endCoordinate: .unitCoordinate(.bottomRight),
                                                frame: pokemonView.frame), at: 0)
           
            pokemonTableView.layer.insertSublayer(PokemonColors.shared.createPokemonTypesGradient(
                                                    colors: pokemonTypeColors,
                                                    startCoordinate: .unitCoordinate(.topLeft),
                                                    endCoordinate: .unitCoordinate(.bottomRight),
                                                    frame: pokemonTableView.frame), at: 0)
        }
    }
    
    private func setupPokemonTypesAndColors(){
        guard let pokemonDetail = pokemonDetail else { return }
        for type in pokemonDetail.types{
            let pokemonType = type.type.name
            pokemonTypes.append(pokemonType)
            let color = PokemonColors.shared.pokemonGradientColors(pokemonType: pokemonType)
            pokemonTypeColors.append(color)
        }
    }
    
    private func registerCells(){
        pokemonTableView.register(PokemonFlavorTextTableViewCell.self, forCellReuseIdentifier: PokemonFlavorTextTableViewCell.identifier)
        pokemonTableView.register(PokemonEvolutionsTableViewCell.self, forCellReuseIdentifier: PokemonEvolutionsTableViewCell.identifier)
    }
    
    func activateIndicatorConstraints(){
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func activateDetailConstraints(){
        NSLayoutConstraint.activate([
            
            pokemonView.topAnchor.constraint(equalTo: self.view.topAnchor),
            pokemonView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            pokemonView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            pokemonView.bottomAnchor.constraint(equalTo: pokemonTableView.topAnchor, constant: 50),
            
            pokemonTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 250),
            pokemonTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            pokemonTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            pokemonTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            pokemonImageView.centerXAnchor.constraint(equalTo: pokemonView.centerXAnchor),
            pokemonImageView.centerYAnchor.constraint(equalTo: pokemonView.centerYAnchor, constant: 50),
            pokemonImageView.widthAnchor.constraint(equalTo: pokemonView.widthAnchor, constant: -200),
            pokemonImageView.heightAnchor.constraint(equalTo: pokemonView.heightAnchor, constant: -200),
        ])
    }
    
    private func fetchData(speciesUrl: PokemonDetails){
        
        NetworkEngine.shared.getPokemonSpeciesDetails(pokemonSpecies: speciesUrl) { [weak self] result in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                switch result{
                
                case .success(let pokemonSpecies):
                    strongSelf.pokemonSpeciesDetails = pokemonSpecies
                    
                    NetworkEngine.shared.getPokemonEvolutionChain(pokemonEvolutionList: pokemonSpecies) { [weak self] result  in
                        guard let strongSelf = self else { return }
                        
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let pokemonEvolution):
                                strongSelf.pokemonEvolutionDetails = pokemonEvolution
                                strongSelf.isWaiting = false
                            case .failure(let error):
                                print("evolution - \(error.rawValue)")
                                self?.pokemonErrorAlertUser(title: "Error", message: error.rawValue)
                            }
                        }
                    }
                    
                case .failure(let error):
                    print("species - \(error.rawValue)")
                    self?.pokemonErrorAlertUser(title: "Error", message: error.rawValue)
                }
            }
        }
    }
    
    // MARK: Evolution Chain Getting Names and Images
    
    func getEvolutionNames(evolutionChain: PokemonEvolutions.Chain){
        //extract chains species name
        let pokemonEvo = PokemonEvolutionHierarchy(pokemonName: evolutionChain.species.name,
                                                   evolutionLevel: evolutionLevel)
        pokemonEvolutions.append(pokemonEvo)
        
        //check if chain has any chainlinks in evolve to
        if !evolutionChain.evolves_to.isEmpty{
            evolutionLevel += 1
            traverseChain(chainLink: evolutionChain.evolves_to)
        }
    }
    
    
    func traverseChain(chainLink: [PokemonEvolutions.ChainLink]){
        
        var pokemonEvo: PokemonEvolutionHierarchy
        
        if chainLink.count > 1 {
            for item in chainLink{
                pokemonEvo = PokemonEvolutionHierarchy(pokemonName: item.species.name,
                                                                                 evolutionLevel: evolutionLevel)
                pokemonEvolutions.append(pokemonEvo)
            }
        }
        else{
            for item in chainLink{
                
                pokemonEvo = PokemonEvolutionHierarchy(pokemonName: item.species.name,
                                                                                 evolutionLevel: evolutionLevel)
                pokemonEvolutions.append(pokemonEvo)
                
                if !item.evolves_to.isEmpty{
                    evolutionLevel += 1
                    traverseChain(chainLink: item.evolves_to)
                }
            }
        }
    }
    
    
    func getSpriteImage(pokemonNames: [PokemonEvolutionHierarchy]){
        for name in pokemonNames {
            if let pokemon =  pokemonList.first(where: {$0.name == name.pokemonName}){
                let url = URL(string: pokemon.sprites.front_default ?? "")
                let data = try? Data(contentsOf: url!)
                pokemonEvolutionImage.append((UIImage(data: data!) ?? UIImage(systemName: "questionmark.circle"))!)
            }
        }
    }
    
    
    
    // MARK: TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return pokemonTypes.count
        }
        else if section == 1{
            return 1
        }
        else if section == 2{
            return pokemonEvolutions.count
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.red
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
        header.textLabel?.font = UIFont(name: "Arial", size: 15)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Type"
        case 1:
            return "About"
        case 2:
            return "Evolutions"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.textAlignment = .center
        
        if indexPath.section == 0{
            cell.textLabel?.text = pokemonTypes[indexPath.row].capitalized
            return cell
        }
        else if indexPath.row == 0 && indexPath.section == 1{
            let cellFlavor = tableView.dequeueReusableCell(withIdentifier: PokemonFlavorTextTableViewCell.identifier, for: indexPath) as! PokemonFlavorTextTableViewCell
            cellFlavor.pokemonFlavorTextViewModel = PokemonFlavorTextViewModel(pokemonSpeciesDetails!)
            cellFlavor.delegate = self
            
            if let pokemonFact = pokemonFact{
                cellFlavor.pokemonFlavorTextViewModel.flavorText = pokemonFact
            }else{
                pokemonFact = cellFlavor.setInitialFlavorText()
            }
            return cellFlavor
            
        }
        else if  indexPath.section == 2{
            let cellEvolution = tableView.dequeueReusableCell(withIdentifier: PokemonEvolutionsTableViewCell.identifier, for: indexPath) as! PokemonEvolutionsTableViewCell
            cellEvolution.pokemonEvolutionsModel = PokemonEvolutionsViewModel( pokemonEvolutionImage[indexPath.row], pokemonEvolutions[indexPath.row])
            return cellEvolution
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section == 1 && indexPath.row == 0{
            tableView.cellForRow(at: indexPath)?.selectionStyle = .none
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 50
        }
        else if indexPath.section == 1 && indexPath.row == 1{
            return 50
        }
        else if indexPath.section == 1 && indexPath.row == 0{
            return 200
        }
        return 100
    }
    
}


extension PokemonDetailsViewController: PokemonFlavorTextTableViewCellDelegate{
    
    func pokemonFlavorTextTableViewCell(_ cell: PokemonFlavorTextTableViewCell, didTapWith viewModel: PokemonFlavorTextViewModel) {
        pokemonFact = viewModel.flavorText
    }
    
}
