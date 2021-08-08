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
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .white
        table.dataSource = self
        table.delegate = self
        table.layer.cornerRadius = 25
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var pokemonView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 500))
        view.backgroundColor = .yellow
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
    var pokemonSpeciesDetails: PokemonSpecies?
    var pokemonEvolutionDetails: PokemonEvolutions?
    var pokemonImage: String?
    var pokemonTypeColors: [UIColor] = []
    
    
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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
    }
    
    // MARK: Fetch Data and UIUpdate
    
    private func updateUI(){
        if isWaiting{
            print("API running")
        }else{
            view.backgroundColor = .blue
           
            view.addSubview(pokemonView)
            pokemonView.addSubview(pokemonImageView)
            pokemonView.bringSubviewToFront(pokemonImageView)
            
            guard let pokemonDetail = pokemonDetail else { return }
            for type in pokemonDetail.types{
                let pokemonType = type.type.name
                let color = PokemonColors.shared.pokemonGradientColors(pokemonType: pokemonType)
                pokemonTypeColors.append(color)
            }
            
            let gradient = CAGradientLayer()
            var cgColors: [CGColor] = pokemonTypeColors.map({ $0.cgColor })
            if cgColors.count == 1 {
                cgColors.insert(UIColor.white.cgColor, at: 0)
            }
            gradient.colors =  cgColors
            gradient.frame = pokemonView.frame
            pokemonView.layer.insertSublayer(gradient, at: 0)
            
            view.addSubview(pokemonTableView)
            
            guard let details = pokemonSpeciesDetails, let evolution = pokemonEvolutionDetails else { return }
            print(details)
            print(evolution)
            
            NSLayoutConstraint.activate([
                
                pokemonView.topAnchor.constraint(equalTo: self.view.topAnchor),
                pokemonView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                pokemonView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                pokemonView.bottomAnchor.constraint(equalTo: pokemonTableView.topAnchor, constant: 50),
                
                pokemonTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 250),
                pokemonTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                pokemonTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                pokemonTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                
                pokemonImageView.centerXAnchor.constraint(equalTo: pokemonView.centerXAnchor),
                pokemonImageView.centerYAnchor.constraint(equalTo: pokemonView.centerYAnchor, constant: 50),
                pokemonImageView.widthAnchor.constraint(equalTo: pokemonView.widthAnchor, constant: -200),
                pokemonImageView.heightAnchor.constraint(equalTo: pokemonView.heightAnchor, constant: -200),
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
        
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        switch section {
//        case 0:
//            let view = UIView()
//            view.backgroundColor = .red
//            view.frame = CGRect(x: 0, y: 0, width: self.pokemonTableView.frame.width, height: 100)
//            return view
//        default:
//            return nil
//        }
//
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "About"
        case 1:
            return "Evolutions"
        case 2:
            return "Stats"
        case 3:
            return "Moves"
        case 4:
            return "Details"
        default:
            return "last"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        if indexPath.row == 0{
            cell.textLabel?.text = pokemonSpeciesDetails?.flavor_text_entries[0].flavor_text
            return cell
        }else{
            cell.textLabel?.text = "hi"
            return cell
        }

    }

}
