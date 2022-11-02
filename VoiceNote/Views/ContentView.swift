//
//  ContentView.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-13.
//

import SwiftUI
import Firebase
import FirebaseStorage


// TODO

// - BUGS - When creating new account, you can't start recording right away. Firebase Storage + Firestore-connection doesnt seem to link properly

// - Fetch recordings from Firebase (to show accurate information inside editNote)
// - When recording inside EditNote - no new note in list should be added
// - SearchBar in List
// - Add index-number and add automatically to title
// - Break out view from NewNote and EditNote and reuse that component in both
//-. https://blckbirds.com/post/voice-recorder-app-in-swiftui-2/


struct ContentView: View {
    

    @StateObject var firestoreConnection = FirestoreConnection()
    @StateObject var allNotes = AllNotes()
    @StateObject var allRecordings = AllRecordings()
    @ObservedObject var audioRecorder: AudioRecorder
    @State var showRecordPopup = false
    @State var showTabViewPopup = true
    @State var showEditTabView = true
    
    
    
    var body: some View {
        
        ZStack {
            
            if firestoreConnection.userLoggedIn == true {
                
            NavigationView {
                VStack {
                    
                    // Debug-button
//                    Button(action: {
//                        print(firestoreConnection.userDocument?.name ?? "error loading name")
//                        print(firestoreConnection.userDocument?.recording ?? "error")
//                    }, label: {
//                        Text("firestore name")
//                    })
//
                    NotesHomeView(showRecordPopup: $showRecordPopup, showTabViewPopup: $showTabViewPopup, showEditTabView: $showEditTabView)
                    
                    // REGISTER-BUTTON
//                    NavigationLink(destination: LoginView(), label: {
//                        Text("Register")
//                    }).padding().foregroundColor(.blue)
                    
                }
                
                
                
            }.onAppear {
                firestoreConnection.listenToFirestore {
                    guard let recordings = firestoreConnection.userDocument?.recording else {
                       print("userDoc was empty")
                        return
                    }
                  //  allRecordings.convertStringRecordingToUserDocRecording(stringRecordingArray: recordings)
                }
               
//                audioRecorder.getAllMetaDataFromStorage(completion: { result in
//                    print("klaor result: \(result)")
//                })
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

struct NotesHomeView: View {
    @EnvironmentObject var allNotes: AllNotes
    @EnvironmentObject var audioRecorder: AudioRecorder
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
                
//                if showRecordPopup {
//                    RecordingView(showRecordPopup: $showRecordPopup, showTabViewPopup: $showTabViewPopup, showEditTabView: $showEditTabView)
//                     .transition(.move(edge: .bottom))
//                }
                
            }.overlay(alignment: .bottom) {
                if showRecordPopup {
                    RecordingView(showRecordPopup: $showRecordPopup, showTabViewPopup: $showTabViewPopup, showEditTabView: $showEditTabView)
                     .transition(.move(edge: .bottom))
                }
            }
 
            .background(Color.init(red: 245/255, green: 245/255, blue: 245/255))
            .onAppear{
                showTabViewPopup = true
            }
        }
    }
}




struct NotesList: View {
    
    @EnvironmentObject var allNotes: AllNotes
    @EnvironmentObject var audioRecorder: AudioRecorder
    @Binding var showRecordPopup: Bool
    @Binding var showEditTabView: Bool
    
    var body: some View {
        
        VStack {
            
            List(){
                
                ForEach(allNotes.getAllNotes()) {
                    note in
                    
                    NavigationLink(destination: EditNoteView( showRecordPopup: $showRecordPopup, selectedNote: note, showEditTabVew: $showEditTabView)) {
                        
                        ListCell(noteTitle: note.noteTitle, noteContent: note.noteContent)
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
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    
    @State var noteContent = ""
    @State var noteTitle: String = "New note"
    @State var selectedNewNote = Note(noteTitle: "New Note", noteContent: "")
    
    var body: some View {
        
        VStack {
            
            TextField("New recording", text: $noteTitle)
                .font(.system(size: 30).bold())
                .padding(.horizontal)
            
            
            TextEditor(text: $noteContent)
                .background(.cyan)
                .padding(.horizontal)
            
            
        }.navigationBarTitle("", displayMode: .inline)
            .onDisappear {
                
                if noteTitle != "New note" || noteContent != "" {
                    let newNote = Note(noteTitle: noteTitle, noteContent: noteContent)
                    allNotes.addEntry(newNote: newNote)
                    firestoreConnection.addNoteToDb(note: newNote)
                }
            }
    }
}


struct EditNoteView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @EnvironmentObject var allNotes: AllNotes
    @EnvironmentObject var audioRecorder: AudioRecorder
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
            
            RecordingsList(selectedNote: $selectedNote)
            
            if showEditTabVew {
                CustomTabViewNotes(audioRecorder: audioRecorder, showRecordPopup: $showRecordPopup, showEditTabView: $showEditTabVew, selectedNote: $selectedNote)
            }
            
            if showRecordPopup {
                RecordingEditNoteView(audioRecorder: audioRecorder, showRecordPopup: $showRecordPopup, showEditTabView: $showEditTabVew, selectedNote: $selectedNote)
                 
            }
            
            
        }
        .navigationBarTitle("", displayMode: .inline)
            .onChange(of: selectedNote, perform: allNotes.editNote)
            .onDisappear {
                
               
                firestoreConnection.addNoteToDb(note: selectedNote)
                }
    }

    
}

struct CustomTabViewNotes: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @EnvironmentObject var allNotes: AllNotes
    @State private var sort: Int = 0
    @Binding var showRecordPopup: Bool
    @Binding var showEditTabView: Bool
    @Binding var selectedNote: Note
    var body: some View {
        
        ZStack {
            
            Rectangle()
                .foregroundColor(Color.init(red: 245/255, green: 245/255, blue: 245/255))
                .ignoresSafeArea()
            
            HStack {
                Spacer()
                
                Menu {
                    RecordingMenu(audioRecorder: audioRecorder, selectedNote: $selectedNote)
                } label: {
                    Image(systemName: "play.fill")
                }.font(.system(size: 40))
                    .foregroundStyle(.black)
                
                Spacer()
                
                Button(action: {
                    showRecordPopup = true
                    showEditTabView = false
                    // print(selectedNote)
                },
                       label: {
                    Label("", systemImage: "record.circle")
                        .font(.system(size: 40))
                        .foregroundStyle(.pink, .black)
                        .navigationTitle("Voice notes")
                })
                
                
                Spacer()
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
            
            
            HStack {
                Spacer()
                NavigationLink(destination: NewNoteView(), label: {
                    Label("", systemImage: "square.and.pencil")
                        .font(.system(size: 40))
                        .foregroundStyle(.black)
                    
                    
                })
                
                Spacer()
                
                Button(action: {
                    
                    withAnimation {
                        showRecordPopup = true
                    }
                    
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
       // NotesHomeView(showRecordPopup: .constant(true), showTabViewPopup: .constant(false), showEditTabView: .constant(false))
           // .environmentObject(AudioRecorder())
         //   .environmentObject(AllNotes())
            
        //    .previewDevice("iPhone 13 Pro")
        //  NewNoteView().environmentObject(AllNotes())
        EditNoteView(showRecordPopup: .constant(true), selectedNote: Note(noteTitle: "hej", noteContent: "hej"), showEditTabVew: .constant(false)).environmentObject(AudioRecorder()).environmentObject(AllNotes()).environmentObject(FirestoreConnection())
//                      selectedNote: Note(noteTitle: "hej", noteContent: "hej"),
//                      showEditTabVew: .constant(true))
//            .environmentObject(AllNotes()).environmentObject(AudioRecorder())
        // NotesList().environmentObject(AllNotes())
        // RecordingView(audioRecorder: AudioRecorder())
    }
}
