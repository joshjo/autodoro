//
//  SoundManager.swift
//  Autodoro
//
//  Created by Josue Ttito on 26/03/23.
//

import SwiftUI
import AVFoundation


class SoundManager {
    static let instance = SoundManager()
    
    var player: AVAudioPlayer?
    
    func playSound(mode: Mode) {
        guard let path = Bundle.main.path(forResource: mode == Mode.work ? "whistling" : "cat", ofType: "wav") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
}
