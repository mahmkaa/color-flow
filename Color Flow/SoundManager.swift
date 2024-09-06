//
//  SoundManager.swift
//  Color Flow
//
//  Created by Павел Петров on 06.09.2024.
//

import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playSound(named soundName: String, withExtension ext: String = "wav", volume: Float = 0.5) {
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: ext) else {
            print("sound not found \(soundName).\(ext)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.volume = volume
            audioPlayer?.play()
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}
