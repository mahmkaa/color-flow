//
//  GameLogic.swift
//  Color Flow
//
//  Created by Павел Петров on 12.04.2024.
//

import Foundation

class GameLogic {
    let colors = ["violet1", "pink1", "orange1", "yellow1", "green1", "lime1"]
    
    func fillGridRandomly(gridSize: Int) -> [[String]] {
        var grid = [[String]]()
        
        for _ in 0..<gridSize {
            var row = [String]()
            for _ in 0..<gridSize {
                let randomIndex = Int.random(in: 0..<colors.count)
                let randomColor = colors[randomIndex]
                row.append(randomColor)
            }
            grid.append(row)
        }
        
        return grid
    }
}
