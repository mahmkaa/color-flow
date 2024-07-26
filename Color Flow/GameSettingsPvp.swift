//
//  GameSettingsPvp.swift
//  Color Flow
//
//  Created by Павел Петров on 26.07.2024.
//

import Foundation
import UIKit

struct GameSettingsPvp: Codable {
    var gridSize: Int
    var cellSize: CGFloat
    var gameState: String
    var gridSizeSegmentIndex: Int
}

