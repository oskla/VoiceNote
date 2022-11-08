//
//  ContentView.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-13.
//

import SwiftUI
import Firebase
import FirebaseStorage





// https://blckbirds.com/post/voice-recorder-app-in-swiftui-2/

// TODO: Make function that changes name of recording (so i dont have to do it in view)
// TODO: When recording from Home. Assign that recording to menu
// TODO: Design new CustomTabView
// TODO: Design new "play-list" - maybe don't use the "menu"


// MARK: ContentView

struct ContentView: View {
    
    
    @StateObject var firestoreConnection = FirestoreConnection()
    @StateObject var allNotes = AllNotes()
    @StateObject var allRecordings = AllRecordings()
    @ObservedObject var audioRecorder: AudioRecorder
    @State var showRecordPopup = false
    @State var showTabViewPopup = true
    @State var showEditTabView = true
    @State var notesOrRecordings = "notes"
    @State var showPicker = true
    
    
    
    var body: some View {
        
        ZStack {
            
            if firestoreConnection.userLoggedIn == true {
                
                NavigationView {
                    
                    VStack  {
                        if showPicker {
                            PickerView(notesOrRecordings: $notesOrRecordings).padding()
                        }
                    
                        
                        if notesOrRecordings == "notes" {
                            NotesHomeView(showRecordPopup: $showRecordPopup, showTabViewPopup: $showTabViewPopup, showEditTabView: $showEditTabView, showPicker: $showPicker)
                        }
                        
                        if notesOrRecordings == "recordings" {
                            RecordingsListPickerView(showPicker: $showPicker, showCustomTabView: $showTabViewPopup, showRecordPopup: $showRecordPopup, showEditTabView: $showEditTabView)
                        }
                       
                    }
                    
                }

                // If not logged in
            } else {
                LoginView()
            }
            
           
        }.environmentObject(allNotes)
            .environmentObject(audioRecorder)
            .environmentObject(firestoreConnection)
            .environmentObject(allRecordings)
    }
}

// MARK: NoteHome

struct NotesHomeView: View {
    @EnvironmentObject var allNotes: AllNotes
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var allRecordings: AllRecordings
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @Binding var showRecordPopup: Bool
    @Binding var showTabViewPopup: Bool
    @Binding var showEditTabView: Bool
    @Binding var showPicker: Bool
    
    
    var body: some View {
        
        NavigationView {
          
            VStack(spacing: 0) {
                NotesList(showRecordPopup: $showRecordPopup, showEditTabView: $showEditTabView, showPicker: $showPicker)
                
                
                if showTabViewPopup {
                    
                    VStack {
                        CustomTabViewHome(showRecordPopup: $showRecordPopup, showPicker: $showPicker)
                            .frame(height: 90)
                        
                    }
                }
                
            }
            .overlay(alignment: .bottom) {
                if showRecordPopup {
                    Recording2View(showRecordPopup: $showRecordPopup, showTabViewPopup: $showTabViewPopup, showEditTabView: $showEditTabView)
                        .transition(.move(edge: .bottom))
                        
                }
            }
            
            .onAppear {
                showTabViewPopup = true
                showPicker = true
               // allRecordings.setCurrentRecNumber(db: firestoreConnection)
               print("recNumber: \(firestoreConnection.userDocument?.recCounter)")
            }
            
        }.navigationBarTitle("Notes", displayMode: .inline)
    }
}


// TODO: If edit note - put it at top of NotesList

struct NotesList: View {
    
    @EnvironmentObject var allNotes: AllNotes
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @Binding var showRecordPopup: Bool
    @Binding var showEditTabView: Bool
    @State var myNote: Note?
    @Binding var showPicker: Bool
    
    func getNote(note: Note) {
        myNote = note
    }
    
    var body: some View {
        
        VStack {
            
            List(){
                if var userDocumentNotes = firestoreConnection.userDocument?.notes {
                    ForEach(userDocumentNotes) {
                        note in
                        
                        
                        NavigationLink(destination: EditNoteView( showRecordPopup: $showRecordPopup, showPicker: $showPicker, showEditTabVew: $showEditTabView, selectedNote: note)) {
                            ListCell(noteTitle: note.noteTitle, noteContent: note.noteContent, hasRecording: allNotes.hasRecordings(noteId: "\(note.id)", db: firestoreConnection))
                                .listRowBackground(Color.init(red: 245/255, green: 245/255, blue: 245/255))
                            
                        }.onAppear {
                            getNote(note: note)
                            
                        }
                    }.onDelete(perform: { indexSet in
                        allNotes.removeNote(at: indexSet, db: firestoreConnection, note: myNote!)
                    })
                }
                
            }
            
        }
    }
    
}

