//
//  RecordingView.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-17.
//

import Foundation
import SwiftUI

struct RecordingView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    var body: some View {
       
        NavigationView {
            VStack {

                RecordingsList(audioRecorder: audioRecorder)
  
                        if audioRecorder.recording == false {
                            Button(action: {self.audioRecorder.startRecording()}) {
                                
                                Image(systemName: "record.circle")
                                    .font(.system(size: 100))
                                    .foregroundStyle(.pink, .gray)
                                    .padding(.bottom, 40)
                            }
                        } else {
                            Button(action: {self.audioRecorder.stopRecording()}) {
                                Image(systemName: "stop.circle")
                                    .font(.system(size: 100))
                                    .foregroundStyle(.pink, .gray)
                                    .padding(.bottom, 40)
                            }
                        }
            }
                
        }.navigationBarTitle("Recordings", displayMode: .inline)
        
    }
    
}

struct RecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        List() {
            
            ForEach(audioRecorder.recordings, id: \.createdAt) {
                recording in
                RecordingRow(audioURL: recording.fileURL)
            }
            
            Text("Empty list")
        }.listStyle(SidebarListStyle())
    }
}

struct RecordingRow: View {
    
    var audioURL: URL
    
    var body: some View {
        
        HStack {
            Text("\(audioURL.lastPathComponent)")
            Spacer()
        }
        
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
      //  RecordingsList(audioRecorder: AudioRecorder())
        RecordingView(audioRecorder: AudioRecorder())
    }
}