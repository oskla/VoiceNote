//
//  AllNotes.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-13.
//

import Foundation
import SwiftUI

class AllNotes: ObservableObject {
    
    @Published var notes = [Note]()
    
    init() {
        
//        addEntry(newNote: Note(noteTitle: "Titel", noteContent: "content", recording: "Recording"))
//        addEntry(newNote: Note(noteTitle: "Titel1", noteContent: "content2", recording: "Recording"))
//        addEntry(newNote: Note(noteTitle: "Titel2", noteContent: "content3", recording: "Recording"))
//        addEntry(newNote: Note(noteTitle: "Titel3", noteContent: "content4", recording: "Recording"))
//        addEntry(newNote: Note(noteTitle: "Titel4", noteContent: "content5", recording: "Recording"))
        
    }
    
    func addEntry(newNote: Note) {
        notes.append(newNote)
        
    }
    
    func getAllNotes() -> [Note] {
        return notes
    }
    
    func getNoteAt(index: Int) -> Note? {
        return notes[index]
    }
    
    func editNote(note: Note)  {
       
        if let note2 = notes.first(where: {$0.id == note.id}) {
            let index = notes.firstIndex(of: note2)
            
            notes[index!].noteTitle = note.noteTitle
        
            
        }
            

         
        }
        
 
    func getIndexByID(note: Note) -> [Note] {
        
        let updatedNotes = notes.filter() {$0.id == note.id }
        print("Found by id: \(updatedNotes)")
        return updatedNotes
    }
}
