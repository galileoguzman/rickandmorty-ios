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
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Ryck and morty characters"
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
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        tblCharacters.addSubview(refreshControl)
        
        
        // Get characters from the API
        getCharacters(page: page)
    }
    
    func getCharacters(page: Int){
        NetworkManager.shared.getCharacters(for: page) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                case .success(let characters):
                    self.characters.append(contentsOf: characters.results)
                    self.reloadData()
                case .failure(let error):
                    print("Error calling service")
                    print(error.rawValue)
            }
        }
    }
    
    @objc fileprivate func updateData() {
        // Function in charge to reset all articles.
        page = 1
        getCharacters(page: page)
    }
    
    private func reloadData() {
        // Function in charge to refresh UI with articles
        DispatchQueue.main.async {
            self.tblCharacters.reloadData()
            
            self.refreshControl.endRefreshing()
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
