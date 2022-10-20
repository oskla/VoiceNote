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
    @Binding var showRecordPopup: Bool
    @Binding var showTabViewPopup: Bool
    @Binding var showEditTabView: Bool
    
    @EnvironmentObject var allNotes: AllNotes
    var body: some View {
       
       // NavigationView {
            VStack {

              //  RecordingsList(audioRecorder: audioRecorder)
  
                        if audioRecorder.recording == false {
                            Button(action: {self.audioRecorder.startRecording()}) {
                                
                                Image(systemName: "record.circle")
                                    .font(.system(size: 100))
                                    .foregroundStyle(.pink, .gray)
                                    .padding(.bottom, 40)
                            }
                        } else {
                            Button(action: {
                                self.audioRecorder.stopRecording()
                                allNotes.addEntry(newNote: Note(noteTitle: "new recording", noteContent: ""))
                                showRecordPopup = false
                                showTabViewPopup = true
                                showEditTabView = true
                                
                            }) {
                                Image(systemName: "stop.circle")
                                    .font(.system(size: 100))
                                    .foregroundStyle(.pink, .gray)
                                    .padding(.bottom, 40)
                                
                            }
                            
                        }
            }.onAppear(perform: {
                self.audioRecorder.startRecording()
                showTabViewPopup = false
            })
                
        
    }
    
}

struct RecordingEditNoteView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @EnvironmentObject var allNotes: AllNotes
    
    @Binding var showRecordPopup: Bool
    @Binding var showEditTabView: Bool
    @Binding var selectedNote: Note
    
    var body: some View {

            VStack {
  
                        if audioRecorder.recording == false {
                            Button(action: {self.audioRecorder.startRecording()}) {
                                
                                Image(systemName: "record.circle")
                                    .font(.system(size: 100))
                                    .foregroundStyle(.pink, .gray)
                                    .padding(.bottom, 40)
                                
                            }
                            
                        } else {
                            Button(action: {
                                self.audioRecorder.stopRecording()
                                
                                allNotes.addEntry(newNote: Note(noteTitle: "new recording", noteContent: ""))
                                showRecordPopup = false
                                showEditTabView = true
                                
                              let currentRecording = allNotes.getLatestRecording(audioRecorder: audioRecorder, selectedNote: selectedNote)
                                
                                print("Current recording (fetched from function): \(currentRecording)")
                                if let currentRecording = currentRecording {
                                    
                                    selectedNote.recording.append(currentRecording)
                                }
                                print("Selected note recording(s): \(selectedNote.recording)")
                                
                            }) {
                                Image(systemName: "stop.circle")
                                    .font(.system(size: 100))
                                    .foregroundStyle(.pink, .gray)
                                    .padding(.bottom, 40)
                                
                            }
                            
                            
                        }
            }.onAppear(perform: {
                self.audioRecorder.startRecording()
            })
            
                
        
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

//struct RecordingsList_Previews: PreviewProvider {
//    static var previews: some View {
//      //  RecordingsList(audioRecorder: AudioRecorder())
//       // RecordingView(audioRecorder: AudioRecorder())
//    }
//}
