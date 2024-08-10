//
//  GameLogic.swift
//  Color Flow
//
//  Created by Павел Петров on 12.04.2024.
//

import Foundation
import Collections

struct Coordinate: Hashable {
    let row: Int
    let column: Int
    
    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
    }
    
    // Необходимые функции для использования в Set
    static func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }
}

class GameLogic {
    let colors = ["violet1", "pink1", "orange1", "yellow1", "green1", "lime1"]
    var ownershipMap: [[Int]] = []  // 0 - ничья, 1 - игрок, 2 - противник
    var cache = [Coordinate: Set<Coordinate>]()

    
    func fillGridRandomly(gridSize: Int) -> [[String]] {
        var grid = [[String]]()
        ownershipMap = Array(repeating: Array(repeating: 0, count: gridSize), count: gridSize)
        
        // Инициализация списка доступных цветов
        let colors = colors
        
        // Начальные клетки игрока и противника
        var startColor: String?
        var opponentColor: String?
        
        // Заполнение сетки случайными цветами
        for _ in 0..<gridSize {
            var row = [String]()
            for _ in 0..<gridSize {
                let randomIndex = Int.random(in: 0..<colors.count)
                let randomColor = colors[randomIndex]
                row.append(randomColor)
            }
            grid.append(row)
        }
        
        // Установка начальных цветов игрока и противника
        startColor = grid[0][0]
        opponentColor = grid[gridSize - 1][gridSize - 1]
        
        // Проверка на совпадение начальных цветов
        while startColor == opponentColor {
            // Если цвета совпадают, перезаполните последнюю клетку противника новым случайным цветом
            var randomColor: String
            
            repeat {
                let randomIndex = Int.random(in: 0..<colors.count)
                randomColor = colors[randomIndex]
            } while randomColor == startColor
            
            // Присваиваем новому цвету последнюю клетку противника
            grid[gridSize - 1][gridSize - 1] = randomColor
            
            // Обновляем цвет противника
            opponentColor = randomColor
        }
        
        ownershipMap[0][0] = 1  // принадлежит игроку
        ownershipMap[gridSize - 1][gridSize - 1] = 2  // принадлежит противнику
        
        return grid
    }
    
//    //алгоритм в глубину
//    func findConnectedCells(grid: [[String]], row: Int, column: Int) -> Set<Coordinate> {
//        var connectedCells = Set<Coordinate>()
//        let targetColor = grid[row][column]
//        var visited = Set<Coordinate>()
//        
//        func dfs(row: Int, column: Int) {
//            if row < 0 || row >= grid.count || column < 0 || column >= grid[row].count || visited.contains(Coordinate(row, column)) || grid[row][column] != targetColor {
//                return
//            }
//            
//            visited.insert(Coordinate(row, column))
//            connectedCells.insert(Coordinate(row, column))
//            
//            // Проверяем соседние клетки
//            dfs(row: row + 1, column: column)
//            dfs(row: row - 1, column: column)
//            dfs(row: row, column: column + 1)
//            dfs(row: row, column: column - 1)
//        }
//        //отдельный поток асин или колбэк
//        dfs(row: row, column: column)
//        
//        return connectedCells
//    }
    //алгоритм в ширину
    func findConnectedCells(grid: [[String]], row: Int, column: Int, ownership: Int) -> Set<Coordinate> {
        let startCoordinate = Coordinate(row, column)
        
//        // Проверка в кэше: если результат для этой стартовой клетки уже вычислен, используем его
//        if let cachedResult = cache[startCoordinate] {
//            return cachedResult
//        }
        
        var connectedCells = Set<Coordinate>()
        let targetColor = grid[row][column]
        var visited = Set<Coordinate>()
        var queue = Deque<(row: Int, column: Int)>()
        
        queue.append((row, column))
        
        while !queue.isEmpty {
            let (currentRow, currentColumn) = queue.removeFirst()
            
            // Проверка границ сетки
            guard currentRow >= 0 && currentRow < grid.count && currentColumn >= 0 && currentColumn < grid[currentRow].count else {
                continue
            }
            
            let currentCoordinate = Coordinate(currentRow, currentColumn)
            
            // Пропускаем уже посещенные клетки
            if visited.contains(currentCoordinate) {
                continue
            }
            
            // Если цвет не совпадает или клетка принадлежит другому игроку, пропускаем клетку
            if grid[currentRow][currentColumn] != targetColor && ownershipMap[currentRow][currentColumn] != ownership {
                continue
            }
            
            // Помечаем клетку как посещенную и добавляем в connectedCells
            visited.insert(currentCoordinate)
            connectedCells.insert(currentCoordinate)
            
            // Добавляем соседние клетки в очередь
            queue.append((currentRow + 1, currentColumn))
            queue.append((currentRow - 1, currentColumn))
            queue.append((currentRow, currentColumn + 1))
            queue.append((currentRow, currentColumn - 1))
        }
        
//        // Сохраняем результат в кэш
//        cache[startCoordinate] = connectedCells
        
        return connectedCells
    }



