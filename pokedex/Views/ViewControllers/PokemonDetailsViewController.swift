//
//  PokemonDetailsViewController.swift
//  pokedex
//
//  Created by elliott kung on 2021-08-05.
//

import UIKit

class PokemonDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UI Components
    
    private lazy var pokemonTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .green
        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: Properties
    var pokemonDetail: PokemonDetails?
    var pokemonSpeciesDetails: PokemonSpecies?
    var pokemonEvolutionDetails: PokemonEvolutions?
    
    private var isWaiting = false{
        didSet{
            self.updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        isWaiting = true
        guard let pokemonDetail = pokemonDetail else { return }
        fetchData(speciesUrl: pokemonDetail)
        view.backgroundColor = .red
        
    }
    
    // MARK: Fetch Data and UIUpdate
    
    private func updateUI(){
        if isWaiting{
            print("API running")
        }else{
            view.backgroundColor = .white
            view.addSubview(pokemonTableView)
            
            guard let details = pokemonSpeciesDetails, let evolution = pokemonEvolutionDetails else { return }
            print(details)
            print(evolution)
            
            NSLayoutConstraint.activate([
                pokemonTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                pokemonTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                pokemonTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                pokemonTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
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
                            }
                        }
                    }
                    
                case .failure(let error):
                    print("species - \(error.rawValue)")
                }
            }
        }
        
    } // end of fetch data
    
    

    
    // MARK: TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "start"
        case 2:
            return "next"
        case 3:
            return "next one"
        case 4:
            return "next to one"
        default:
            return "last"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "hi"
        return cell
    }

}
