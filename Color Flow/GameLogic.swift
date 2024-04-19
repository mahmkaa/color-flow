//
//  GameLogic.swift
//  Color Flow
//
//  Created by Павел Петров on 12.04.2024.
//

import Foundation

struct Coordinate: Hashable {
    let row: Int
    let column: Int
    
    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
    }
}

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
    
    func findConnectedCells(grid: [[String]], row: Int, column: Int) -> Set<Coordinate> {
        var connectedCells = Set<Coordinate>()
        let targetColor = grid[row][column]
        var visited = Set<Coordinate>()
        
        func dfs(row: Int, column: Int) {
            if row < 0 || row >= grid.count || column < 0 || column >= grid[row].count || visited.contains(Coordinate(row, column)) || grid[row][column] != targetColor {
                return
            }
            
            visited.insert(Coordinate(row, column))
            connectedCells.insert(Coordinate(row, column))
            
            // Проверяем соседние клетки
            dfs(row: row + 1, column: column)
            dfs(row: row - 1, column: column)
            dfs(row: row, column: column + 1)
            dfs(row: row, column: column - 1)
        }
        
        dfs(row: row, column: column)
        
        return connectedCells
    }
    
    func updateCellColors(grid: inout [[String]], row: Int, column: Int, newColor: String) {
        // Проверяем, находится ли переданный индекс строки в пределах допустимого диапазона
        guard row >= 0 && row < grid.count else {
            return
        }
        
        // Проверяем, находится ли переданный индекс столбца в пределах допустимого диапазона
        guard column >= 0 && column < grid[row].count else {
            return
        }
        
        // Получаем текущий цвет клетки, которую выбрал игрок
        let targetColor = grid[row][column]
        
        // Получаем все связанные клетки с исходной
        let connectedCells = findConnectedCells(grid: grid, row: row, column: column)
        
        // Обновляем цвета связанных клеток на новый цвет игрока
        for coordinate in connectedCells {
            grid[coordinate.row][coordinate.column] = newColor
        }
    }
    
    func countPlayerCells(grid: [[String]], playerColor: String) -> Int {
        var playerCellCount = 0
        
        for row in grid {
            for cell in row {
                if cell == playerColor {
                    playerCellCount += 1
                }
            }
        }
        
        return playerCellCount
    }
}
