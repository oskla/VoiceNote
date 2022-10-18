//
//  ContentView.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-13.
//

import SwiftUI


// TODO
// 1. Add Voicememo function
// 2. SearchBar in List
// 3. Break out view from NewNote and EditNote and reuse that component in both
// 4. https://blckbirds.com/post/voice-recorder-app-in-swiftui-2/
// 5. onDelete in NotesList

struct ContentView: View {
    
    @StateObject var allNotes = AllNotes()
    @ObservedObject var audioRecorder: AudioRecorder

    var body: some View {
        
        VStack {
            NotesHomeView(audioRecorder: audioRecorder)
                
        }.environmentObject(allNotes)
        

    }
}

struct NotesHomeView: View {
    
    @EnvironmentObject var allNotes: AllNotes
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        NavigationView {
        VStack {
            NotesList()
            CustomTabViewHome(audioRecorder: audioRecorder)
        }
        .background(Color.init(red: 245/255, green: 245/255, blue: 245/255))
        }
    }
    }




struct NotesList: View {
    
    @EnvironmentObject var allNotes: AllNotes
    
    
    
    var body: some View {
        
        VStack {
            
            List(){
                
                ForEach(allNotes.getAllNotes()) {
                    note in
        
                    NavigationLink(destination: EditNoteView(selectedNote: note)) {
                        
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
    }
}

struct EditNoteView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var allNotes: AllNotes
    
    @State var selectedNote: Note
    
    var body: some View {

        VStack {
            
            TextField("New recording", text: $selectedNote.noteTitle)
                .font(.system(size: 30).bold())
                .padding(.horizontal)

            
            TextEditor(text: $selectedNote.noteContent)
                .background(.cyan)
                .padding(.horizontal)
            
            
                
            
            Button(action: {
                allNotes.editNote(note: selectedNote)

                presentationMode.wrappedValue.dismiss()
            }, label: {
            Text("Save")
            })
            
            
        }.navigationBarTitle("", displayMode: .inline)
    }
    
}

struct CustomTabViewHome: View {
    @ObservedObject var audioRecorder: AudioRecorder
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
                    NavigationLink(destination: RecordingView(audioRecorder: audioRecorder), label: {
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
        ContentView(audioRecorder: AudioRecorder()).environmentObject(AllNotes())
        //    .previewDevice("iPhone 13 Pro")
       // NewNoteView().environmentObject(AllNotes())
       // EditNoteView(note: "hej").environmentObject(AllNotes())
       // NotesList().environmentObject(AllNotes())
       // RecordingView(audioRecorder: AudioRecorder())
    }
}
