//
//  ViewController.swift
//  Color Flow
//
//  Created by Павел Петров on 08.04.2023.
//

import UIKit
//import AudioToolbox
//import AVFoundation
import SnapKit

class ViewController: UIViewController {
    //size settings
    var gridSize: Int = 0
    var cellSize: CGFloat = 0.0
    
    //pvp/pve setting
    var gameMode: GameMode = .pve
    var gameState: GameState = .new
    var gameStatePvp: GameState = .new
    
//    var player: AVPlayer?
//    var audioPlayer: AVAudioPlayer?
    
    let background = UIImageView()
    
    //buttons
    let pve = UIButton(type: .system)
    let pvp = UIButton(type: .system)
    let easy = UIButton(type: .system)
    let hard = UIButton(type: .system)
    let back = UIButton(type: .system)
    let backArea = UIButton(type: .system)
    let area8x8 = UIButton(type: .system)
    let area16x16 = UIButton(type: .system)
    let area32x32 = UIButton(type: .system)
    let settingButton = UIButton(type: .system)
    
    let customFont = UIFont(name: "PIXY", size: 23)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadGameStates()
    }

    func setupUI() {
        //background
        //MARK: - фон через изображение
//        let background: UIImageView = {
//            let imageView = UIImageView(image: UIImage(named: "nightSky"))
//            imageView.contentMode = .scaleAspectFill
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//            return imageView
//        }()
        
        //MARK: - использование гиф файла (работает)
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
        
        //        let background = UIImageView()
        //        background.contentMode = .scaleAspectFill
        //        view.addSubview(background)
        //
        //        let gifImage = UIImage(named: "back1.gif")
        //        background.image = gifImage
        
        //MARK: - фон через видео
//        let videoURL = Bundle.main.url(forResource: "backWater", withExtension: "mp4")!
//        player = AVPlayer(url: videoURL)
//        
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.videoGravity = .resizeAspectFill
//        playerLayer.frame = view.bounds
//        view.layer.addSublayer(playerLayer)
//        
//        player?.play()
        
        let logoImage = UIImageView(image: UIImage(named: "logo4"))
        logoImage.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        logoImage.contentMode = .scaleAspectFit
        logoImage.isHidden = true
        view.addSubview(logoImage)
        
        //кнопка пве
        let pveButton = pve
        pveButton.setTitle("PvE", for: .normal)
        pveButton.titleLabel?.font = customFont
        pveButton.setTitleColor(.white, for: .normal)
        pveButton.backgroundColor = .black.withAlphaComponent(0.65)
        pveButton.layer.cornerRadius = 12
        pveButton.addTarget(self, action: #selector(pveButtonTap), for: .touchUpInside)
        pveButton.isHidden = false
        view.addSubview(pveButton)
        
        //pvp button
        let pvpButton = pvp
        pvpButton.setTitle("PvP", for: .normal)
        pvpButton.titleLabel?.font = customFont
        pvpButton.setTitleColor(.white, for: .normal)
        pvpButton.backgroundColor = .black.withAlphaComponent(0.65)
        pvpButton.layer.cornerRadius = 12
        pvpButton.addTarget(self, action: #selector(pvpButtonTap), for: .touchUpInside)
        pvpButton.isHidden = false
        view.addSubview(pvpButton)
        
        let setting = settingButton
        let configSettingButton = UIImage.SymbolConfiguration(pointSize: 50)
        setting.setImage(UIImage(systemName: "gear"), for: .normal)
        setting.setPreferredSymbolConfiguration(configSettingButton, forImageIn: .normal)
        setting.tintColor = .white
        setting.addTarget(self, action: #selector(settingsButtonTap), for: .touchUpInside)
        setting.isHidden = true
        view.addSubview(setting)
        
        //constrains
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logoImage.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.height.equalTo(150)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-220)
        }
        
        pveButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        
        pvpButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(pveButton.snp.bottom).offset(50)
        }
        
        setting.snp.makeConstraints { make in
            make.width.height.equalTo(51)
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(70)
        }
    }
    
    //selectors
    @objc private func pveButtonTap() {
        print("pvebutton tap tap")
        SoundManager.shared.playSound(named: "click")
        
        if gameState == .new {
            let storyboard = UIStoryboard(name: "GameSettingsViewController", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "GameSettingsViewController") as? GameSettingsViewController {
                vc.gameMode = .pve
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
            }
        } else {
            let storyboardProceed = UIStoryboard(name: "ContinueViewController", bundle: nil)
            if let vcProceed = storyboardProceed.instantiateViewController(withIdentifier: "ContinueViewController") as? ContinueViewController {
                vcProceed.gameMode = .pve
                vcProceed.modalPresentationStyle = .fullScreen
                vcProceed.modalTransitionStyle = .crossDissolve
                self.present(vcProceed, animated: true)
            }
        }
    }
    
    @objc private func pvpButtonTap() {
        print("pvpbutton tap tap")
        SoundManager.shared.playSound(named: "click")
        
        if gameStatePvp == .new {
            let storyboard = UIStoryboard(name: "GameSettingsViewController", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "GameSettingsViewController") as? GameSettingsViewController {
                vc.gameMode = .pvp
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true)
            }
        } else {
            let storyboardProceed = UIStoryboard(name: "ContinueViewController", bundle: nil)
            if let vcProceed = storyboardProceed.instantiateViewController(withIdentifier: "ContinueViewController") as? ContinueViewController {
                vcProceed.gameMode = .pvp
                vcProceed.modalPresentationStyle = .fullScreen
                vcProceed.modalTransitionStyle = .crossDissolve
                self.present(vcProceed, animated: true)
            }
        }
    }
    
    @objc private func settingsButtonTap() {
        print("settings tap")
    }
    
