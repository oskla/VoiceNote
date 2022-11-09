//
//  RecordingsList.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-28.
//

import Foundation

class AllRecordings: ObservableObject, Identifiable {
    
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
