//
//  GameSettingsViewController.swift
//  Color Flow
//
//  Created by Павел Петров on 27.04.2024.
//

import UIKit
import SnapKit

class GameSettingsViewController: UIViewController {
    let mainMenu = ViewController()
    
    //size settings
    var gridSize: Int = 8
    var cellSize: CGFloat = 45.0
    
    //game modes
    var gameMode: ViewController.GameMode = .pvp
    
    //difficulty
    enum Difficulty {
        case easy
        case hard
    }
    
    enum GameState {
        case proceed
        case new
    }
    
    var gameDifficulty: Difficulty = .easy
    var gameState: GameState = .new
    
    //buttons
    let playButton = UIButton(type: .system)
    let backButton = UIButton(type: .system)
    let continueButton = UIButton(type: .system)
    let newPlayButton = UIButton(type: .system)
    
    //other
    let sizeControl = UISegmentedControl()
    let difficultyControl = UISegmentedControl()
    var gridSizeSegmentIndex = 0
    var difficultySegmentIndex = 0
    
    let background = UIImageView()
    
    let customFont = UIFont(name: "PIXY", size: 30)
    
    let textAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "PIXY", size: 15) as Any,
        .foregroundColor: UIColor.white
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSettings()
        setupUI()
        
        
        print("\(gameMode)")
        
        let swipeExit = UISwipeGestureRecognizer(target: self, action: #selector(backButtonTap))
        swipeExit.direction = .right
        view.addGestureRecognizer(swipeExit)
    }
    
    private func setupUI() {
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
        
        let background = background
        background.frame = view.bounds
        background.contentMode = .scaleAspectFill
        view.addSubview(background)
        
        background.animationImages = frames
        background.animationDuration = 3
        background.animationRepeatCount = 0
        background.startAnimating()
        
        
        let play = playButton
        play.setTitle("Play", for: .normal)
        play.titleLabel?.font = customFont
        play.setTitleColor(.white, for: .normal)
        play.backgroundColor = .black.withAlphaComponent(0.65)
        play.layer.cornerRadius = 12
        play.addTarget(self, action: #selector(newPlayButtonTap), for: .touchUpInside)
        view.addSubview(play)
        
        let proceed = continueButton
        proceed.setTitle("Continue", for: .normal)
        proceed.titleLabel?.font = customFont
        proceed.setTitleColor(.white, for: .normal)
        proceed.backgroundColor = .black.withAlphaComponent(0.65)
        proceed.layer.cornerRadius = 12
        proceed.addTarget(self, action: #selector(playButtonTap), for: .touchUpInside)
        proceed.isHidden = true
        view.addSubview(proceed)
        
        let new = newPlayButton
        new.setTitle("New Game", for: .normal)
        new.titleLabel?.font = customFont
        new.setTitleColor(.white, for: .normal)
        new.backgroundColor = .black.withAlphaComponent(0.65)
        new.layer.cornerRadius = 12
        new.addTarget(self, action: #selector(newPlayButtonTap), for: .touchUpInside)
        new.isHidden = true
        view.addSubview(new)
        
        let back = backButton
        let configBackButton = UIImage.SymbolConfiguration(pointSize: 50)
        back.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        back.setPreferredSymbolConfiguration(configBackButton, forImageIn: .normal)
        back.tintColor = .white
        back.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
        view.addSubview(back)
        
        let difficultySegmentedControl: UISegmentedControl = {
            let control = UISegmentedControl(items: ["Easy", "Hard"])
            control.selectedSegmentIndex = difficultySegmentIndex
            control.addTarget(self, action: #selector(difficultyChanged(_:)), for: .valueChanged)
            control.translatesAutoresizingMaskIntoConstraints = false
            control.backgroundColor = .black.withAlphaComponent(0.1)
            control.selectedSegmentTintColor = .black.withAlphaComponent(0.55)
            control.setTitleTextAttributes(textAttributes, for: .normal)
            return control
        }()
        view.addSubview(difficultySegmentedControl)
        
        if gameMode == .pvp {
            difficultySegmentedControl.isHidden = true
        }
        
        let gridSizeSegmentedControl: UISegmentedControl = {
            let control = UISegmentedControl(items: ["8x8", "16x16", "25x25"])
            control.selectedSegmentIndex = gridSizeSegmentIndex
            control.addTarget(self, action: #selector(gridSizeChanged(_:)), for: .valueChanged)
            control.translatesAutoresizingMaskIntoConstraints = false
            control.backgroundColor = .black.withAlphaComponent(0.1)
            control.selectedSegmentTintColor = .black.withAlphaComponent(0.55)
            control.setTitleTextAttributes(textAttributes, for: .normal)
            return control
        }()
        view.addSubview(gridSizeSegmentedControl)
        
        if gameState == .proceed {
            play.isHidden = true
            difficultySegmentedControl.isHidden = true
            gridSizeSegmentedControl.isHidden = true
            
            proceed.isHidden = false
            new.isHidden = false
        }
        
        //constrains
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        play.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(80)
            make.centerX.centerY.equalToSuperview()
        }
        
        proceed.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(80)
            make.centerX.centerY.equalToSuperview()
        }
        
        new.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
            make.top.equalTo(play.snp.bottom).offset(70)
        }
        
        back.snp.makeConstraints { make in
            make.width.height.equalTo(52)
            make.leading.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(70)
        }
        
        gridSizeSegmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(play.snp.bottom).offset(70)
        }
        
        difficultySegmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(gridSizeSegmentedControl.snp.bottom).offset(50)
        }
    }
    
    
    @objc func playButtonTap() {
        print("play tap")
        print("\(gameDifficulty)")
        print("\(gridSize)")
        
        let storyboard = UIStoryboard(name: "GameArea", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameArea") as! GameArea
        
        vc.gameMode = gameMode
        vc.gameDifficulty = gameDifficulty
        vc.gameState = .proceed
        gameState = .proceed
        
        vc.gridSize = gridSize
        vc.cellSize = cellSize
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    @objc func newPlayButtonTap() {
        print("play tap")
        print("\(gameDifficulty)")
        print("\(gridSize)")
        
        let storyboard = UIStoryboard(name: "GameArea", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameArea") as! GameArea
        
        vc.gameMode = gameMode
        vc.gameDifficulty = gameDifficulty
        vc.gameState = .new
        
        vc.gridSize = gridSize
        vc.cellSize = cellSize
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    @objc func backButtonTap() {
        print("back tap/swipe")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        vc.background.startAnimating()
        
        self.dismiss(animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.background.stopAnimating()
        }
    }
    
    @objc func gridSizeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            gridSize = 8
            cellSize = 45
        case 1:
            gridSize = 16
            cellSize = 25
        case 2:
            gridSize = 25
            cellSize = 16
        default:
            break
        }
        saveSettings(gridSize: gridSize, cellSize: cellSize, gridSizeSegmentIndex: sender.selectedSegmentIndex, difficultySegmentIndex: difficultySegmentIndex)
    }
    
    @objc func difficultyChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            gameDifficulty = .easy
        } else {
            gameDifficulty = .hard
        }
        saveSettings(gridSize: gridSize, cellSize: cellSize, gridSizeSegmentIndex: gridSizeSegmentIndex, difficultySegmentIndex: sender.selectedSegmentIndex)
    }
    
    
    func saveSettings(gridSize: Int, cellSize: CGFloat, gridSizeSegmentIndex: Int, difficultySegmentIndex: Int) {
        let defaults = UserDefaults.standard
        
        // Сохранение значений
        defaults.set(gridSize, forKey: "gridSize")
        defaults.set(cellSize, forKey: "cellSize")
        
        defaults.set(gridSizeSegmentIndex, forKey: "gridSizeSegmentIndex")
        defaults.set(difficultySegmentIndex, forKey: "difficultySegmentIndex")
        
        defaults.synchronize()
    }
    
    func loadSettings() {
        let defaults = UserDefaults.standard
        
        // Загрузка сохраненных значений
        gridSize = defaults.integer(forKey: "gridSize")
        cellSize = CGFloat(defaults.float(forKey: "cellSize"))
        
        // Загрузка индексов выбранных сегментов
        gridSizeSegmentIndex = defaults.integer(forKey: "gridSizeSegmentIndex")
        difficultySegmentIndex = defaults.integer(forKey: "difficultySegmentIndex")
        
        // Установка значений в соответствующие свойства
        sizeControl.selectedSegmentIndex = gridSizeSegmentIndex
        difficultyControl.selectedSegmentIndex = difficultySegmentIndex
        
        // Установите gameDifficulty в соответствии с difficultySegmentIndex
        if difficultySegmentIndex == 0 {
            gameDifficulty = .easy
        } else {
            gameDifficulty = .hard
        }
    }
}


