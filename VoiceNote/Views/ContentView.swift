//
//  ContentView.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-13.
//

import SwiftUI


// TODO

// - Move Voice recorder function intop popUp
// - SearchBar in List
// - Add index-number and add automatically to title
// - Break out view from NewNote and EditNote and reuse that component in both
//-. https://blckbirds.com/post/voice-recorder-app-in-swiftui-2/

// 1. Add Voicememo function - CHECK
// 5. onDelete in NotesList - CHECK

struct ContentView: View {
    
    @StateObject var allNotes = AllNotes()
    @ObservedObject var audioRecorder: AudioRecorder
    @State var showRecordPopup = false
    @State var showTabViewPopup = true
    @State var showEditTabView = true
    
    var body: some View {
        
        VStack {
            NotesHomeView(audioRecorder: audioRecorder, showRecordPopup: $showRecordPopup, showTabViewPopup: $showTabViewPopup, showEditTabView: $showEditTabView)
            if showRecordPopup {
                RecordingView(audioRecorder: audioRecorder, showRecordPopup: $showRecordPopup, showTabViewPopup: $showTabViewPopup, showEditTabView: $showEditTabView)
            }
            
            
        }.environmentObject(allNotes)
    }
}

struct NotesHomeView: View {
    
    @EnvironmentObject var allNotes: AllNotes
    @ObservedObject var audioRecorder: AudioRecorder
    @Binding var showRecordPopup: Bool
    @Binding var showTabViewPopup: Bool
    @Binding var showEditTabView: Bool
    
    
    var body: some View {
        NavigationView {
            VStack {
                NotesList(showRecordPopup: $showRecordPopup, showEditTabView: $showEditTabView)
                if showTabViewPopup {
                    CustomTabViewHome(audioRecorder: audioRecorder, showRecordPopup: $showRecordPopup)
                }
                
            }
            .background(Color.init(red: 245/255, green: 245/255, blue: 245/255))
        }
    }
}




struct NotesList: View {
    
    @EnvironmentObject var allNotes: AllNotes
    @Binding var showRecordPopup: Bool
    @Binding var showEditTabView: Bool
    
    var body: some View {
        
        VStack {
            
            List(){
                
                ForEach(allNotes.getAllNotes()) {
                    note in
                    
                    NavigationLink(destination: EditNoteView(showRecordPopup: $showRecordPopup, selectedNote: note, showEditTabVew: $showEditTabView)) {
                        
                        ListCell(noteTitle: note.noteTitle, noteContent: note.noteContent, recording: note.recording)
                            .listRowBackground(Color.init(red: 245/255, green: 245/255, blue: 245/255))
                        
                    }
                    
                }.onDelete(perform: allNotes.removeNote)
            }
            .listStyle(SidebarListStyle())
            
        }
    }
    
}

struct ListCell: View {
    var noteTitle: String
    var noteContent: String
    var recording: String?
    
    var body: some View {
        HStack {
            VStack (alignment: .leading){
                Text(noteTitle)
                    .font(.system(size: 18))
                    .bold()
                
                Text(noteContent)
                    .fontWeight(.light)
                    .font(.system(size: 14))
                    .lineLimit(2)
            }
            Spacer()
            
            if recording != nil {
                Image(systemName: "mic")
            }
            
        }
        
        
    }
}


struct NewNoteView: View {
    
    // Allows me to go back to previous view when pressing save
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var allNotes: AllNotes
    
    @State var noteContent = ""
    @State var noteTitle: String = "New note"
    
