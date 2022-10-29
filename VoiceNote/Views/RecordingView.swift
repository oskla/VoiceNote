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
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    var body: some View {
        
        // NavigationView {
        VStack {
            
            //  RecordingsList(audioRecorder: audioRecorder)
            
            if audioRecorder.recording == false {
                Button(action: {self.audioRecorder.startRecording2()}) {
                    
                    Image(systemName: "record.circle")
                        .font(.system(size: 100))
                        .foregroundStyle(.pink, .gray)
                        .padding(.bottom, 40)
                }
            } else {
                Button(action: {
                    
                    guard let userDocument = firestoreConnection.userDocument else { return }
                    
                    self.audioRecorder.stopRecording(db: firestoreConnection, userDocument: userDocument)
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
            self.audioRecorder.startRecording2()
            showTabViewPopup = false
        })
        
        
    }
    
}

struct RecordingEditNoteView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @EnvironmentObject var allNotes: AllNotes
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    
    @Binding var showRecordPopup: Bool
    @Binding var showEditTabView: Bool
    @Binding var selectedNote: Note
    
    
    var body: some View {
        
        VStack {
            
            if audioRecorder.recording == false {
                // Play-button (never shows?)
                Button(action: { self.audioRecorder.startRecording2() }) {
                    
                    Image(systemName: "record.circle")
                        .font(.system(size: 100))
                        .foregroundStyle(.pink, .gray)
                        .padding(.bottom, 40)
                }
                
            } else {
                // STOP-Button
                Button(action: {
                    
                    guard let userDocument = firestoreConnection.userDocument else { return }
                    
                    self.audioRecorder.stopRecording(db: firestoreConnection, userDocument: userDocument )
                    
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
            self.audioRecorder.startRecording2()
        })
            .onDisappear {
                // print("Selected note from disappear Recording view: \(selectedNote)")
                //  print("Selected note from disappear Recording view: \(selectedNote.recording)")
                
            }
    }
    
}

struct RecordingsList: View {
    
    @ObservedObject var firestoreConnection: FirestoreConnection
    @ObservedObject var audioRecorder: AudioRecorder
    @Binding var selectedNote: Note
    
    
    var body: some View {
        List() {
            
            if let userDocument = firestoreConnection.userDocument {
                
               if let recordings = userDocument.recording {
                
                ForEach(recordings, id: \.self) {
                    
                    recording in
                    RecordingRow(audioURL: userDocument.recording?.last ?? "hej")
                }
               }
                
            }
            
            
            
            Text("Empty list")
        }.listStyle(SidebarListStyle())
    }
}

struct RecordingMenu: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @Binding var selectedNote: Note
    var body: some View {
        
        ForEach(audioRecorder.recordings, id: \.createdAt) {
            recording in
            Button(action: {
                // Add function here later - open Play-window
            }) {
                RecordingSubMenuRow(selectedNote: $selectedNote, audioURL: firestoreConnection.userDocument?.recording?.last ?? "error finding recording")
            }
            
        }}
    
}
//
struct RecordingRow: View {
    
    
    var audioURL: String // INSERT URL FROM FIREBASE HERE LATER
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

struct RecordingSubMenuRow: View {
    
    @EnvironmentObject var allNotes: AllNotes
    @Binding var selectedNote: Note
    
    var audioURL: String
    var body: some View {
        
        HStack {
            // Text("\(audioURL.lastPathComponent)")
            Label(allNotes.getNameOfRecording(selectedNote: selectedNote), systemImage: "plus.circle")
            // Label(audioURL.lastPathComponent, systemImage: "plus.circle")
            Spacer()
        }
        
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        
        RecordingsList(firestoreConnection: FirestoreConnection(), audioRecorder: AudioRecorder(), selectedNote: .constant(Note(id: UUID(), noteTitle: "hej", noteContent: "Hej")))
        // RecordingView(audioRecorder: AudioRecorder())
    }
}
