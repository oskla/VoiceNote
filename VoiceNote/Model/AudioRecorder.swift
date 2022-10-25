//
//  AudioRecorder.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-17.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioRecorder: NSObject, ObservableObject, Identifiable {
    
    override init() {
        super.init()
        fetchRecordings()
    }
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    var audioRecorder: AVAudioRecorder!
    var recordings = [Recording]()
    var placeHolderNote = Note(noteTitle: "placeholder2", noteContent: "placeholder2")
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func getAllRecordings() -> [Recording] {
        return recordings
    }
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to start recording")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
        let settings = [
                   AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                   AVSampleRateKey: 12000,
                   AVNumberOfChannelsKey: 1,
                   AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
               ]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            recording = true
        } catch {
            print("Could not start recording")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
        
        fetchRecordings()
    }
    
   
    
    
    func fetchRecordings() {
        
        
       // recordings.removeAll()
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
            

           let dbAudioCreationDate = getCreationDate(for: audio).toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")
            let arrayAudioCreationDate = recording.createdAt.toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")
            
//            print("db creation date: \(dbAudioCreationDate)")
//
//
//            let filtered = getAllRecordings().filter {
//                $0.createdAt.toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss") == dbAudioCreationDate
//            }
//            print("filtered \(filtered)")
//            let filteredFirst = filtered.first
//
//            if let filteredFirst = filteredFirst {
//                recordings.append(filteredFirst)
//            }
            
            recordings.append(recording)
            
           _ = recordings.sorted(by: {$0.createdAt.compare($1.createdAt) == .orderedAscending})
            objectWillChange.send(self)
        }
        
        
    }
    
    func addIdToRecording(selectedNote: Note, recording: Recording) {
        
       //   recording.belongsToNoteId = selectedNote.id
        
    }
    
}
