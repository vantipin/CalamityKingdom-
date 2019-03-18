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
    private var soundPlayer: AVAudioPlayer? = nil
    private var backgroundMusicPlayer: AVAudioPlayer!
    
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
        
        if backgroundMusicPlayer.prepareToPlay() {
            backgroundMusicPlayer.play()
        }
    }
    
    func stopMusic() {
        if let player = backgroundMusicPlayer {
            player.stop()
        }
    }
    
    class func play(sound: GameSound) {
        guard Settings.shared.isSoundsOn else { return }
        
        if let player = Settings.shared.soundPlayer {
            player.stop()
        }

        if let url = Bundle.main.url(forResource: sound.rawValue, withExtension: sound.ext()) {
            do {
                Settings.shared.soundPlayer = try AVAudioPlayer(contentsOf: url)
            } catch {
                print("Could not create audio player")
                return
            }
        } else {
            print("Could not find the file \(sound.rawValue).\(sound.ext())")
        }
        
        guard let player = Settings.shared.soundPlayer else { return }
        
        player.numberOfLoops = 0
        
        if player.prepareToPlay() {
            if sound == .battleLoosing || sound == .battleWin {
                Settings.shared.backgroundMusicPlayer.stop()
            }
            
            player.play()
        }
    }
}
