//
//  ContentView.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-13.
//

import SwiftUI


// TODO - Design NewNote

struct ContentView: View {
    
    @StateObject var allNotes = AllNotes()
    
    var body: some View {
        
        VStack {
            NotesHomeView()
                
        }.environmentObject(allNotes)
        

    }
}

struct NotesHomeView: View {
    
    @EnvironmentObject var allNotes: AllNotes
    
    var body: some View {
        NavigationView {
        VStack {
            NotesList()
            CustomTabViewHome()
        }
        .background(Color.init(red: 245/255, green: 245/255, blue: 245/255))
        }
    }
    }


struct RecordingView: View {
    var body: some View {
        Text("Recording")
        
    }
    
}



struct NotesList: View {
    
    @EnvironmentObject var allNotes: AllNotes
    @State var noteTitle = ""
    
    var body: some View {
    
            VStack {
                List(){
                    ForEach(allNotes.getAllNotes()) {
                        note in
                        
                        NavigationLink(destination: EditNoteView(selectedNote: note)) {
                        Text(note.noteTitle)

                            .listRowBackground(Color.init(red: 245/255, green: 245/255, blue: 245/255))
                            .font(.title2)
                            
                               
                            
                        }}
                }
                .listStyle(SidebarListStyle())

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
    @State var noteTitle: String = "New note"
    
    var body: some View {

        VStack {
            
            TextField("New recording", text: $selectedNote.noteTitle)
                .font(.system(size: 30).bold())
                .padding(.horizontal)

            
            TextEditor(text: $selectedNote.noteContent)
                .background(.cyan)
                .padding(.horizontal)
            
            
                
            
            Button(action: {
                selectedNote.noteTitle = "hej"
                presentationMode.wrappedValue.dismiss()
            }, label: {
            Text("Save")
            })
            
            
        }.navigationBarTitle("", displayMode: .inline)
    }
    
}

struct CustomTabViewHome: View {
    
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
                    NavigationLink(destination: RecordingView(), label: {
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


//struct TabViewView: View {
//
//        @ObservedObject var allNotes: AllNotes
//
//        @State private var isPresenting = false
//        @State private var selectedItem = 1
//        @State private var oldSelectedItem = 1
//
//        var body: some View {
//
//            TabView(selection: $selectedItem) {
//                NotesHomeView(allNotes: allNotes)
//                    .tabItem { Label("Home", systemImage: "list.dash")}
//                    .tag(1)
//
//
//                NavigationView{
//                    NewNoteView()
//                        .navigationTitle("hej")
//                }
//                .tabItem { Label("New note", systemImage: "list.dash")
//                        }
//
//                    .tag(2)
//
//                Text("") // Empty background behind sheet
//                    .tabItem { Label("New recording", systemImage: "list.dash")}
//                    .tag(3)
//            }
//            .onChange(of: selectedItem) {
//                print($selectedItem)
//                if selectedItem == 3 {
//                    self.isPresenting = true
//                } else {
//                    print(self.oldSelectedItem)
//                    self.oldSelectedItem = $0
//                    print(self.oldSelectedItem)
//                }
//            }
//            .sheet(isPresented: $isPresenting, onDismiss: {
//                self.selectedItem = self.oldSelectedItem
//            }) {
//                RecordingView()
//            }
//        }
//
//    }
//
//    }
//





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
       // NewNoteView().environmentObject(AllNotes())
       // EditNoteView(note: "hej").environmentObject(AllNotes())
       // NotesList().environmentObject(AllNotes())
    }
}
