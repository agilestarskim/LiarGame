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
    
    func play(file: String) {
        let path = Bundle.main.path(forResource: file, ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)            
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
