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
    

    
    func startPlayback(audio: URL) {
        
        let playbackSession = AVAudioSession.sharedInstance()
            
        
        do {
            try playbackSession.setCategory(.playback)
        } catch {
            print("error activation session: \(error.localizedDescription)")
        }
        
        
        do {

            let item = AVPlayerItem(url: audio)
           
            
            audioPlayer2 = AVPlayer(playerItem: item)
            audioPlayer2.play()
            isPlaying = true
          
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(fileComplete),
                name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                object: nil
            )
        } catch {
            print("Playback failed \(error.localizedDescription)")
        }
        
    }
    
    func stopPlayback() {
       // audioPlayer.stop()
        audioPlayer2.pause()
        isPlaying = false
    }
    
    @objc func fileComplete() {
       isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
    
}
