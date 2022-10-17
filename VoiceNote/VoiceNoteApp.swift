//
//  VoiceNoteApp.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-13.
//

import SwiftUI

@main
struct VoiceNoteApp: App {
  //  let contentView = ContentView(audioRecorder: AudioRecorder())
    var body: some Scene {
        WindowGroup {
            ContentView(audioRecorder: AudioRecorder())
        }
    }
}
