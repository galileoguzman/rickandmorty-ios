//
//  NetworkManager.swift
//  RickAndMorty
//
//  Created by Galileo Guzman on 16/01/21.
//


import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let BASE_URL = "https://rickandmortyapi.com/api/character"
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getCharacters(for page: Int, completed: @escaping(Result<Characters, RMError>) -> Void ) {
        let endpoint = "\(BASE_URL)?page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.unableToComplete))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error{
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let characters = try decoder.decode(Characters.self, from: data)
                completed(.success(characters))
            } catch {
                completed(.failure(.invalidData))
            }
            
        }
        
        task.resume()
    }
    
}
