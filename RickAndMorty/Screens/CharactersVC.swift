//
//  CharactersVC.swift
//  RickAndMorty
//
//  Created by Galileo Guzman on 16/01/21.
//

import UIKit

class CharactersVC: UIViewController {
    
    var characters: [Character] = []
    var page = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initController()
    }
    
    func initController(){
        print("CharactersVC")
        // Get characters from the API
        getCharacters()
    }
    
    func getCharacters(){
        NetworkManager.shared.getCharacters(for: page) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                case .success(let characters):
                    self.characters.append(contentsOf: characters.results)
                case .failure(let error):
                    print("Error calling service")
                    print(error.rawValue)
            }
        }
    }
}
