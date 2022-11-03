//
//  AudioPlayer.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-27.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    var audioPlayer: AVAudioPlayer!
    var audioPlayer2: AVPlayer!
    
    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    
    
//    func handleAudioPLay(audio: URL) {
//
//            do {
//                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
//                audioPlayer = try AVAudioPlayer(contentsOf: audio)
//                audioPlayer?.delegate = self
//                audioPlayer?.prepareToPlay()
//                audioPlayer?.play()
//                print("Audio ready to play")
//            } catch let error {
//                print(error.localizedDescription)
//            }
//    }
    
    
    func startPlayback(audio: URL) {
        
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            // Using speakers instead of earpiece
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        do {

            let item = AVPlayerItem(url: audio)
            audioPlayer2 = AVPlayer(playerItem: item)
           
            audioPlayer2.play()
            isPlaying = true
            
        } catch let error {
            print("Playback failed \(error.localizedDescription)")
        }
        
    }
    
    func stopPlayback() {

        audioPlayer2.pause()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
    
}
