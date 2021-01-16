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
        navigationItem.title = "Ryck and morty"
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
        getCharacters(page: page)
    }
    
    func getCharacters(page: Int){
        
        showLoadingView()
        
        NetworkManager.shared.getCharacters(for: page) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
                case .success(let characters):
                    if(characters.results.count > 0){
                        self.characters.append(contentsOf: characters.results)
                        self.reloadData()
                    }
                case .failure(let error):
                    print("Error calling service")
                    print(error.rawValue)
            }
            
            self.dismissLoadingView()
            
        }
    }
    
    private func reloadData() {
        // Function in charge to refresh UI with articles
        DispatchQueue.main.async {
            self.tblCharacters.reloadData()
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
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterCell.reuseID,
            for: indexPath
        ) as! CharacterCell
        
        // Set data
        let character = self.characters[indexPath.row]
        cell.lblName.text = character.name
        cell.downloadImage(from: character.image)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.frame.size.height
        let height = scrollView.contentSize.height
        
        if ((offsetY + contentHeight) == height) {
            page += 1
            getCharacters(page: page)
        }
    }
}