struct ListCell: View {
    var noteTitle: String
    var noteContent: String
    var hasRecording: Bool
    
    var body: some View {
        HStack {
            VStack (alignment: .leading){
                Text(noteTitle)
                    .font(.bold21)
                    .bold()
                
                Text(noteContent)
                    .font(.regular18)
                    .lineLimit(2)
            }
            Spacer()
            
            if hasRecording == true {
                Image(systemName: "mic")
            }
            
        }
        
        
    }
}

// MARK: NewNote
struct NewNoteView: View {
    
    // Allows me to go back to previous view when pressing save
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var allNotes: AllNotes
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    
    @State var noteContent = ""
    @State var noteTitle: String = "New note"
    @State var selectedNewNote = Note(noteTitle: "New Note", noteContent: "")
    @Binding var showPicker: Bool
    
    var body: some View {
        
        VStack {
            
            TextField("New recording", text: $noteTitle)
                .font(.system(size: 30).bold())
                .padding(.horizontal)
            
            
            TextEditor(text: $noteContent)
                .background(.cyan)
                .padding(.horizontal)
            
            
        }.navigationBarTitle("", displayMode: .inline)
            .onAppear {
                showPicker = false
            }
            .onDisappear {
                
                if noteTitle != "New note" || noteContent != "" {
                    let newNote = Note(noteTitle: noteTitle, noteContent: noteContent)
                    allNotes.addEntry(newNote: newNote)
                    firestoreConnection.addNoteToDb(note: newNote)
                }
            }
    }
}



struct ExitKeyboardBar: View {
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(Color.init(red: 245/255, green: 245/255, blue: 245/255))
                .overlay(Divider().padding(0), alignment: .top)
            
            
        Image(systemName: "keyboard.chevron.compact.down")
                
    }
}
}

// MARK: EditNote

struct EditNoteView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @EnvironmentObject var allNotes: AllNotes
    @EnvironmentObject var audioRecorder: AudioRecorder
    @Binding var showRecordPopup: Bool
    @Binding var showPicker: Bool
    @Binding var showEditTabVew: Bool
    
    @State var selectedNote: Note
    @State var showPlayer = false
    @State var selectedRecording: UserDocumentRecording?
    @StateObject var audioPlayer = AudioPlayer()
    @State var noteToRemove: Note?
    @FocusState var contentIsFocused: Bool
    @State var showExitBtn = false
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 0) {
                
                TextField("New recording", text: $selectedNote.noteTitle)
                    .font(.bold34)
                    //.font(.system(size: 30).bold())
                    .padding(.horizontal)
                
                
                TextEditor(text: $selectedNote.noteContent)
                    .font(.regular21)
                    .background(.cyan)
                    .padding(.horizontal)
                    .focused($contentIsFocused)
                
                //RecordingsList(selectedNote: $selectedNote)
                
                if showPlayer {
                    PlayerView(audioPlayer: audioPlayer, selectedRecording: $selectedRecording)
                        .padding()
                        .transition(.move(edge: .bottom))
                    
                }
                
                if showEditTabVew {
                    CustomTabViewNotes(audioRecorder: audioRecorder, showRecordPopup: $showRecordPopup, showEditTabView: $showEditTabVew, selectedNote: $selectedNote, showPlayer: $showPlayer, selectedRecording: $selectedRecording)
                }
                
                
                
                
                if contentIsFocused {
                    ExitKeyboardBar()
                        .onAppear {
                            showEditTabVew = false
                            contentIsFocused = true
                        }
                        .onTapGesture {
                        contentIsFocused = false
                        showEditTabVew = true
                    }
                        .frame(height: 50)
                    
                }
                
                
                
            }
            
        }.onAppear{
            noteToRemove = selectedNote
            if showEditTabVew == false {
                showEditTabVew = true
            }
            showPicker = false
        }
        .navigationBarTitle("", displayMode: .inline)
        
        .onDisappear { firestoreConnection.editNoteOnDb(noteToRemove: noteToRemove!, noteToAdd: selectedNote) }
        .overlay(alignment: .bottom) {
            if showRecordPopup {
            RecordingEditNoteView(audioRecorder: audioRecorder, showRecordPopup: $showRecordPopup, showEditTabView: $showEditTabVew, selectedNote: $selectedNote)
                .transition(.move(edge: .bottom))
            
        } }
    }
    
    
}

