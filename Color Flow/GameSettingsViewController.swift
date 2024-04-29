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
    
    var gameDifficulty: Difficulty = .easy
    
    //buttons
    let playButton = UIButton(type: .system)
    let backButton = UIButton(type: .system)
    
    //other
    let sizeControl = UISegmentedControl()
    let difficultyControl = UISegmentedControl()
    
    let background = UIImageView()
    
    let customFont = UIFont(name: "PIXY", size: 30)
    
    let textAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "PIXY", size: 15) as Any,
        .foregroundColor: UIColor.white
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        play.addTarget(self, action: #selector(playButtonTap), for: .touchUpInside)
        view.addSubview(play)
        
        let back = backButton
        let configBackButton = UIImage.SymbolConfiguration(pointSize: 50)
        back.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        back.setPreferredSymbolConfiguration(configBackButton, forImageIn: .normal)
        back.tintColor = .white
        back.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
        view.addSubview(back)
        
        let difficultySegmentedControl: UISegmentedControl = {
            let control = UISegmentedControl(items: ["Easy", "Hard"])
            control.selectedSegmentIndex = 0
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
            control.selectedSegmentIndex = 0
            control.addTarget(self, action: #selector(gridSizeChanged(_:)), for: .valueChanged)
            control.translatesAutoresizingMaskIntoConstraints = false
            control.backgroundColor = .black.withAlphaComponent(0.1)
            control.selectedSegmentTintColor = .black.withAlphaComponent(0.55)
            control.setTitleTextAttributes(textAttributes, for: .normal)
            return control
        }()
        view.addSubview(gridSizeSegmentedControl)
        
        //constrains
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        play.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(80)
            make.centerX.centerY.equalToSuperview()
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
        
        let storyboard = UIStoryboard(name: "GameArea", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameArea") as! GameArea
        
        vc.gameMode = gameMode
        vc.gameDifficulty = gameDifficulty
        
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
    }
    
    @objc func difficultyChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            gameDifficulty = .easy
        } else {
            gameDifficulty = .hard
        }
    }
}
