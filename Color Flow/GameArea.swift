//
//  GameArea.swift
//  Color Flow
//
//  Created by Павел Петров on 09.04.2024.
//

import UIKit
import SnapKit
import CoreImage.CIFilterBuiltins

class GameArea: UIViewController {
    
    var currentPlayer: Int = 1
    
    var grid = [[String]]()
    let gameLogic = GameLogic()
    let mainMenu = ViewController()
    let gameSettings = GameSettingsViewController()
    
    var gameMode: ViewController.GameMode = .pvp
    var gameDifficulty: GameSettingsViewController.Difficulty = .easy
    
    let colors = ["violet1", "pink1", "orange1", "yellow1", "green1", "lime1"]
    let colors1 = ["lime1", "green1", "yellow1", "orange1", "pink1", "violet1"]
    
    let exit = UIButton(type: .system)
    let button = UIButton(type: .system)
    let endGameButton = UIButton(type: .system)
    var colorButtons: [UIButton] = []
    
    let tutorialLabel = UILabel()
    let scoreLabelP1 = UILabel()
    let scoreLabelP2 = UILabel()
    let endGameLabelP1 = UILabel()
    let endGameLabelP2 = UILabel()
    
    let customFont = UIFont(name: "PIXY", size: 20)
    let customFont1 = UIFont(name: "PIXY", size: 16)
    
    var gridSize: Int = 0
    var cellSize: CGFloat = 0.0
    var cells = [UIView]()
    
    var previousPlayerColor: String?
    var previousOpponentColor: String?
    
    var gridStackView: UIStackView?
    var stackView: UIStackView!
    var stackView1: UIStackView!
    
