//
//  RecordingsListPickerView.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-11-07.
//

import SwiftUI

struct RecordingsListPickerView: View {
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @EnvironmentObject var audioRecorder: AudioRecorder
    @Binding var showPicker: Bool
    
    var body: some View {
        RecordingsList().onAppear {
            showPicker = true
        }
    }
}

struct RecordingsList: View {
    
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @EnvironmentObject var audioRecorder: AudioRecorder
   // @Binding var selectedNote: Note
    @State var selectedRecording: String?
    
    
    func removeRows(at offsets: IndexSet) {
        if var userDocument = firestoreConnection.userDocument {
            // userDocument.recording.remove(atOffsets: offsets)
            
        }
        
    }
    
    var body: some View {
        List() {
            
            if let userDocument = firestoreConnection.userDocument {
                
                if let recordings = userDocument.recording {
                    
                                    ForEach(recordings, id: \.self) {
                                        recording in
                    
                                        RecordingRow(audioURL: "new recording " + "\(recording.recNumber ?? 0.0)")
                    
                    
                                    }.onDelete(perform: removeRows)
                }
                
            }
            Text("Empty list")
        }.listStyle(SidebarListStyle())
    }
}

struct RecordingRow: View {
    var audioURL: String
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {
        
        HStack {
            
            Text(audioURL)
            Spacer()
            if audioPlayer.isPlaying == false {
                Button(action: {
                    
                    if let url = URL(string: audioURL) {
                        self.audioPlayer.startPlayback(audio: url)
                        print("Start playing audio")
                    }
                    
                }) {
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                }
            } else {
                Button(action: {
                    self.audioPlayer.stopPlayback()
                    print("Stop playing audio")
                }) {
                    Image(systemName: "stop.fill")
                        .imageScale(.large)
                }
            }
        }
        
    }
}

struct RecordingsListPickerView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingsListPickerView(showPicker: .constant(true))
    }
}
