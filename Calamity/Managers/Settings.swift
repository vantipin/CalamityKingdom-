//
//  Settings.swift
//  Calamity
//
//  Created by Pavel Stoma on 1/25/19.
//  Copyright © 2019 GameJam. All rights reserved.
//

import Foundation
import AVFoundation

final class Settings {
    static let shared = Settings()
    var backgroundMusicPlayer: AVAudioPlayer!
    
    var isMusicOn: Bool {
        get { return !UserDefaults.standard.bool(forKey: "settings.music.off") }
        set {
            UserDefaults.standard.set(!newValue, forKey: "settings.music.off")
            
            if isMusicOn {
                self.playBackgroundMusic(filename: "main_music")
            } else {
                stopMusic()
            }
        }
    }

    var isSoundsOn: Bool {
        get { return !UserDefaults.standard.bool(forKey: "settings.sounds.off") }
        set { UserDefaults.standard.set(!newValue, forKey: "settings.sounds.off") }
    }
    
    func playBackgroundMusic(filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: "mp3")
        
        if let url = url {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            } catch {
                print("Could not create audio player")
                return
            }
        } else {
            print("Could not find the file \(filename)")
        }
        
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    }
    
    func stopMusic() {
        if let player = backgroundMusicPlayer {
            player.stop()
        }
    }
}