    func updateCellColors(grid: inout [[String]], row: Int, column: Int, newColor: String, ownership: Int) {
        guard row >= 0 && row < grid.count && column >= 0 && column < grid[row].count else {
            return
        }
        
//        // Очистка кэша перед обновлением цветов
//        cache.removeAll()
        
        let connectedCells = findConnectedCells(grid: grid, row: row, column: column, ownership: ownership)
        
        //print("Обновляем клетки: \(connectedCells)")
        
        // Обновляем цвета и проверяем владение клетками
        for coordinate in connectedCells {
            grid[coordinate.row][coordinate.column] = newColor
            ownershipMap[coordinate.row][coordinate.column] = ownership
        }
    }
    
    func countPlayerCells(grid: [[String]]) -> Int {
        // Начальная клетка (0, 0)
        let startRow = 0
        let startColumn = 0
        
        // Используем метод findConnectedCells, чтобы найти все связанные клетки
        let connectedCells = findConnectedCells(grid: grid, row: startRow, column: startColumn, ownership: 1)
        
        // Подсчитываем количество клеток, связанных с начальной клеткой
        return connectedCells.count
    }
    
    func countOpponentCells(gridSize: Int ,grid: [[String]]) -> Int {
        // Начальная клетка
        let startRow = gridSize - 1
        let startColumn = gridSize - 1
        
        // Используем метод findConnectedCells, чтобы найти все связанные клетки
        let connectedCells = findConnectedCells(grid: grid, row: startRow, column: startColumn, ownership: 2)
        
        // Подсчитываем количество клеток, связанных с начальной клеткой
        return connectedCells.count
    }
    
    func easyDifficultyAI(grid: inout [[String]], gridSize: Int) -> String?{
        let playerColor = grid[0][0]
        let opponentColor = grid[gridSize - 1][gridSize - 1]
        
        let availableColors = colors.filter { $0 != playerColor && $0 != opponentColor }
        
        guard !availableColors.isEmpty else {
            print("Error: not found colors")
            return nil
        }
        
        let randomIndex = Int.random(in: 0..<availableColors.count)
        let chosenColor = availableColors[randomIndex]
        
        print("Противник выбрал цвет \(chosenColor)")
        
        return chosenColor
    }
    
    func hardDifficultyAI(grid: inout [[String]], gridSize: Int) -> String? {
        let playerColor = grid[0][0]
        let opponentColor = grid[gridSize - 1][gridSize - 1]
        
        let availableColors = colors.filter { $0 != playerColor && $0 != opponentColor }
        
        guard !availableColors.isEmpty else {
                print("Ошибка: не найдено доступных цветов")
                return nil
            }
        
        var bestColor: String?
        var maxCapturedCells = 0
        
        for color in availableColors {
            var simulatedGrid = grid
            
            updateCellColors(grid: &simulatedGrid, row: gridSize - 1, column: gridSize - 1, newColor: color, ownership: 2)
            
            let opponentControlledCells = countOpponentCells(gridSize: gridSize, grid: simulatedGrid)
            
            if opponentControlledCells > maxCapturedCells {
                maxCapturedCells = opponentControlledCells
                bestColor = color
            }
        }
        
        if let chosenColor = bestColor {
            print("Противник выбрал \(chosenColor)")
            return chosenColor
        }
        
        return availableColors.first
    }
}
