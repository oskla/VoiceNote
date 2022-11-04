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
    
//    init() {
//
//        addEntry(newNote: Note(noteTitle: "Titel", noteContent: "content"))
//        addEntry(newNote: Note(noteTitle: "Titel2", noteContent: "content2"))
//        addEntry(newNote: Note(noteTitle: "Titel3", noteContent: "content3"))
//        addEntry(newNote: Note(noteTitle: "Titel4", noteContent: "content4"))
//        addEntry(newNote: Note(noteTitle: "Titel5", noteContent: "content5"))
//
//    }
    
    func addEntry(newNote: Note) {
        notes.append(newNote)
        
    }
    
    func hasRecordings(noteId: String, db: FirestoreConnection) -> Bool {
        
        guard let userDocumentRecording =  db.userDocument?.recording else { return false }
        
        let new = userDocumentRecording.first(where: {$0.id == noteId})
        
        if new != nil {
            return true
        }
        return false
    }
    
    func getAllNotes() -> [Note] {
        return notes
    }
    
    func getNoteAt(index: Int) -> Note? {
        return notes[index]
    }
    
    func editNote(note: Note) {
       
        if let selectedNote = notes.first(where: {$0.id == note.id}) {
            let index = notes.firstIndex(of: selectedNote)
            
            notes[index!].noteTitle = note.noteTitle
            notes[index!].noteContent = note.noteContent
            
        }
        
   
    }
    
    func sortNotes(notes: [Note]) -> [Note]{
        
        let reverserdNotes: [Note] = Array(notes.reversed())
        
        print("Reversed notes \(reverserdNotes)")
        return reverserdNotes
    }
    
    func getLatestRecording(audioRecorder: AudioRecorder, selectedNote: Note) -> Recording? {
        guard let currentRecording = audioRecorder.recordings.last else {
            print("failed")
            return nil
            }
        
        return currentRecording
    }
    
    func removeNote(at offsets: IndexSet, db: FirestoreConnection, note: Note) {
        notes.remove(atOffsets: offsets)
        db.deleteNoteFromDb(note: note)
        
    }
    
//    func getNameOfRecording(selectedNote: Note) -> String {
//        if selectedNote.recording.isEmpty == false {
//            let noteCreatedAt: String = ("\(selectedNote.recording[0].createdAt)")
//            return noteCreatedAt
//        }
        
//        
//       return "failed getting name"
//    }
       
 
    
 
    func getIndexByID(note: Note) -> [Note] {
        
        let updatedNotes = notes.filter() {$0.id == note.id }
        print("Found by id: \(updatedNotes)")
        return updatedNotes
    }
}
