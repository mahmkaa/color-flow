//
//  GameSessionPvp.swift
//  Color Flow
//
//  Created by Павел Петров on 01.08.2024.
//

import Foundation
import UIKit

struct GameSessionPvp: Codable {
    let grid: [[String]]
    let currentPlayer: Int
    let playerGameScore: Int
    let opponentGameScore: Int
}

