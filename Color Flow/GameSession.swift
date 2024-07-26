//
//  GameSession.swift
//  Color Flow
//
//  Created by Павел Петров on 25.07.2024.
//

import Foundation
import UIKit

struct GameSession: Codable {
    let grid: [[String]]
    let currentPlayer: Int
    let playerGameScore: Int
    let opponentGameScore: Int
}