    var body: some View {
        
        VStack {
            
            TextField("New recording", text: $noteTitle)
                .font(.system(size: 30).bold())
                .padding(.horizontal)
            
            
            TextEditor(text: $noteContent)
                .background(.cyan)
                .padding(.horizontal)
            
            
            Button(action: {
                allNotes.addEntry(newNote: Note(noteTitle: noteTitle, noteContent: noteContent, recording: "Recording"))
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Save")
            })
            
            
        }.navigationBarTitle("", displayMode: .inline)
            .onAppear {
                allNotes.addEntry(newNote: Note(noteTitle: noteTitle, noteContent: noteContent, recording: "Recording"))
            }
            .onChange(of: allNotes.notes.first!, perform: allNotes.editNote)
    }
}


struct EditNoteView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var allNotes: AllNotes
    @Binding var showRecordPopup: Bool
    
    @State var selectedNote: Note
    @Binding var showEditTabVew: Bool
    
    var body: some View {
        
        VStack {
            
            TextField("New recording", text: $selectedNote.noteTitle)
                .font(.system(size: 30).bold())
                .padding(.horizontal)
            
            
            TextEditor(text: $selectedNote.noteContent)
                .background(.cyan)
                .padding(.horizontal)
            
            if showEditTabVew {
                CustomTabViewNotes(showRecordPopup: $showRecordPopup, showEditTabView: $showEditTabVew)
            }
           
            
        }.navigationBarTitle("", displayMode: .inline)
            .onChange(of: selectedNote, perform: allNotes.editNote)
        
    }
    
}

struct CustomTabViewNotes: View {
    @State private var sort: Int = 0
    @Binding var showRecordPopup: Bool
    @Binding var showEditTabView: Bool
    var body: some View {
        
        ZStack {
            
            Rectangle()
                .foregroundColor(Color.init(red: 245/255, green: 245/255, blue: 245/255))
                .ignoresSafeArea()
            
            HStack {
                
                // Add recordings here
                Menu {
                    Button(action: {
                        
                    }) {
                        Label("Add", systemImage: "plus.circle")
                    }
                    Button(action: {
                        
                    }) {
                        Label("Delete", systemImage: "minus.circle")
                    }
                    Button(action: {
                        
                    }) {
                        Label("Edit", systemImage: "pencil.circle")
                    }
                } label: {
                    Image(systemName: "play.fill")
                }.font(.system(size: 40))
                    .foregroundStyle(.black)
                
                Spacer()
                        
                                 Button(action: {
                                     showRecordPopup = true
                                     showEditTabView = false
                                 },
                                        label: {
                                     Label("", systemImage: "record.circle")
                                         .font(.system(size: 40))
                                         .foregroundStyle(.black)
                                         .navigationTitle("Voice notes")
                                 })
                                
                
                
            }
            
        }
        .background(.gray)
        .frame(height: 70)
    }
    
}

struct CustomTabViewHome: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @Binding var showRecordPopup: Bool
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(Color.init(red: 245/255, green: 245/255, blue: 245/255))
                .ignoresSafeArea()
            //  .frame(height: 70)
            
            
            HStack {
                Spacer()
                NavigationLink(destination: NewNoteView(), label: {
                    Label("", systemImage: "square.and.pencil")
                        .font(.system(size: 40))
                        .foregroundStyle(.black)
                    
                    
                })
                Spacer()
                Button(action: {
                    showRecordPopup = true
                },
                       label: {
                    Label("", systemImage: "record.circle")
                        .font(.system(size: 40))
                        .foregroundStyle(.pink, .gray)
                        .navigationTitle("Voice notes")
                })
                Spacer()
                
            }
            
            
            
        }
        .background(.gray)
        .frame(height: 70)
        
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // ContentView(audioRecorder: AudioRecorder()).environmentObject(AllNotes())
        //    .previewDevice("iPhone 13 Pro")
        //  NewNoteView().environmentObject(AllNotes())
        EditNoteView(showRecordPopup: .constant(true), selectedNote: Note(noteTitle: "hej", noteContent: "hej"), showEditTabVew: .constant(true)).environmentObject(AllNotes())
        // NotesList().environmentObject(AllNotes())
        // RecordingView(audioRecorder: AudioRecorder())
    }
}
