//
//  Character.swift
//  RickAndMorty
//
//  Created by Galileo Guzman on 16/01/21.
//

import Foundation

struct Character: Codable, Hashable{
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String
}
