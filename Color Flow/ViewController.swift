//
//  ViewController.swift
//  Color Flow
//
//  Created by Павел Петров on 08.04.2023.
//

import UIKit
//import AVFoundation
import SnapKit

class ViewController: UIViewController {
    //size settings
    var gridSize: Int = 0
    var cellSize: CGFloat = 0.0
    
    //pvp/pve setting
    var isPVP: Bool = true
    
//    var player: AVPlayer?
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        
        let background = UIImageView()
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
        
        //кнопка пве
        let pveButton = pve
        pveButton.setTitle("PvE", for: .normal)
        pveButton.setTitleColor(.white, for: .normal)
        pveButton.backgroundColor = .gray
        pveButton.layer.cornerRadius = 12
        pveButton.addTarget(self, action: #selector(pveButtonTap), for: .touchUpInside)
        pveButton.isHidden = false
        view.addSubview(pveButton)
        
        //pvp button
        let pvpButton = pvp
        pvpButton.setTitle("PvP", for: .normal)
        pvpButton.setTitleColor(.white, for: .normal)
        pvpButton.backgroundColor = .gray
        pvpButton.layer.cornerRadius = 12
        pvpButton.addTarget(self, action: #selector(pvpButtonTap), for: .touchUpInside)
        pvpButton.isHidden = false
        view.addSubview(pvpButton)
        
        let easyLevelButton = easy
        easyLevelButton.setTitle("Easy", for: .normal)
        easyLevelButton.setTitleColor(.white, for: .normal)
        easyLevelButton.backgroundColor = .gray
        easyLevelButton.layer.cornerRadius = 12
        easyLevelButton.addTarget(self, action: #selector(easyLevelTap), for: .touchUpInside)
        easyLevelButton.isHidden = true
        view.addSubview(easyLevelButton)
        
        let hardLevelButton = hard
        hardLevelButton.setTitle("Hard", for: .normal)
        hardLevelButton.setTitleColor(.white, for: .normal)
        hardLevelButton.backgroundColor = .gray
        hardLevelButton.layer.cornerRadius = 12
        hardLevelButton.addTarget(self, action: #selector(hardLevelTap), for: .touchUpInside)
        hardLevelButton.isHidden = true
        view.addSubview(hardLevelButton)
        
        let backButton = back
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = .gray
        backButton.layer.cornerRadius = 12
        backButton.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
        backButton.isHidden = true
        view.addSubview(backButton)
        
        let area8Button = area8x8
        area8Button.setTitle("8x8", for: .normal)
        area8Button.setTitleColor(.white, for: .normal)
        area8Button.backgroundColor = .gray
        area8Button.layer.cornerRadius = 12
        area8Button.addTarget(self, action: #selector(area8x8Tap), for: .touchUpInside)
        area8Button.isHidden = true
        view.addSubview(area8Button)
        
        let area16Button = area16x16
        area16Button.setTitle("16x16", for: .normal)
        area16Button.setTitleColor(.white, for: .normal)
        area16Button.backgroundColor = .gray
        area16Button.layer.cornerRadius = 12
        area16Button.addTarget(self, action: #selector(area16х16Tap), for: .touchUpInside)
        area16Button.isHidden = true
        view.addSubview(area16Button)
        
        let area32Button = area32x32
        area32Button.setTitle("32x32", for: .normal)
        area32Button.setTitleColor(.white, for: .normal)
        area32Button.backgroundColor = .gray
        area32Button.layer.cornerRadius = 12
        area32Button.addTarget(self, action: #selector(area8x8Tap), for: .touchUpInside)
        area32Button.isHidden = true
        view.addSubview(area32Button)
        
        let backButton1 = backArea
        backButton1.setTitle("Back", for: .normal)
        backButton1.setTitleColor(.white, for: .normal)
        backButton1.backgroundColor = .gray
        backButton1.layer.cornerRadius = 12
        backButton1.addTarget(self, action: #selector(backButton1Tap), for: .touchUpInside)
        backButton1.isHidden = true
        view.addSubview(backButton1)
        
        //constrains
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        
        easyLevelButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(hardLevelButton.snp.top).offset(-75)
        }
        
        hardLevelButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(hardLevelButton.snp.bottom).offset(75)
        }
        
        area8Button.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(area16Button.snp.top).offset(-50)
        }
        
        area16Button.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        
        area32Button.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(area16Button.snp.bottom).offset(50)
        }
        
        backButton1.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(area32Button.snp.bottom).offset(50)
        }
    }
    
    //selectors
    @objc private func pveButtonTap() {
        print("pvebutton tap tap")
        isPVP = false
        showDifficultyMenu()
    }
    
    //selectors
    @objc private func pvpButtonTap() {
        print("pvpbutton tap tap")
        isPVP = true
        showSizeMenu()
    }
    
    @objc private func easyLevelTap() {
        print("Easy level")
        showSizeMenu()
    }
    
    @objc private func hardLevelTap() {
        print("Hard")
    }
    
    @objc private func backButtonTap() {
        print("Back")
        showMainMenu()
    }
    
    @objc private func backButton1Tap() {
        print("Back 1")
        showDifficultyMenu()
    }
    
    @objc private func area8x8Tap() {
        print("8x8")
        print("до \(gridSize),\(cellSize)")
        
        let storyboard = UIStoryboard(name: "GameArea", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameArea") as! GameArea
        
        vc.isPVP = isPVP
        
        vc.gridSize = 8
        vc.cellSize = 45.0
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showMainMenu() // Вы можете изменить значение задержки по вашему усмотрению
        }
        
        print("после \(gridSize),\(cellSize)")
    }
    
    @objc private func area16х16Tap() {
        print("8x8")
        print("до \(gridSize),\(cellSize)")
        
        
        let storyboard = UIStoryboard(name: "GameArea", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameArea") as! GameArea
        
        vc.isPVP = isPVP
        
        vc.gridSize = 16
        vc.cellSize = 25.0
        
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.showMainMenu() // Вы можете изменить значение задержки по вашему усмотрению
        }
        
        print("после \(gridSize),\(cellSize)")
    }
    
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

}

