//
//  GameEnums.swift
//  Color Flow
//
//  Created by Павел Петров on 27.07.2024.
//

import Foundation

enum GameMode: String, Codable {
    case pvp
    case pve
}

enum Difficulty: String, Codable {
    case easy
    case hard
}

enum GameState: String, Codable {
    case new
    case proceed
}
