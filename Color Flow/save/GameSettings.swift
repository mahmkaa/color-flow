//
//  GameSettings.swift
//  Color Flow
//
//  Created by Павел Петров on 24.07.2024.
//

import Foundation
import UIKit

struct GameSettings: Codable {
    var gridSize: Int
    var cellSize: CGFloat
    var gameDifficulty: String
    var gameState: String
    var gridSizeSegmentIndex: Int
    var difficultySegmentIndex: Int
}
