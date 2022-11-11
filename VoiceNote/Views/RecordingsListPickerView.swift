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
    @Binding var showCustomTabView: Bool
    @Binding var showRecordPopup: Bool
    @Binding var showEditTabView: Bool
    
    var body: some View {
        
        
        VStack(spacing: 0) {
            RecordingsList().onAppear {
                showPicker = true
  
            }
            VStack {
                CustomTabViewHome(showRecordPopup: $showRecordPopup, showPicker: $showPicker)
                
            }
        }.navigationTitle("Recordings")
        .onAppear {
            showCustomTabView = true
        }
        .overlay(alignment: .bottom) {
            if showRecordPopup {
                Recording2View(showRecordPopup: $showRecordPopup, showTabViewPopup: $showCustomTabView, showEditTabView: $showEditTabView)
                    .transition(.move(edge: .bottom))
                    
            }
        }

            
    }
}

struct RecordingsList: View {
    
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @EnvironmentObject var audioRecorder: AudioRecorder
    @State var selectedRecording: String?
    
    
    func removeRows(at offsets: IndexSet) {
        if var userDocument = firestoreConnection.userDocument {

            
        }
        
    }
    
    var body: some View {
        List() {
            
            if let userDocument = firestoreConnection.userDocument {
                
                if let recordings = userDocument.recording {
                    
                                    ForEach(recordings, id: \.self) {
                                        recording in
                    
                                        RecordingRow(audioURL: recording.name ?? "",
                                                     audioName: recording.nickname ?? "").font(.bold16)
                    
                    
                                    }.onDelete(perform: removeRows)
                }
                
            }
     
                
        }.listStyle(.inset)
            
    }
}

struct RecordingRow: View {
    var audioURL: String
    var audioName: String
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {
        
        HStack {
            
            Text(audioName)
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
        RecordingsListPickerView(showPicker: .constant(true), showCustomTabView: .constant(true), showRecordPopup: .constant(false), showEditTabView: .constant(false)).environmentObject(FirestoreConnection())
    }
}
