//
//  RMError.swift
//  RickAndMorty
//
//  Created by Galileo Guzman on 16/01/21.
//

import Foundation

enum RMError: String, Error {
    case unableToComplete = "Unable to complete your request."
    case invalidResponse = "Invalid server response."
    case invalidData = "Invalid data."
}
