//
//  RecordingsList.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-28.
//

import Foundation

class AllRecordings: ObservableObject {
    
    @Published var recordings = [String]()
    
    func addRecording(recording: String) {
            
            recordings.append(recording)
        }
}
