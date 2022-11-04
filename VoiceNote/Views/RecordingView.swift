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
               // .foregroundColor(Color.init(red: 220/255, green: 220/255, blue: 220/255).opacity(0.4))
               // .foregroundColor(Color.init(red: 220/255, green: 220/255, blue: 220/255))
                .cornerRadius(15)
              //  .shadow(color: Color.init(red: 193/255, green: 193/255, blue:193/255), radius: 30, x: 0, y: -2)
            VStack {
                Spacer()
                
                Button(action: {
                    guard let userDocument = firestoreConnection.userDocument else { return }
                    
                    let newUUID = UUID() // Create same ID for new Recording and new Note 
                    
                    self.audioRecorder.stopRecording(db: firestoreConnection, userDocument: userDocument, allRecordings: allRecordings, selectedNoteId: "\(newUUID)")
                    
                    let newNote = Note(id: newUUID, noteTitle: "new recording", noteContent: "")
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
                    //.padding(.bottom, 40)
                    
                    
                }
                Spacer()
                Text("Recording...").foregroundColor(.white)
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
               // .background(.white)
                .border(Color.black, width: 1)
           

            VStack {
                Spacer()
                
                Button(action: {
                    guard let userDocument = firestoreConnection.userDocument else { return }
                    
                    let newUUID = UUID() // Create same ID for new Recording and new Note
                    
                    self.audioRecorder.stopRecording(db: firestoreConnection, userDocument: userDocument, allRecordings: allRecordings, selectedNoteId: "\(newUUID)")
                    
                    let newNote = Note(id: newUUID, noteTitle: "new recording", noteContent: "")
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
            Rectangle().frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .foregroundColor(Color.init(red: 220/255, green: 220/255, blue: 220/255))
                .cornerRadius(15)
                .shadow(color: Color.init(red: 193/255, green: 193/255, blue:193/255), radius: 20, x: 0, y: -2)
            
            VStack {
                Spacer()
                
                // STOP-Button
                Button(action: {
                    guard let userDocument = firestoreConnection.userDocument else { return }
                    self.audioRecorder.stopRecording(db: firestoreConnection, userDocument: userDocument, allRecordings: allRecordings, selectedNoteId: "\(selectedNote.id)")
                    
                    showRecordPopup = false
                    showEditTabView = true
                    
                    
                }) {
                    Image(systemName: "stop.circle")
                        .font(.system(size: 100))
                        .foregroundStyle(.pink, .gray)
                    
                }
                Spacer()
                Text("Recording...")
                Spacer()
            }
            
        }.onAppear(perform: {
            self.audioRecorder.startRecording2()
        })
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: 200)
        
    }
    
}

struct RecordingsList: View {
    
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @EnvironmentObject var audioRecorder: AudioRecorder
    @Binding var selectedNote: Note
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
                    
                    //                ForEach(recordings, id: \.self) {
                    //                    recording in
                    //
                    //                 //   RecordingRow(audioURL: recording)
                    //
                    //
                    //                }.onDelete(perform: removeRows)
                }
                
            }
            Text("Empty list")
        }.listStyle(SidebarListStyle())
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
                    RecordingSubMenuRow(selectedNote: $selectedNote, audioName: recording.name ?? "nil")
                        .frame(width: 500)
                }.frame(width: 500)
                
            }
        }
        
        
    }
}
//
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
      //  RecordingMenu(audioRecorder: AudioRecorder(), selectedNote: .constant(Note(noteTitle: "hej", noteContent: "hejsand aslla ajkns")), showPlayer: .constant(false), selectedRecording: .constant(UserDocumentRecording(id: "hej", name: "båtlåten gitarr refräng nummer2")))
        
        Recording2View(showRecordPopup: .constant(true), showTabViewPopup: .constant(false), showEditTabView: .constant(false))
            .environmentObject(AudioRecorder())
        
        
    }
}
