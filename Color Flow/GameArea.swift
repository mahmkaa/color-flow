//
//  GameArea.swift
//  Color Flow
//
//  Created by Павел Петров on 09.04.2024.
//

import UIKit
import SnapKit

class GameArea: UIViewController {
    var grid = [[String]]()
    let gameLogic = GameLogic()
    
    let exit = UIButton(type: .system)
    let button = UIButton(type: .system)
    var colorButtons: [UIButton] = []
    
    let tutorialLabel = UILabel()
    let scoreLabelP1 = UILabel()
    
    var gridSize: Int = 0
    var cellSize: CGFloat = 0.0
    var cells = [UIView]()
    
    var previousPlayerColor: String?
    var previousOpponentColor: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGrid()
        setupUI()
        
        
        let swipeExit = UIPinchGestureRecognizer(target: self, action: #selector(confirmExit))
        view.addGestureRecognizer(swipeExit)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLabelDisappearance(label: tutorialLabel)
    }
    
    func setupUI(){
        let frameCount = 26
        var frames = [UIImage]()
        
        for index in 1...frameCount {
            let frameName = "backGif\(index)"
            if let image = UIImage(named: frameName) {
                frames.append(image)
            } else {
                print("Не удалось загрузить изображение: \(frameName)")
            }
        }
        
        let background = UIImageView()
        background.frame = view.bounds
        background.contentMode = .scaleAspectFill
        view.addSubview(background)
        view.sendSubviewToBack(background)
        
        background.animationImages = frames
        background.animationDuration = 3
        background.animationRepeatCount = 0
        background.startAnimating()
        
        //        let background: UIImageView = {
        //            let imageView = UIImageView(image: UIImage(named: "nightSky"))
        //            imageView.contentMode = .scaleAspectFill
        //            imageView.translatesAutoresizingMaskIntoConstraints = false
        //            return imageView
        //        }()
        //        view.addSubview(background)
        //        view.sendSubviewToBack(background)
        
        
        let exitButton = exit
        //exitButton.setTitle("Exit", for: .normal)
        //exitButton.backgroundColor = .white
        //exitButton.setTitleColor(.black, for: .normal)
        exitButton.setImage(UIImage(systemName: "figure.walk.arrival"), for: .normal)
        exitButton.tintColor = .white
        exitButton.addTarget(self, action: #selector(confirmExit), for: .touchUpInside)
        view.addSubview(exitButton)
        
        
        let label = tutorialLabel
        label.text = "Для выхода используйте жест масштабирования"
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        view.bringSubviewToFront(label)
        
        let scoreLabel1 = scoreLabelP1
        scoreLabel1.textColor = UIColor.white
        scoreLabel1.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        scoreLabel1.textAlignment = .center
        scoreLabel1.numberOfLines = 1
        scoreLabel1.layer.cornerRadius = 10
        scoreLabel1.clipsToBounds = true
        view.addSubview(scoreLabel1)
        view.bringSubviewToFront(scoreLabel1)
        
        updateScoreLabel()
        
        //Настройка кнопок
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        let colors = ["violet1", "pink1", "orange1", "yellow1", "green1", "lime1"]
        
        for colorName in colors {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: colorName), for: .normal)
            button.addTarget(self, action: #selector(colorButtonTap(_:)), for: .touchUpInside)
            button.tag = colors.firstIndex(of: colorName) ?? 0
            stackView.addArrangedSubview(button)
            colorButtons.append(button)
            
            button.snp.makeConstraints { make in
                make.width.height.equalTo(60)
            }
        }
        
        disableButtonsForColors()
        
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        exitButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-10)
            make.height.width.equalTo(50)
        }
        
        tutorialLabel.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(300)
            make.centerX.centerY.equalToSuperview()
        }
        
        scoreLabelP1.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(stackView.snp.top).offset(-30)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-70)
        }
    }
    
    func setupGrid() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        view.addSubview(stackView)
        
        grid = gameLogic.fillGridRandomly(gridSize: gridSize)
        
        for row in grid {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.alignment = .center
            rowStack.spacing = 0
            
            stackView.addArrangedSubview(rowStack)
            
            for colorName in row {
                let cell = UIView()
                cell.backgroundColor = UIColor(named: colorName)
                cell.layer.borderWidth = 0
                cell.layer.borderColor = UIColor.white.cgColor
                rowStack.addArrangedSubview(cell)
                
                cell.snp.makeConstraints { make in
                    make.width.height.equalTo(cellSize)
                }
                
                cells.append(cell)
            }
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func updateGridView() {
        // Проходим по всем клеткам сетки
        for (index, cell) in cells.enumerated() {
            // Получаем соответствующий цвет из сетки
            let row = index / gridSize
            let column = index % gridSize
            let colorName = grid[row][column]
            
            // Устанавливаем цвет клетки в соответствии с данными в сетке
            cell.backgroundColor = UIColor(named: colorName)
        }
    }
    
    func updateScoreLabel() {
        // Подсчитываем количество клеток игрока, связанных с начальной клеткой
        let playerCellCount = gameLogic.countPlayerCells(grid: grid)
        
        // Обновляем текст лейбла
        scoreLabelP1.text = "Счет: \(playerCellCount)"
    }
    
    
    func disableButtonsForColors() {
        // Получаем цвет начальной клетки (0, 0)
        let startColor = grid[0][0]
        // Получаем цвет клетки противника (gridSize - 1, gridSize - 1)
        let opponentColor = grid[gridSize - 1][gridSize - 1]

        // Массив цветов кнопок, соответствующий их порядку
        let colors = ["violet1", "pink1", "orange1", "yellow1", "green1", "lime1"]

        // Проходим по массиву кнопок цветов
        for (index, button) in colorButtons.enumerated() {
            // Получаем цвет кнопки по ее индексу в массиве
            let buttonColor = colors[index]

            // Отключаем кнопку, если ее цвет совпадает с текущим цветом начальной клетки или противника
            if buttonColor == startColor || buttonColor == opponentColor {
                button.isEnabled = false
                button.setImage(UIImage(named: "lightGrey"), for: .disabled)
            } else {
                // Активируем кнопку во всех остальных случаях
                button.isEnabled = true
                button.setImage(UIImage(named: buttonColor), for: .normal)
            }
        }
    }
    
    //selectors
    @objc func tapTestButton() {
        print("Button tapped")
    }
    
    @objc private func confirmExit() {
        print("tap exit")
        let alert = UIAlertController(
            title: "Хотите выйти?",
            message: "Ваш прогресс не сохранится",
            preferredStyle: .alert
        )
        
        let cencelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        let confirmAction = UIAlertAction(title: "Выйти", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        }
        
        alert.addAction(cencelAction)
        alert.addAction(confirmAction)
        
        present(alert, animated: false, completion: nil)
    }
    
    @objc func colorButtonTap(_ sender: UIButton) {
        let colorIndex = sender.tag
        let colorName = ["violet1", "pink1", "orange1", "yellow1", "green1", "lime1"][colorIndex]
        print("Color button tapped: \(colorName)")
        
        let startRow = 0
        let startColumn = 0
        
        //        startRow = gridSize - 1
        //        startColumn = gridSize - 1
        
        previousPlayerColor = grid[startRow][startColumn]
            previousOpponentColor = grid[gridSize - 1][gridSize - 1]
        
        gameLogic.updateCellColors(grid: &grid, row: startRow, column: startColumn, newColor: colorName)
        
        updateGridView()
            // Теперь вы можете использовать playerCellCount по своему усмотрению
        updateScoreLabel()
       disableButtonsForColors()
    }
}

extension UIViewController {
    func animateLabelDisappearance(label: UILabel) {
        label.alpha = 1.0 // Установка альфа-канала лейбла в 1.0, чтобы он был видимым
        
        let animation = CAKeyframeAnimation(keyPath: "opacity")
        animation.values = [1.0, 0.0] // Изменение значения прозрачности от 1.0 (полностью видимый) до 0.0 (полностью прозрачный)
        animation.keyTimes = [0.0, 1.0] // Временные точки, в которые изменяется значение прозрачности
        animation.duration = 2.8 // Длительность анимации изменения прозрачности в секундах
        label.layer.add(animation, forKey: "opacity") // Применение анимации к слою лейбла
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            label.removeFromSuperview() // Удаление лейбла из иерархии представлений после завершения анимации
        }
    }
}
