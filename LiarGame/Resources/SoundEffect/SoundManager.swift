//
//  SoundManager.swift
//  LiarGame
//
//  Created by 김민성 on 2023/01/19.
//

import Foundation
import AVKit

class SoundManager {
    static let instance = SoundManager()
    
    private init() {}
    
    private var player: AVAudioPlayer?
    
    func play(file: String, volume: Float = 1, speed: Float = 1) {
        guard let url = Bundle.main.url(forResource: file, withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.enableRate = true
            player?.rate = speed
            player?.setVolume(volume, fadeDuration: 0)
            player?.play()
        }catch {
            print(error)
        }
    }
    
    func stop(file: String) {
        guard let url = Bundle.main.url(forResource: file, withExtension: "mp3") else { return }
        player = try? AVAudioPlayer(contentsOf: url)
        player?.stop()
    }    
}
