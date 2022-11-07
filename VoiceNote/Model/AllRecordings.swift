//
//  RecordingsList.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-28.
//

import Foundation

class AllRecordings: ObservableObject, Identifiable {
    
    @Published var recordingsList = [UserDocumentRecording]()
    @Published var recNumber: Bool?
    
    init() {
        addRecording(recording: UserDocumentRecording(name: "rec1"))
        addRecording(recording: UserDocumentRecording(name: "rec2"))
    }
    
    func addRecording(recording: UserDocumentRecording) {
            
            recordingsList.append(recording)
        }
    
    func convertStringRecordingToUserDocRecording(stringRecordingArray: [[String:String]]) {
        
        for recording in stringRecordingArray {
       
            
          //  let newUserDocumentRecording = UserDocumentRecording(["name": String, "id": String])
            
            
//            if let url = URL(string: recording) {
//                if let
//                let newUserDocumentRecording = UserDocumentRecording(url: url)
//                recordingsList.append(newUserDocumentRecording)
//
//
//                  //  print("Printing inside convertStringrec.... \(url)")

//            }
        }
        
    }
    
    func getRecordingArrayById(id: String, db: FirestoreConnection) -> [UserDocumentRecording]? {
        
        guard let userDocument = db.userDocument else { return nil }
        
        let recordingArray = userDocument.recording?.filter( {$0.id == id} )
        
        if let recordings = recordingArray {
            return recordings
        } else {
            return nil
        }
       
    }
    
   
    
    func getRecordingById(id: String, db: FirestoreConnection) -> UserDocumentRecording? {
        
        guard let userDocument = db.userDocument else { return nil }
        
        let filteredRecording = userDocument.recording?.first(where: {$0.id == id})
        
        if let recording = filteredRecording {
            return recording
        } else {
            return nil
        }
    }
    
    // Call on this
    func setCurrentRecNumber(db: FirestoreConnection) {
        
        
        guard let recordings = db.userDocument?.recording else { return }
        
        let maxRec = recordings.max(by: {
            if $0.recNumber == nil { return false }
            if $1.recNumber == nil { return false }
            
            return $0.recNumber! < $1.recNumber!
            
        })
        
        print("maxRec: \(maxRec)")
        
      //  recNumber = maxRec
        
    }
    
    func getAndAddMetaDataFromStorage(name: String) {
        
//        print("printing name \(name)")
//        
//        var filtered = recordingsList.filter {
//            let strUrl = "\($0.url)"
//            return strUrl.contains(name)
//        }
//        print("Filtered metadata-name: \(filtered)")
        
       // filtered[0].name = name
    }
    

    
}
