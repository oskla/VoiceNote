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
import FirebaseStorage
import FirebaseFirestore

class AudioRecorder: NSObject, ObservableObject, Identifiable {
    
    override init() {
        super.init()
        //fetchRecordings()
    }
    
    let firestoreConnection = FirestoreConnection()
    var audioFileUrl: URL?
    var downloadUrl: URL?
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    var audioRecorder: AVAudioRecorder!
    var recordings = [Recording]()
    var placeHolderNote = Note(noteTitle: "placeholder2", noteContent: "placeholder2")
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
//    func getAllRecordings() -> [Recording] {
//        return recordings
//    }
    
   

    // RECORDING LOGIC
    
    func startRecording2() {
      
        let recordingSession = AVAudioSession.sharedInstance()
        let tempAudioFileUrl2 = getAudioFileURL()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to start recording")
        }
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
           
            audioRecorder = try AVAudioRecorder(url: tempAudioFileUrl2, settings: settings)
            audioRecorder.record()
        
            recording = true
            
        } catch {
            print("Could not start recording")
        }

        audioFileUrl = tempAudioFileUrl2
    }
    
   
    
    
    func stopRecording(db: FirestoreConnection, userDocument: UserDocument) {

        audioRecorder.stop()
        recording = false
        
        guard let audioFileUrl = audioFileUrl else {
           print("audioFileUrl was empty")
            return
        }
        

        // Upload to Firebase Storage
       handleAudioSendWith(db: db, url: "\(audioFileUrl)", completion: { _ in
           
           guard let downloadUrl = self.downloadUrl else {
               return
           }

           db.addRecordingToDb(urlPath: "\(downloadUrl)")  // Add to firestore
           db.addRecordingToUserDocument(audioURL: downloadUrl, userDocument: userDocument)  // Add data to User Document
            self.deleteFiles("\(audioFileUrl)")      // Delete file from device
           
        })
        //db.addRecordingToDb(urlPath: "\(self.downloadUrl)")
        
        
    }
    
    
    
    
    
    // LOCAL STORAGE
    
    func getAudioFileURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("\(NSUUID().uuidString).m4a")
    }

    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    
    
    /// FIREBASE STORAGE
  
    func handleAudioSendWith(db: FirestoreConnection, url: String, completion:@escaping((String?) -> () ) ) {
       
        @EnvironmentObject var firestoreConnection: FirestoreConnection
        
        guard let fileUrl = URL(string: url) else {
            return
        }
        
        let dateString = Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")
        let fileName = NSUUID().uuidString + dateString + ".m4a"
        let storageRef = Storage.storage().reference().child("recordings")
       // var urlPath: URL?
        let path = "recordings/\(fileName)"

        storageRef.child(fileName).putFile(from: fileUrl, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error ?? "error")
            }
            
            if error == nil {
                
              //  db.addRecordingToDb(urlPath: path)
                
            }
            
            self.fetchRecording(path: path) {_ in
                
                print("downloadURL from closure in fetch: \(self.downloadUrl)")
            }
            
            
            storageRef.downloadURL { (url, error) in
                guard let urlStr = url else {
                    completion(nil)
                    return }
                let urlFinal = (urlStr.absoluteString)
                self.audioFileUrl = urlStr
                completion(urlFinal)
            }

        }
       
    }

    
    func fetchRecording(path: String, completion:@escaping((String?) -> () ) ) {
        
        let fileRef = Storage.storage().reference().child(path)
        var urlPath: URL?
        
        fileRef.downloadURL { url, error in
            if let error = error {
                print("error: \(error)")
                completion(nil)
            } else {
                
                guard let urlStr = url else {
                    completion(nil)
                    return }
                
                let urlFinal = (urlStr.absoluteString)
                self.downloadUrl = urlStr
                completion(urlFinal)
//                self.downloadUrl = url
//                urlPath = url
//                print("does it even reach here? \(url)")
            }
        }
    }
    
    func deleteFiles(_ fileToDelete: String) {
            let fName = fileToDelete.getFileName()
            let fExtension = fileToDelete.getFileExtension()
            
            let fURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let deleteAtURL = fURL.appendingPathComponent(fName).appendingPathExtension(fExtension)
            
            do {
                try FileManager.default.removeItem(at: deleteAtURL)
                print("Recording has been deleted")
            } catch {
                print(error)
            }
        }
    
    
    
    
    
    
//    func fetchRecordings() {
//
//        recordings.removeAll()
//
//        let fileManager = FileManager.default
//        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
//
//        for audio in directoryContents {
//            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
//
//            recordings.append(recording)
//
//           _ = recordings.sorted(by: {$0.createdAt.compare($1.createdAt) == .orderedAscending})
//            objectWillChange.send(self)
//        }
//    }
}
