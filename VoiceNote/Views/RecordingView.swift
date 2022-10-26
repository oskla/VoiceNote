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
                            // Play-button (never shows?)
                            Button(action: {self.audioRecorder.startRecording()}) {
                                
                                Image(systemName: "record.circle")
                                    .font(.system(size: 100))
                                    .foregroundStyle(.pink, .gray)
                                    .padding(.bottom, 40)
                            }
                            
                        } else {
                            // STOP-Button
                            Button(action: {
                                self.audioRecorder.stopRecording()
                                
                                allNotes.addEntry(newNote: Note(noteTitle: "new recording", noteContent: ""))
                                
                                showRecordPopup = false
                                showEditTabView = true
                                
                              let currentRecording = allNotes.getLatestRecording(audioRecorder: audioRecorder, selectedNote: selectedNote)
   
                                
                                if let currentRecording = currentRecording {
                                    
                                    selectedNote.recording.append(currentRecording)
                                }

                                
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
            .onDisappear {
               // print("Selected note from disappear Recording view: \(selectedNote)")
              //  print("Selected note from disappear Recording view: \(selectedNote.recording)")
                
            }
    }
    
}

struct RecordingsList: View {
    
    @ObservedObject var audioRecorder: AudioRecorder
    @Binding var selectedNote: Note
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

struct RecordingMenu: View {
    @ObservedObject var audioRecorder: AudioRecorder
   @Binding var selectedNote: Note
    var body: some View {
        
        ForEach(audioRecorder.recordings, id: \.createdAt) {
        recording in
            Button(action: {
             // Add function here later - open Play-window
            }) {
                RecordingSubMenuRow(selectedNote: $selectedNote, audioURL: recording.fileURL)
            }

        }}
    
}
//
struct RecordingRow: View {


    var audioURL: URL
    var body: some View {

        HStack {
          //  Text("\(allNotes.getNameOfRecording(selectedNote: <#T##Note#>))")
            Text("\(audioURL.lastPathComponent)")
            Spacer()
        }

    }
}

struct RecordingSubMenuRow: View {
    
    @EnvironmentObject var allNotes: AllNotes
   @Binding var selectedNote: Note
    
    var audioURL: URL
    var body: some View {
        
        HStack {
           // Text("\(audioURL.lastPathComponent)")
            Label(allNotes.getNameOfRecording(selectedNote: selectedNote), systemImage: "plus.circle")
           // Label(audioURL.lastPathComponent, systemImage: "plus.circle")
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