    let playerMarker = UIImageView()
    let opponentMarker = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGrid()
        setupUI()
        settingGameInterface()
        randomStart()
        
        
        let swipeExit = UISwipeGestureRecognizer(target: self, action: #selector(confirmExit))
        swipeExit.direction = .right
        view.addGestureRecognizer(swipeExit)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //animateLabelDisappearance(label: tutorialLabel)
    }
    
    
    //MARK: - setupUI
    func setupUI(){
        //        let frameCount = 26
        //        var frames = [UIImage]()
        //
        //        for index in 1...frameCount {
        //            let frameName = "backGif\(index)"
        //            if let image = UIImage(named: frameName) {
        //                frames.append(image)
        //            } else {
        //                print("Не удалось загрузить изображение: \(frameName)")
        //            }
        //        }
        
        //        //MARK: - blurBackGround
        //        var blurredFrames = [UIImage]()
        //        let blurFilter = CIFilter(name: "CIBoxBlur")
        //        blurFilter?.setValue(5, forKey: kCIInputRadiusKey)
        //
        //        for index in 1...26 {
        //            let frameName = "backGif\(index)"
        //
        //            if let image = UIImage(named: frameName) {
        //                let ciImage = CIImage(image: image)
        //
        //                blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        //
        //                if let outputImage = blurFilter?.outputImage {
        //                    let context = CIContext(options: nil)
        //                    if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
        //                        let blurredImage = UIImage(cgImage: cgImage)
        //
        //                        blurredFrames.append(blurredImage)
        //                    }
        //                }
        //            } else {
        //                print("Не удалось загрузить: \(frameName)")
        //            }
        //        }
        
        //        let background = UIImageView()
        //        background.frame = view.bounds
        //        background.contentMode = .scaleAspectFill
        //        view.addSubview(background)
        //        view.sendSubviewToBack(background)
        
        //        background.animationImages = blurredFrames
        //        background.animationDuration = 3
        //        background.animationRepeatCount = 0
        //        background.startAnimating()
        
        //MARK: - static pic background
        let background: UIImageView = {
            let background = UIImageView()
            background.frame = view.bounds
            background.contentMode = .scaleAspectFill
            background.image = UIImage(named: "backGif3")
            view.addSubview(background)
            view.sendSubviewToBack(background)
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            DispatchQueue.global(qos: .userInitiated).async {
                if let originalImage = UIImage(named: "backGif3") {
                    // Преобразуем изображение в CIImage
                    let ciImage = CIImage(image: originalImage)
                    
                    // Создаем фильтр размытия Гаусса
                    let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur")
                    
                    // Устанавливаем радиус размытия (регулируйте значение по своему усмотрению)
                    gaussianBlurFilter?.setValue(7, forKey: kCIInputRadiusKey)
                    
                    // Устанавливаем входное изображение для фильтра
                    gaussianBlurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
                    
                    // Получаем результат после применения фильтра
                    if let outputCIImage = gaussianBlurFilter?.outputImage {
                        // Смещение области обрезки
                        let cropRect = CGRect(x: ciImage!.extent.origin.x + 5,
                                              y: ciImage!.extent.origin.y + 5,
                                              width: ciImage!.extent.size.width - 10,
                                              height: ciImage!.extent.size.height - 10)
                        
                        // Обрезаем изображение на заданной области
                        let croppedCIImage = outputCIImage.cropped(to: cropRect)
                        
                        // Создаем контекст для преобразования CIImage в UIImage
                        let context = CIContext(options: nil)
                        if let cgImage = context.createCGImage(croppedCIImage, from: croppedCIImage.extent) {
                            // Устанавливаем размазанное изображение в UIImageView
                            let blurredImage = UIImage(cgImage: cgImage)
                            
                            DispatchQueue.main.async {
                                imageView.image = blurredImage
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let animationDuration = 0.1
                UIView.animate(withDuration: TimeInterval(animationDuration)){
                    background.alpha = 0.0
                }
                background.removeFromSuperview()
            }
            return imageView
        }()
        view.addSubview(background)
        view.sendSubviewToBack(background)
        
        
        let frameCount = 10
        var frames = [UIImage]()
        for index in 1...frameCount {
            let frameName = "marker\(index)"
            if let image = UIImage(named: frameName) {
                frames.append(image)
            } else {
                print("Не удалось загрузить изображение \(frameName)")
            }
        }
        
        let playerMarker = playerMarker
        if gameMode == .pve {
            playerMarker.isHidden = false
        } else {
            playerMarker.isHidden = true
        }
        view.addSubview(playerMarker)
        
        playerMarker.animationImages = frames
        playerMarker.animationDuration = 1
        playerMarker.animationRepeatCount = 0
        playerMarker.startAnimating()
        
        let opponentMarker = opponentMarker
        opponentMarker.isHidden = true
        view.addSubview(opponentMarker)
        
        opponentMarker.animationImages = frames
        opponentMarker.animationDuration = 1
        opponentMarker.animationRepeatCount = 0
        opponentMarker.startAnimating()
        
        
        let exitButton = exit
        //exitButton.setTitle("Exit", for: .normal)
        //exitButton.backgroundColor = .white
        //exitButton.setTitleColor(.black, for: .normal)
        exitButton.setImage(UIImage(systemName: "figure.walk.arrival"), for: .normal)
        exitButton.tintColor = .white
        exitButton.addTarget(self, action: #selector(confirmExit), for: .touchUpInside)
        exitButton.isHidden = true
        view.addSubview(exitButton)
        
        let endExitButton = endGameButton
        let configurationExitButton = UIImage.SymbolConfiguration(pointSize: 75)
        endExitButton.setImage(UIImage(systemName: "xmark.app"), for: .normal)
        endExitButton.setPreferredSymbolConfiguration(configurationExitButton, forImageIn: .normal)
        endExitButton.tintColor = .white
        endExitButton.addTarget(self, action: #selector(endExitButtonTap), for: .touchUpInside)
        endExitButton.isHidden = true
        view.addSubview(endExitButton)
        
        
        let label = tutorialLabel
        label.text = "Для выхода используйте жест масштабирования"
        label.textColor = UIColor.white
        label.font = customFont
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(label)
//        view.bringSubviewToFront(label)
        
        let scoreLabel = scoreLabelP1
        scoreLabel.textColor = UIColor.white
        scoreLabel.font = customFont1
        scoreLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        scoreLabel.textAlignment = .center
        scoreLabel.numberOfLines = 1
        scoreLabel.layer.cornerRadius = 10
        scoreLabel.clipsToBounds = true
        view.addSubview(scoreLabel)
        view.bringSubviewToFront(scoreLabel)
        
        let scoreLabel1 = scoreLabelP2
        scoreLabel1.textColor = UIColor.white
        scoreLabel1.font = customFont1
        scoreLabel1.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        scoreLabel1.textAlignment = .center
        scoreLabel1.numberOfLines = 1
        scoreLabel1.layer.cornerRadius = 10
        scoreLabel1.clipsToBounds = true
        view.addSubview(scoreLabel1)
        view.bringSubviewToFront(scoreLabel1)
        
        let endGameLabelP1 = endGameLabelP1
        endGameLabelP1.textColor = UIColor.white
        endGameLabelP1.font = customFont
        endGameLabelP1.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        endGameLabelP1.textAlignment = .center
        endGameLabelP1.numberOfLines = 2
        endGameLabelP1.layer.cornerRadius = 10
        endGameLabelP1.clipsToBounds = true
        endGameLabelP1.isHidden = true
        view.addSubview(endGameLabelP1)
        view.bringSubviewToFront(endGameLabelP1)
        
        let endGameLabelP2 = endGameLabelP2
        endGameLabelP2.textColor = UIColor.white
        endGameLabelP2.font = customFont
        endGameLabelP2.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        endGameLabelP2.textAlignment = .center
        endGameLabelP2.numberOfLines = 2
        endGameLabelP2.layer.cornerRadius = 10
        endGameLabelP2.clipsToBounds = true
        endGameLabelP2.isHidden = true
        view.addSubview(endGameLabelP2)
        view.bringSubviewToFront(endGameLabelP2)
        
        updateScoreLabel()
        updateOpponentScoreLabel()
        
        //Настройка кнопок
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        
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
        
        stackView1 = UIStackView()
        stackView1.axis = .horizontal
        stackView1.spacing = 4
        stackView1.alignment = .center
        stackView1.distribution = .fillEqually
        view.addSubview(stackView1)
        
        for colorName in colors1{
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: colorName), for: .normal)
            button.addTarget(self, action: #selector(colorButtonTap1(_:)), for: .touchUpInside)
            button.tag = colors1.firstIndex(of: colorName) ?? 0
            stackView1.addArrangedSubview(button)
            colorButtons.append(button)
            
            button.snp.makeConstraints { make in
                make.width.height.equalTo(60)
            }
        }
        
        
        if gameMode == .pve {
            stackView1.isHidden = true
        } else if gameMode == .pvp {
            stackView1.isHidden = false
        }
        
        disableButtonsForColors(playerButtons: stackView.arrangedSubviews as! [UIButton], opponentButtons: stackView1.arrangedSubviews as! [UIButton])
        
        
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        exitButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-10)
            make.height.width.equalTo(50)
        }
        
        playerMarker.snp.makeConstraints { make in
            switch gridSize {
            case 8:
                make.width.height.equalTo(25)
                make.leading.equalToSuperview().offset(35)
            case 16:
                make.width.height.equalTo(20)
                make.leading.equalToSuperview().offset(11)
            case 25:
                make.width.height.equalTo(18)
                make.leading.equalToSuperview().offset(7)
            default:
                make.width.height.equalTo(25)
                make.leading.equalToSuperview().offset(25)
            }
            make.bottom.equalTo((gridStackView?.snp.top)!).offset(-10)
        }
        
        opponentMarker.snp.makeConstraints { make in
            switch gridSize {
            case 8:
                make.trailing.equalToSuperview().offset(-35)
                make.width.height.equalTo(25)
            case 16:
                make.trailing.equalToSuperview().offset(-11)
                make.width.height.equalTo(20)
            case 25:
                make.trailing.equalToSuperview().offset(-7)
                make.width.height.equalTo(18)
            default:
                make.trailing.equalToSuperview().offset(-8)
                make.width.height.equalTo(25)
            }
            make.top.equalTo(gridStackView?.snp.bottom ?? stackView1.snp.bottom).offset(10)
        }
        
        opponentMarker.transform = CGAffineTransform(scaleX: -1, y: -1)
        
        endExitButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(90)
        }
        
//        tutorialLabel.snp.makeConstraints { make in
//            make.height.equalTo(100)
//            make.width.equalTo(300)
//            make.centerX.centerY.equalToSuperview()
//        }
        
        scoreLabelP1.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(stackView.snp.top).offset(-30)
        }
        
        scoreLabelP2.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(stackView1.snp.bottom).offset(30)
        }
        
        scoreLabelP2.transform = CGAffineTransform(scaleX: -1, y: -1)
        
        endGameLabelP1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(endExitButton.snp.bottom).offset(75)
            make.height.equalTo(100)
            make.width.equalTo(200)
        }
        
