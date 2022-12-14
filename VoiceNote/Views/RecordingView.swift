//
//  RecordingView.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-17.
//

import Foundation
import SwiftUI

struct RecordingView: View {
    
    @Binding var showRecordPopup: Bool
    @Binding var showTabViewPopup: Bool
    @Binding var showEditTabView: Bool
    
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var allNotes: AllNotes
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @EnvironmentObject var allRecordings: AllRecordings
    
    var lightGray = Color.init(red: 245/255, green: 245/255, blue: 245/255)
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .background(.ultraThinMaterial)
                .cornerRadius(15)
            VStack {
                Spacer()
                
                Button(action: {
                    guard let userDocument = firestoreConnection.userDocument else { return }
                    
                    let newUUID = UUID() // Create same ID for new Recording and new Note 
                    
                    self.audioRecorder.stopRecording(db: firestoreConnection, userDocument: userDocument, allRecordings: allRecordings, selectedNoteId: "\(newUUID)")
                    
                    let newNote = Note(id: newUUID, noteTitle: "New recording", noteContent: "")
                    allNotes.addEntry(newNote: newNote)
                    
                    firestoreConnection.addNoteToDb(note: newNote)
                    
                    withAnimation {
                        showRecordPopup = false
                    }
                    
                    showTabViewPopup = true
                    showEditTabView = true
                    
                }) {
                    Image(systemName: "stop.circle")
                        .font(.system(size: 70))
                        .foregroundStyle(.pink, .black)
             
                    
                    
                }
                Spacer()
                Text("Recording...").foregroundColor(.white)
                Spacer()
            }
            
        }
        .onAppear(perform: {
            self.audioRecorder.startRecording2()
            
        })
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: 200)
        
        
    }
    
}


struct Recording2View: View {
    
    @Binding var showRecordPopup: Bool
    @Binding var showTabViewPopup: Bool
    @Binding var showEditTabView: Bool
    
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var allNotes: AllNotes
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @EnvironmentObject var allRecordings: AllRecordings
    
    var lightGray = Color.init(red: 245/255, green: 245/255, blue: 245/255)
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .foregroundColor(.white).opacity(0.97)
                .border(Color.black, width: 1)
           

            VStack {
                Spacer()
                
                Button(action: {
                    guard let userDocument = firestoreConnection.userDocument else { return }
                    
                    let newUUID = UUID() // Create same ID for new Recording and new Note
                    
                    self.audioRecorder.stopRecording(db: firestoreConnection, userDocument: userDocument, allRecordings: allRecordings, selectedNoteId: "\(newUUID)")

                    
                    
                    withAnimation {
                        showRecordPopup = false
                    }
                    
                    showTabViewPopup = true
                    showEditTabView = true
                    
                }) {
                    Image(systemName: "stop.circle")
                        .font(.system(size: 70))
                        .foregroundStyle(.red, .black)
                    
                    
                }
               // Spacer()
                Text("Recording...")
                    .font(.light18)
                    .foregroundColor(.black)
                    .padding(.top, 10)
                Spacer()
            }
            
        }
        .onAppear(perform: {
           self.audioRecorder.startRecording2()
            // showTabViewPopup = false
        })
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: 200)
        
        
    }
    
}


struct RecordingEditNoteView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @EnvironmentObject var allNotes: AllNotes
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @EnvironmentObject var allRecordings: AllRecordings
    
    @Binding var showRecordPopup: Bool
    @Binding var showEditTabView: Bool
    @Binding var selectedNote: Note
    
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .foregroundColor(.white).opacity(0.97)
               // .background(.white)
                .border(Color.black, width: 1)
            
            VStack {
                Spacer()
                
                // STOP-Button
                Button(action: {
                    guard let userDocument = firestoreConnection.userDocument else { return }
                    self.audioRecorder.stopRecording(db: firestoreConnection, userDocument: userDocument, allRecordings: allRecordings, selectedNoteId: "\(selectedNote.id)")
                    
                    withAnimation {
                        showRecordPopup = false
                    }
                    
                    showEditTabView = true
                    
                    
                }) {
                    Image(systemName: "stop.circle")
                        .font(.system(size: 70))
                        .foregroundStyle(.red, .black)
                    
                }
                Text("Recording...")
                    .font(.light18)
                    .foregroundColor(.black)
                    .padding(.top, 10)
                Spacer()
            }
            
        }.onAppear(perform: {
            self.audioRecorder.startRecording2()
        })
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: 200)
        
    }
    
}


// MARK: Recording Menu
struct RecordingMenu: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @EnvironmentObject var allRecordings: AllRecordings
    @Binding var selectedNote: Note
    @Binding var showPlayer: Bool
    @Binding var selectedRecording: UserDocumentRecording?
    var body: some View {
        
        
        
        if let selectedNoteRecordings = allRecordings.getRecordingArrayById(id: "\(selectedNote.id)", db: firestoreConnection) {
            
            // print("SelectedNoteRecordings: \(selectedNoteRecordings)")
            
            ForEach(selectedNoteRecordings) {
                recording in
                
                Button(action: {
                    
                    withAnimation {
                        showPlayer = true
                    }
                    
                    selectedRecording = recording
                    print("player should show")
                    // Add function here later - open Play-window
                }) {
                    RecordingSubMenuRow(selectedNote: $selectedNote, audioName: recording.nickname ?? "nil")
                        .frame(width: 500)
                }.frame(width: 500)
                
            }
        }
        
        
    }
}


struct RecordingSubMenuRow: View {
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @EnvironmentObject var allNotes: AllNotes
    @Binding var selectedNote: Note
    
    
    // var audioURL: URL
    var audioName: String
    var body: some View {
        
        HStack {

            Label("\(audioName)", systemImage: "plus.circle")
            Spacer()
        }
        
    }
}

struct RecordingsList_Previews: PreviewProvider {
    static var previews: some View {
        //        RecordingView(showRecordPopup: .constant(true), showTabViewPopup: .constant(true), showEditTabView: .constant(true)).environmentObject(FirestoreConnection()).environmentObject(AllNotes()).environmentObject(AudioRecorder())
      //  RecordingMenu(audioRecorder: AudioRecorder(), selectedNote: .constant(Note(noteTitle: "hej", noteContent: "hejsand aslla ajkns")), showPlayer: .constant(false), selectedRecording: .constant(UserDocumentRecording(id: "hej", name: "b??tl??ten gitarr refr??ng nummer2")))
        
        Recording2View(showRecordPopup: .constant(true), showTabViewPopup: .constant(false), showEditTabView: .constant(false))
            .environmentObject(AudioRecorder())
        
        
    }
}