// MARK: Custom tabs
struct CustomTabViewNotes: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @EnvironmentObject var allNotes: AllNotes
    @State private var sort: Int = 0
    @Binding var showRecordPopup: Bool
    @Binding var showEditTabView: Bool
    @Binding var selectedNote: Note
    @Binding var showPlayer: Bool
    @Binding var selectedRecording: UserDocumentRecording?
    var body: some View {
        
        ZStack {
            
            Rectangle()
            //.foregroundColor(Color.init(red: 245/255, green: 245/255, blue: 245/255))
                .foregroundColor(.white)
                .ignoresSafeArea()
            
            HStack {
                Spacer()
                
                Menu {
                    RecordingMenu(audioRecorder: audioRecorder, selectedNote: $selectedNote, showPlayer: $showPlayer, selectedRecording: $selectedRecording)
                   
                    
                } label: {
                    Image(systemName: "play.fill")
                }.font(.system(size: 40))
                    .foregroundStyle(.black)
                    .onTapGesture {
                        if showPlayer == true {
                            withAnimation{
                                showPlayer = false
                            }
                            
                        }
                    }
                
                
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        showRecordPopup = true
                    }
                    
                   // showEditTabView = false
                    // print(selectedNote)
                },
                       label: {
                    Label("", systemImage: "record.circle")
                        .font(.system(size: 40))
                        .foregroundStyle(.pink, .black)
                    //.navigationTitle("Voice notes")
                })
                
                
                Spacer()
            }
            
        }
        .background(.gray)
        .frame(height: 70)
    }
    
}

struct CustomTabViewHome: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @Binding var showRecordPopup: Bool
    @Binding var showPicker: Bool
    var body: some View {
        
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(Color.init(red: 245/255, green: 245/255, blue: 245/255))
                .overlay(Divider().padding(0), alignment: .top)
            
            
            HStack {
                Spacer()
                NavigationLink(destination: NewNoteView(showPicker: $showPicker), label: {
                    Label("", systemImage: "square.and.pencil")
                        .font(.system(size: 50))
                        .foregroundStyle(.gray)
                    
                    
                })
                
                Spacer()
                
                Button(action: {
                    
                    withAnimation {
                        showRecordPopup = true
                    }
                    
                },
                       label: {
                    Label("", systemImage: "record.circle")
                        .font(.system(size: 50))
                        .foregroundStyle(.pink, .gray)
                })
                Spacer()
                
            }
            
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioRecorder: AudioRecorder(), notesOrRecordings: "notes").environmentObject(AllNotes())
         // NotesHomeView(showRecordPopup: .constant(false), showTabViewPopup: .constant(true), showEditTabView: .constant(false))
        //  .environmentObject(AllNotes())
        
        //    .previewDevice("iPhone 13 Pro")
        //  NewNoteView().environmentObject(AllNotes())
        //        EditNoteView(showRecordPopup: .constant(false), selectedNote: Note(noteTitle: "hej", noteContent: "hej"), showEditTabVew: .constant(true)).environmentObject(AudioRecorder()).environmentObject(AllNotes()).environmentObject(FirestoreConnection())
        //                      selectedNote: Note(noteTitle: "hej", noteContent: "hej"),
        //                      showEditTabVew: .constant(true))
        //            .environmentObject(AllNotes()).environmentObject(AudioRecorder())
       // NotesList(showRecordPopup: .constant(false), showEditTabView: .constant(false))
        // RecordingView(audioRecorder: AudioRecorder())
      //  CustomTabViewHome(audioRecorder: AudioRecorder(), showRecordPopup: .constant(false))
        
      //  ExitKeyboardBar()
    }
}