        endGameLabelP2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(endExitButton.snp.top).offset(-75)
            make.height.equalTo(100)
            make.width.equalTo(200)
        }
        
        endGameLabelP2.transform = CGAffineTransform(scaleX: -1, y: -1)
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-70)
        }
        
        stackView1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(70)
        }
    }
    
    //MARK: - setupGrid
    func setupGrid() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        gridStackView = stackView
        view.addSubview(gridStackView ?? stackView)
        
        
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
    
    //MARK: - updateGridView
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
    
    //MARK: - scoreLabels
    func updateScoreLabel() {
        // Подсчитываем количество клеток игрока, связанных с начальной клеткой
        let playerCellCount = gameLogic.countPlayerCells(grid: grid)
        
        // Обновляем текст лейбла
        scoreLabelP1.text = "Score: \(playerCellCount)"
    }
    
    func updateOpponentScoreLabel() {
        let playerCellCount = gameLogic.countOpponentCells(gridSize: gridSize, grid: grid)
        
        scoreLabelP2.text = "Score: \(playerCellCount)"
    }
    
    //MARK: - endGame
    func endGame() {
        // Подсчет количества клеток игроков
        let playerCellCount = gameLogic.countPlayerCells(grid: grid)
        let opponentCellCount = gameLogic.countOpponentCells(gridSize: gridSize, grid: grid)
        
        // Подсчет общей площади арены и количества захваченных клеток
        let arenaArea = gridSize * gridSize
        let playersSum = playerCellCount + opponentCellCount
        
        // Проверка условия окончания игры
        if arenaArea == playersSum {
            // Скрытие счетчиков
            scoreLabelP2.isHidden = true
            scoreLabelP1.isHidden = true
            
            playerMarker.isHidden = true
            opponentMarker.isHidden = true
            
            // Отключение и затемнение кнопок
            disableButtonStack(stackView1.arrangedSubviews as! [UIButton])
            disableButtonStack(stackView.arrangedSubviews as! [UIButton])
            
            // Установка сетки в полупрозрачный режим
            gridStackView?.alpha = 0.5
            
            // Вызов метода, который может отображать сообщение о конце игры или переходить к новому уровню
            endGameMessage()  // Дополнительный метод для показа сообщения об окончании игры
        }
    }
    
    func endGameMessage() {
        let playerCellCount = gameLogic.countPlayerCells(grid: grid)
        let opponentCellCount = gameLogic.countOpponentCells(gridSize: gridSize, grid: grid)
        
        endGameButton.isHidden = false
        endGameLabelP1.isHidden = false
        if gameMode == .pvp {
            endGameLabelP2.isHidden = false
        }
        
        if playerCellCount < opponentCellCount {
            endGameLabelP1.text = "You lose 😔\nYour score: \(playerCellCount)"
            endGameLabelP2.text = "You WON! 🥳\nYour score: \(opponentCellCount)"
        } else {
            endGameLabelP1.text = "You WON! 🥳\nYour score: \(playerCellCount)"
            endGameLabelP2.text = "You lose 😔\nYour score: \(opponentCellCount)"
        }
    }
    
    //MARK: - disableButtons
    func disableButtonsForColors(playerButtons: [UIButton], opponentButtons: [UIButton]) {
        // Получаем цвет начальной клетки (0, 0)
        let startColor = grid[0][0]
        // Получаем цвет клетки противника (gridSize - 1, gridSize - 1)
        let opponentColor = grid[gridSize - 1][gridSize - 1]
        
        // Массив цветов кнопок, соответствующий их порядку
        let colors = ["violet1", "pink1", "orange1", "yellow1", "green1", "lime1"]
        
        // Обработка кнопок игрока
        for (index, button) in playerButtons.enumerated() {
            let buttonColor = colors[index]
            button.isEnabled = buttonColor != startColor && buttonColor != opponentColor
            button.setImage(UIImage(named: button.isEnabled ? buttonColor : "lightGrey"), for: .disabled)
        }
        
        // Обработка кнопок противника
        for (index, button) in opponentButtons.enumerated() {
            let buttonColor = colors.reversed()[index]
            button.isEnabled = buttonColor != opponentColor && buttonColor != startColor
            button.setImage(UIImage(named: button.isEnabled ? buttonColor : "lightGrey"), for: .disabled)
        }
    }
    
    func disableButtonStack(_ buttons: [UIButton]){
        for button in buttons {
            button.isEnabled = false
            button.alpha = 0.5
        }
    }
    
    func enableButtonStack(_ buttons: [UIButton]) {
        for button in buttons {
            button.isEnabled = true
            button.alpha = 1.0
        }
    }
    
    //MARK: - stepByStep
    func stepByStep() {
        let player1Buttons = stackView.arrangedSubviews as! [UIButton]
        let player2Buttons = stackView1.arrangedSubviews as! [UIButton]
        
        if currentPlayer == 1 {
            disableButtonStack(player1Buttons)
            enableButtonStack(player2Buttons)
            playerMarker.isHidden = true
            opponentMarker.isHidden = false
            currentPlayer = 2
        } else if currentPlayer == 2 {
            disableButtonStack(player2Buttons)
            enableButtonStack(player1Buttons)
            playerMarker.isHidden = false
            opponentMarker.isHidden = true
            currentPlayer = 1
        }
    }
    
    func randomStart() {
        if gameMode == .pvp {
            let number = Int.random(in: 1...2)
            
            //нужно реализовать методы которые покажут лейбл начинающего игрока и картинку со стрелкой на начальную клетку игрока
            switch number {
            case 1:
                print("p1")
                currentPlayer = 1
                disableButtonStack(stackView1.arrangedSubviews as! [UIButton])
                playerMarker.isHidden = false
            case 2:
                print("p2")
                currentPlayer = 2
                disableButtonStack(stackView.arrangedSubviews as! [UIButton])
                opponentMarker.isHidden = false
            default:
                print("Error")
            }
        }
    }
    
    //MARK: - settingGameInterface
    func settingGameInterface() {
        if gameMode == .pvp {
            scoreLabelP2.isHidden = false
        } else {
            scoreLabelP2.isHidden = true
            disableButtonStack(stackView1.arrangedSubviews as! [UIButton])
            view.bringSubviewToFront(stackView1)
        }
    }
    
    //MARK: - opponentAI
    func opponentAI() {
        guard gameMode == .pve else {
            // Игровой режим PvP, противник не требуется
            return
        }
        
        // Получаем массив кнопок игрока 2 (противника)
        let player2Buttons = stackView1.arrangedSubviews as! [UIButton]
        
        // Выбираем цвет на основе уровня сложности
        let chosenColor: String?
        if gameDifficulty == .easy {
            chosenColor = gameLogic.easyDifficultyAI(grid: &grid, gridSize: gridSize)
        } else {
            chosenColor = gameLogic.hardDifficultyAI(grid: &grid, gridSize: gridSize)
        }
        
        // Проверяем, удалось ли противнику выбрать цвет
        guard let color = chosenColor else {
            print("Противник не смог выбрать цвет")
            return
        }
        
        // Находим индекс выбранного цвета в массиве colors1
        guard let chosenIndex = colors1.firstIndex(of: color), chosenIndex < player2Buttons.count else {
            print("Цвет не найден в colors1 или индекс вне диапазона массива кнопок")
            return
        }
        
        // Вызываем действие нажатия на выбранную кнопку
        let chosenButton = player2Buttons[chosenIndex]
        chosenButton.sendActions(for: .touchUpInside)
    }
    
    //MARK: - selectors
    @objc func endExitButtonTap() {
        print("Button tapped")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    @objc private func confirmExit() {
        print("tap exit")
        
        dismiss(animated: true)
//        let alert = UIAlertController(
//            title: "Хотите выйти?",
//            message: "Ваш прогресс не сохранится",
//            preferredStyle: .alert
//        )
//        
//        let cencelAction = UIAlertAction(title: "Отмена", style: .cancel)
//        
//        let confirmAction = UIAlertAction(title: "Выйти", style: .default) { [weak self] _ in
//            self?.dismiss(animated: true)
//        }
//        
//        alert.addAction(cencelAction)
//        alert.addAction(confirmAction)
//        
//        present(alert, animated: false, completion: nil)
    }
    
    
    //MARK: - colorButtonTap
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
        updateScoreLabel()
        
        let playerButtons = stackView.arrangedSubviews as! [UIButton]
        let opponentButtons = stackView1.arrangedSubviews as! [UIButton]
        stepByStep()
        disableButtonsForColors(playerButtons: playerButtons, opponentButtons: opponentButtons)
        settingGameInterface()
        endGame()
        opponentAI()
        if gameMode == .pvp {
            disableButtonStack(stackView.arrangedSubviews as! [UIButton])
        }
    }
    
    @objc func colorButtonTap1(_ sender: UIButton) {
        let colorIndex = sender.tag
        let colorName = ["lime1", "green1", "yellow1", "orange1", "pink1", "violet1"][colorIndex]
        print("Color button tapped: \(colorName)")
        
        let startRow = gridSize - 1
        let startColumn = gridSize - 1
        
        //        startRow = gridSize - 1
        //        startColumn = gridSize - 1
        
        previousPlayerColor = grid[startRow][startColumn]
        previousOpponentColor = grid[gridSize - 1][gridSize - 1]
        
        gameLogic.updateCellColors(grid: &grid, row: startRow, column: startColumn, newColor: colorName)
        
        updateGridView()
        updateOpponentScoreLabel()
        
        let playerButtons = stackView.arrangedSubviews as! [UIButton]
        let opponentButtons = stackView1.arrangedSubviews as! [UIButton]
        stepByStep()
        disableButtonsForColors(playerButtons: playerButtons, opponentButtons: opponentButtons)
        endGame()
        if gameMode == .pvp {
            disableButtonStack(stackView1.arrangedSubviews as! [UIButton])
        }
    }
}

extension UIViewController {
    func animateLabelDisappearance(label: UILabel) {
        label.alpha = 1.0 // Установка альфа-канала лейбла в 1.0, чтобы он был видимым
        
        let animation = CAKeyframeAnimation(keyPath: "opacity")
        animation.values = [1.0, 0.0] // Изменение значения прозрачности от 1.0 (полностью видимый) до 0.0 (полностью прозрачный)
        animation.keyTimes = [0.0, 1.0] // Временные точки, в которые изменяется значение прозрачности
        animation.duration = 3 // Длительность анимации изменения прозрачности в секундах
        label.layer.add(animation, forKey: "opacity") // Применение анимации к слою лейбла
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            label.removeFromSuperview() // Удаление лейбла из иерархии представлений после завершения анимации
        }
    }
}
