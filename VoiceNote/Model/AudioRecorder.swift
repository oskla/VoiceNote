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
    
    
    
    
    func stopRecording(db: FirestoreConnection, userDocument: UserDocument, allRecordings: AllRecordings, selectedNoteId: String?) {
        
        audioRecorder.stop()
        recording = false
        
        guard let audioFileUrl = audioFileUrl else {
            print("audioFileUrl was empty")
            return
        }
        
        
        // Upload to Firebase Storage
        handleAudioSendWith(allRecordings: allRecordings, db: db, url: "\(audioFileUrl)", completion: { data, metadata in
            
           // print("data from completeion: \(data)") // - Why is this nil?
            
            guard let downloadUrl = self.downloadUrl else {
                return
            }
            
            
            db.addRecordingToDb(urlPath: "\(downloadUrl)", id: selectedNoteId)  // Add to firestore
            
            
            self.deleteFiles("\(audioFileUrl)")      // Delete file from device
            
        })
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
    
    
    
    
    
    
    
    
    /// FIREBASE STORAGE
    
    func handleAudioSendWith(allRecordings: AllRecordings,db: FirestoreConnection, url: String, completion:@escaping((String?,StorageMetadata?) -> () ) ) {
        
        @EnvironmentObject var firestoreConnection: FirestoreConnection
        
        guard let fileUrl = URL(string: url) else {
            return
        }
        
        let dateString = Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")
        let fileName = NSUUID().uuidString + dateString + ".m4a"
        let storageRef = Storage.storage().reference().child("recordings")
        let path = "recordings/\(fileName)"
        
        storageRef.child(fileName).putFile(from: fileUrl, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error ?? "error")
            }
            
            
            self.fetchRecording(path: path) { url in
                
                print("data from fetchrecording \(url)") // I should upload to db here?
            }
            
            self.getMetaDataFromStorage(path: path, completion: { metadata in
                if let metadataName = metadata?.name {
                    allRecordings.getAndAddMetaDataFromStorage(name: metadataName)
                } else {
                    print("no metadata detected")
                }
            })
            
            storageRef.downloadURL { (url, error) in
                guard let urlStr = url else {
                    completion(nil, nil)
                    return }
                let urlFinal = (urlStr.absoluteString)
                self.audioFileUrl = urlStr
                completion(urlFinal, metadata)
            }
            
        }
        
    }
    
    func getAllMetaDataFromStorage(completion:@escaping(([String]) -> () )) {
     
        let fileRef = Storage.storage().reference().child("recordings/")
        
        fileRef.listAll(completion: { result, error in
            
            if let error = error {
                print("error when listing files from storage: \(error.localizedDescription)")
            } else {
                
                if let resultItems = result?.items {
                    var arrayOfItems = [String]()
                    for item in resultItems {
                        
                        
                        arrayOfItems.append(item.name)
                        
                    }
                    
                   // completion("\(resultItems)")
                }
                
            }
            
            
    
        })
        
    
        
    }
    
    func getMetaDataFromStorage(path: String, completion:@escaping((StorageMetadata?) -> () )) {
        let fileRef = Storage.storage().reference().child(path)
        
        fileRef.getMetadata(completion: { metadata, error in
            
            if let error = error {
                print("error retrieving metadata: \(error.localizedDescription)")
            } else {
                
                print("metadata from GetMeta...\(metadata)")
                completion(metadata)
                
            }
        })
        
    }
    
    func fetchRecording(path: String, completion:@escaping((String?) -> () ) ) {
        
        let fileRef = Storage.storage().reference().child(path)
        
        
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
    
    func deleteRecordingFromStorage(path: String) {
        
        let fileRef = Storage.storage().reference().child(path)
        
        
    }
    
    
}
