//
//  CharactersVC.swift
//  RickAndMorty
//
//  Created by Galileo Guzman on 16/01/21.
//

import UIKit

class CharactersVC: UIViewController {
    
    enum Section {
        case first
    }
    
    var characters: [Character] = []
    var page = 0

    @IBOutlet weak var tblCharacters: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Popular movies"
    }
    
    func initController(){
        print("CharactersVC")
        
        // View customization
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Registering cell for table view
        tblCharacters.register(
            UINib(nibName: "CharacterCell", bundle: nil),
            forCellReuseIdentifier: CharacterCell.reuseID
        )
        
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
    
    func updateData(on newCharacters: [Character]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
        snapshot.appendSections([.first])
        snapshot.appendItems(newCharacters)
        
        DispatchQueue.main.async {
            //self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension CharactersVC:UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.characters.count
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(CharacterCell.heightCell)
    }
    
    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Will fetch more articles
//        if indexPath.row == (self.articles.count - 1){
//            page += 1
//            self.fetchArticles(page: page)
//        }
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Show detail of article")
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterCell.reuseID,
            for: indexPath
        ) as! CharacterCell
        
        // Set data
        let character = self.characters[indexPath.row]
        cell.downloadImage(from: character.image)
        
        return cell
    }
}