//    @objc private func area8x8Tap() {
//        print("8x8")
//        print("до \(gridSize),\(cellSize)")
//        
//        let storyboard = UIStoryboard(name: "GameArea", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "GameArea") as! GameArea
//        
//        vc.isPVP = isPVP
//        vc.isEasy = isEasy
//        
//        vc.gridSize = 8
//        vc.cellSize = 45.0
//        
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .crossDissolve
//        self.present(vc, animated: true)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.showMainMenu() // Вы можете изменить значение задержки по вашему усмотрению
//        }
//        
//        print("после \(vc.gridSize),\(vc.cellSize)")
//    }
//    
//    @objc private func area16х16Tap() {
//        print("16х16")
//        print("до \(gridSize),\(cellSize)")
//        
//        
//        let storyboard = UIStoryboard(name: "GameArea", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "GameArea") as! GameArea
//        
//        vc.isPVP = isPVP
//        vc.isEasy = isEasy
//        
//        vc.gridSize = 16
//        vc.cellSize = 25.0
//        
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .crossDissolve
//        self.present(vc, animated: true)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.showMainMenu() // Вы можете изменить значение задержки по вашему усмотрению
//        }
//        
//        print("после \(vc.gridSize),\(vc.cellSize)")
//    }
//    
//    @objc private func area32х32Tap() {
//        print("25x25")
//        print("до \(gridSize),\(cellSize)")
//        
//        
//        let storyboard = UIStoryboard(name: "GameArea", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "GameArea") as! GameArea
//        
//        vc.isPVP = isPVP
//        vc.isEasy = isEasy
//        
//        vc.gridSize = 25
//        vc.cellSize = 16
//        
//        vc.modalPresentationStyle = .fullScreen
//        vc.modalTransitionStyle = .crossDissolve
//        self.present(vc, animated: true)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.showMainMenu() // Вы можете изменить значение задержки по вашему усмотрению
//        }
//        
//        print("после \(vc.gridSize),\(vc.cellSize)")
//    }
    
    private func showMainMenu() {
        gridSize = 0
        cellSize = 0
        
        area8x8.isHidden = true
        area16x16.isHidden = true
        area32x32.isHidden = true
        backArea.isHidden = true
        
        easy.isHidden = true
        hard.isHidden = true
        back.isHidden = true
        
        pve.isHidden = false
        pvp.isHidden = false
    }
    
    private func showDifficultyMenu() {
        pve.isHidden = true
        pvp.isHidden = true
        
        easy.isHidden = false
        hard.isHidden = false
        back.isHidden = false
        
        area8x8.isHidden = true
        area16x16.isHidden = true
        area32x32.isHidden = true
        backArea.isHidden = true
    }
    
    private func showSizeMenu() {
        pve.isHidden = true
        pvp.isHidden = true
        
        easy.isHidden = true
        hard.isHidden = true
        back.isHidden = true
        
        area8x8.isHidden = false
        area16x16.isHidden = false
        area32x32.isHidden = false
        backArea.isHidden = false
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
    
    private func loadSingleValue<T: Decodable, U>(from filePath: URL, as type: T.Type, keyPath: KeyPath<T, U>) -> U? {
        do {
            let data = try Data(contentsOf: filePath)
            let decoder = JSONDecoder()
            let object = try decoder.decode(type, from: data)
            return object[keyPath: keyPath]
        } catch {
            print("Не удалось загрузить данные: \(error)")
            return nil
        }
    }
    
    private var settingsFilePath: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent("gameSettings.json")
    }
    
    private var pvpSettingsFilePath: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent("pvpGameSettings.json")
    }
    
    func loadGameStates() {
        if let gamePvpStateString: String = loadSingleValue(from: pvpSettingsFilePath, as: GameSettingsPvp.self, keyPath: \.gameState) {
            gameStatePvp = (gamePvpStateString == "new") ? .new : .proceed
        }
        
        if let gameStateString: String = loadSingleValue(from: settingsFilePath, as: GameSettings.self, keyPath: \.gameState) {
            gameState = (gameStateString == "new") ? .new : .proceed
        }
    }
}

