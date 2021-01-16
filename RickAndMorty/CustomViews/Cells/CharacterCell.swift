//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by Galileo Guzman on 16/01/21.
//

import UIKit

class CharacterCell: UITableViewCell {
    
    // ----
    static let reuseID = "characterCell"
    static let heightCell = 120
    let cache = NetworkManager.shared.cache
    
    // Views
    @IBOutlet weak var imgCharacter: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func downloadImage(from urlString: String) {
        
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            self.imgCharacter.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            
            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.imgCharacter.image = image
            }
        }
        
        task.resume()
    }
    
}
