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
        
        return grid
    }
    //алгоритм в ширину
    func findConnectedCells(grid: [[String]], row: Int, column: Int) -> Set<Coordinate> {
        var connectedCells = Set<Coordinate>()
        let targetColor = grid[row][column]
        
        let semaphore = DispatchSemaphore(value: 0) // Создаем семафор с начальным значением 0
        let queue = DispatchQueue.global(qos: .userInitiated) // Используем глобальную очередь для асинхронного выполнения
        
        queue.async {
            var visited = Set<Coordinate>()
            var cellQueue = [(row: Int, column: Int)]()
            
            cellQueue.append((row, column))
            
            // Выполнение BFS алгоритма
            while !cellQueue.isEmpty {
                let current = cellQueue.removeFirst()
                let currentRow = current.row
                let currentColumn = current.column
                
                guard currentRow >= 0 && currentRow < grid.count && currentColumn >= 0 && currentColumn < grid[currentRow].count else {
                    continue
                }
                
                let currentCoordinate = Coordinate(currentRow, currentColumn)
                
                if visited.contains(currentCoordinate) || grid[currentRow][currentColumn] != targetColor {
                    continue
                }
                
                visited.insert(currentCoordinate)
                connectedCells.insert(currentCoordinate)
                
                cellQueue.append((currentRow + 1, currentColumn))
                cellQueue.append((currentRow - 1, currentColumn))
                cellQueue.append((currentRow, currentColumn + 1))
                cellQueue.append((currentRow, currentColumn - 1))
            }
            
            // Завершаем асинхронную задачу, освобождая семафор
            semaphore.signal()
        }
        
        // Ждем завершения асинхронной задачи
        semaphore.wait()
        
        return connectedCells
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
        
        // Выводим цвет стартовой клетки для проверки
        print("Цвет стартовой клетки: \(targetColor)")
        
        // Получаем все связанные клетки с исходной
        let connectedCells = findConnectedCells(grid: grid, row: row, column: column)
        
        // Обновляем цвета связанных клеток на новый цвет игрока
        for coordinate in connectedCells {
            grid[coordinate.row][coordinate.column] = newColor
        }
    }
    
    func countPlayerCells(grid: [[String]]) -> Int {
        // Начальная клетка (0, 0)
        let startRow = 0
        let startColumn = 0
        
        // Используем метод findConnectedCells, чтобы найти все связанные клетки
        let connectedCells = findConnectedCells(grid: grid, row: startRow, column: startColumn)
        
        // Подсчитываем количество клеток, связанных с начальной клеткой
        return connectedCells.count
    }
    
    func countOpponentCells(gridSize: Int ,grid: [[String]]) -> Int {
        // Начальная клетка
        let startRow = gridSize - 1
        let startColumn = gridSize - 1
        
        // Используем метод findConnectedCells, чтобы найти все связанные клетки
        let connectedCells = findConnectedCells(grid: grid, row: startRow, column: startColumn)
        
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
        
        var gridCopy = grid

        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .userInitiated)
        
        queue.async {
            for color in availableColors {
                var simulatedGrid = gridCopy
                
                self.updateCellColors(grid: &simulatedGrid, row: gridSize - 1, column: gridSize - 1, newColor: color)
                
                let opponentControlledCells = self.countOpponentCells(gridSize: gridSize, grid: simulatedGrid)
                
                if opponentControlledCells > maxCapturedCells {
                    maxCapturedCells = opponentControlledCells
                    bestColor = color
                }
            }

            // Завершаем асинхронную задачу, освобождая семафор
            semaphore.signal()
        }
        
        // Ждем завершения асинхронной задачи
        semaphore.wait()
        
        if let chosenColor = bestColor {
            print("Противник выбрал \(chosenColor)")
            return chosenColor
        }
        
        return availableColors.first
    }


}
