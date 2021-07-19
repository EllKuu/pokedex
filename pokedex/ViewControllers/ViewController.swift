//
//  ViewController.swift
//  pokedex
//
//  Created by elliott kung on 2021-07-18.
//

import UIKit

class ViewController: UIViewController {

    let network = NetworkEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        network.getPokemonData()
    }


}

