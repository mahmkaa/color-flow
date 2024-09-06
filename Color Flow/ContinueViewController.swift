//
//  ContinueViewController.swift
//  Color Flow
//
//  Created by Павел Петров on 27.07.2024.
//

import UIKit
import SnapKit

class ContinueViewController: UIViewController {
    var gridSize: Int = 0
    var cellSize: CGFloat = 0
    var gameDifficulty: Difficulty = .easy
    var gameState: GameState = .new
    var gridSizeSegmentIndex: Int = 0
    var difficultySegmentIndex: Int = 0
    
    var gameMode: GameMode = .pve
    
    
    private var settingsFilePath: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent("gameSettings.json")
    }
    
    private var pvpSettingsFilePath: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent("pvpGameSettings.json")
    }
    
    let backButton = UIButton(type: .system)
    let continueButton = UIButton(type: .system)
    let newPlayButton = UIButton(type: .system)
    
    let background = UIImageView()
    
    let customFont = UIFont(name: "PIXY", size: 30)
    let customFont1 = UIFont(name: "PIXY", size: 20)
    
    let textAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "PIXY", size: 15) as Any,
        .foregroundColor: UIColor.white
    ]
    
    override func viewDidLoad() {
        setupUI()
        loadSettings()
        
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
        
        let proceed = continueButton
        proceed.setTitle("Continue", for: .normal)
        proceed.titleLabel?.font = customFont
        proceed.setTitleColor(.white, for: .normal)
        proceed.backgroundColor = .black.withAlphaComponent(0.65)
        proceed.layer.cornerRadius = 12
        proceed.addTarget(self, action: #selector(playButtonTap), for: .touchUpInside)
        view.addSubview(proceed)
        
        let new = newPlayButton
        new.setTitle("New Game", for: .normal)
        new.titleLabel?.font = customFont1
        new.setTitleColor(.white, for: .normal)
        new.backgroundColor = .black.withAlphaComponent(0.65)
        new.layer.cornerRadius = 12
        new.addTarget(self, action: #selector(resetSetting), for: .touchUpInside)
        view.addSubview(new)
        
        let back = backButton
        let configBackButton = UIImage.SymbolConfiguration(pointSize: 50)
        back.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        back.setPreferredSymbolConfiguration(configBackButton, forImageIn: .normal)
        back.tintColor = .white
        back.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
        view.addSubview(back)
        
        
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
            make.top.equalTo(proceed.snp.bottom).offset(50)
        }
        
        back.snp.makeConstraints { make in
            make.width.height.equalTo(52)
            make.leading.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(70)
        }
    }
    
    private func save<T: Encodable>(_ object: T, to filePath: URL) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(object)
            try data.write(to: filePath)
        } catch {
            print("Не удалось сохранить данные: \(error)")
        }
    }

    private func load<T: Decodable>(from filePath: URL, as type: T.Type) -> T? {
        do {
            let data = try Data(contentsOf: filePath)
            let decoder = JSONDecoder()
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            print("Не удалось загрузить данные: \(error)")
            return nil
        }
    }
    
    private func loadSettings() {
        if gameMode == .pve {
            if let settings: GameSettings = load(from: settingsFilePath, as: GameSettings.self) {
                gridSize = settings.gridSize
                cellSize = settings.cellSize
                gameDifficulty = settings.gameDifficulty == "easy" ? .easy : .hard
                gameState = settings.gameState == "new" ? .new : .proceed
                gridSizeSegmentIndex = settings.gridSizeSegmentIndex
                difficultySegmentIndex = settings.difficultySegmentIndex
            }
        } else {
            if let pvpSettings: GameSettingsPvp = load(from: pvpSettingsFilePath, as: GameSettingsPvp.self) {
                gridSize = pvpSettings.gridSize
                cellSize = pvpSettings.cellSize
                gameState = pvpSettings.gameState == "new" ? .new : .proceed
                gridSizeSegmentIndex = pvpSettings.gridSizeSegmentIndex
            }
        }
    }
    
    private func saveSettings() {
        if gameMode == .pve {
            let setting = GameSettings(
                gridSize: gridSize,
                cellSize: cellSize,
                gameDifficulty: gameDifficulty == .easy ? "easy" : "hard",
                gameState: gameState == .new ? "new" : "proceed",
                gridSizeSegmentIndex: gridSizeSegmentIndex,
                difficultySegmentIndex: difficultySegmentIndex
            )
            save(setting, to: settingsFilePath)
        } else {
            let pvpSettings = GameSettingsPvp(
                gridSize: gridSize,
                cellSize: cellSize,
                gameState: gameState == .new ? "new" : "proceed",
                gridSizeSegmentIndex: gridSizeSegmentIndex
            )
            save(pvpSettings, to: pvpSettingsFilePath)
        }
    }
    
    @objc func playButtonTap() {
        print("play tap")
        SoundManager.shared.playSound(named: "click")
        
        let storyboard = UIStoryboard(name: "GameArea", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameArea") as! GameArea
        
        vc.gameMode = gameMode
        vc.gameDifficulty = gameDifficulty
        vc.gameState = .proceed
//        gameState = .proceed
//        
        vc.gridSize = gridSize
        vc.cellSize = cellSize
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    @objc func resetSetting() {
        SoundManager.shared.playSound(named: "click")
        let storyboardSettings = UIStoryboard(name: "GameSettingsViewController", bundle: nil)
        let vc = storyboardSettings.instantiateViewController(withIdentifier: "GameSettingsViewController") as! GameSettingsViewController
        gameState = .new
        saveSettings()

        vc.gameMode = gameMode
        vc.background.startAnimating()
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.background.stopAnimating()
        }
    }
    
    @objc func backButtonTap() {
        print("back tap/swipe")
        SoundManager.shared.playSound(named: "click")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        vc.gameState = .proceed
        vc.background.startAnimating()
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.background.stopAnimating()
        }
    }
}
