//
//  GameSettingsViewController.swift
//  Color Flow
//
//  Created by Павел Петров on 27.04.2024.
//

import UIKit
import SnapKit

class GameSettingsViewController: UIViewController {
    
    //настройки
    var gridSize: Int = 8
    var cellSize: CGFloat = 45.0
    var gameMode: GameMode = .pve
    var gameDifficulty: Difficulty = .easy
    var gameState: GameState = .new
    var gridSizeSegmentIndex = 0
    var difficultySegmentIndex = 0
    
    private var settingsFilePath: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent("gameSettings.json")
    }
    
    private var pvpSettingsFilePath: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent("pvpGameSettings.json")
    }

    //buttons
    let playButton = UIButton(type: .system)
    let backButton = UIButton(type: .system)
    let continueButton = UIButton(type: .system)
    let newPlayButton = UIButton(type: .system)
    
    //other
    var sizeControl = UISegmentedControl()
    var difficultyControl = UISegmentedControl()
    
    let background = UIImageView()
    
    let customFont = UIFont(name: "PIXY", size: 30)
    let customFont1 = UIFont(name: "PIXY", size: 20)
    
    let textAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "PIXY", size: 15) as Any,
        .foregroundColor: UIColor.white
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(gameState)")
        
        
        loadSettings()
        setupUI()
        
        if gameState == .new {
            newGameView()
        }
        
        print("\(gameState)")
        print("\(gameMode)")
        
        let swipeExit = UISwipeGestureRecognizer(target: self, action: #selector(backButtonTap))
        swipeExit.direction = .right
        view.addGestureRecognizer(swipeExit)
        
        //continueGameView()
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
        new.titleLabel?.font = customFont1
        new.setTitleColor(.white, for: .normal)
        new.backgroundColor = .black.withAlphaComponent(0.65)
        new.layer.cornerRadius = 12
        new.addTarget(self, action: #selector(resetSetting), for: .touchUpInside)
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
        difficultyControl = difficultySegmentedControl
        view.addSubview(difficultyControl)
        
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
        sizeControl = gridSizeSegmentedControl
        view.addSubview(sizeControl)
        
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
            make.width.equalTo(130)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(play.snp.bottom).offset(50)
        }
        
        back.snp.makeConstraints { make in
            make.width.height.equalTo(52)
            make.leading.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(70)
        }
        
        sizeControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(play.snp.bottom).offset(70)
        }
        
        difficultyControl.snp.makeConstraints { make in
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
        
        continueGameView()
        saveSettings()
        
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
        
        gameState = .proceed
        saveSettings()
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    @objc func resetSetting() {
        gameState = .new
        saveSettings()
        newGameView()
    }
    
    @objc func backButtonTap() {
        print("back tap/swipe")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        vc.background.startAnimating()
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
        
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
        
        gridSizeSegmentIndex = sender.selectedSegmentIndex
        saveSettings()
    }
    
    @objc func difficultyChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            gameDifficulty = .easy
        case 1:
            gameDifficulty = .hard
        default:
            break
        }
        
        difficultySegmentIndex = sender.selectedSegmentIndex
        saveSettings()
    }
    
    func newGameView() {
        print("новая игра")
        playButton.isHidden = false
        sizeControl.isHidden = false
        
        continueButton.isHidden = true
        newPlayButton.isHidden = true
        
        if gameMode == .pvp {
            difficultyControl.isHidden = true
        } else {
            difficultyControl.isHidden = false
        }
    }
    
    func continueGameView() {
        print("продолжить игру")
        playButton.isHidden = true
        difficultyControl.isHidden = true
        sizeControl.isHidden = true
        
        continueButton.isHidden = false
        newPlayButton.isHidden = false
    }
    
    func gameSettingsViewLoad() {
        if gameState == .proceed {
            continueGameView()
        } else if gameState == .new {
            newGameView()
        }
    }
    
    private func loadSettings() {
        do {
            let data = try Data(contentsOf: settingsFilePath)
            let pvpData = try Data(contentsOf: pvpSettingsFilePath)
            let decoder = JSONDecoder()
            let settings = try decoder.decode(GameSettings.self, from: data)
            let pvpSettings = try decoder.decode(GameSettingsPvp.self, from: pvpData)
            
            if gameMode == .pve {
                gridSize = settings.gridSize
                cellSize = settings.cellSize
                gameDifficulty = settings.gameDifficulty == "easy" ? .easy : .hard
                gameState = settings.gameState == "new" ? .new : .proceed
                gridSizeSegmentIndex = settings.gridSizeSegmentIndex
                difficultySegmentIndex = settings.difficultySegmentIndex
            } else {
                gridSize = pvpSettings.gridSize
                cellSize = pvpSettings.cellSize
                gameState = pvpSettings.gameState == "new" ? .new : .proceed
                gridSizeSegmentIndex = pvpSettings.gridSizeSegmentIndex
            }
            

        } catch {
            print("Не удалось загрузить настройки")
        }
    }

    private func saveSettings() {
        let setting = GameSettings(
            gridSize: gridSize,
            cellSize: cellSize,
            gameDifficulty: gameDifficulty == .easy ? "easy" : "hard",
            gameState: gameState == .new ? "new" : "proceed",
            gridSizeSegmentIndex: gridSizeSegmentIndex,
            difficultySegmentIndex: difficultySegmentIndex
        )
        
        let pvpSettings = GameSettingsPvp(
            gridSize: gridSize,
            cellSize: cellSize,
            gameState: gameState == .new ? "new" : "proceed",
            gridSizeSegmentIndex: gridSizeSegmentIndex
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            if gameMode == .pve {
                let data = try encoder.encode(setting)
                try data.write(to: settingsFilePath)
            } else {
                let data = try encoder.encode(pvpSettings)
                try data.write(to: pvpSettingsFilePath)
            }
        } catch {
            print("Не удалось сохранить настройки")
        }
    }
    
    private func newGame() {
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
}


