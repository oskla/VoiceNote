//
//  User.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-27.
//

import Foundation
import FirebaseFirestoreSwift


struct UserDocument: Identifiable, Codable, Equatable {
    
    
    @DocumentID var id: String?
    var name: String
    var recording: [UserDocumentRecording]?   // [UserDocumentRecording]
    var notes: [Note]?
    var recCounter: Double?
   
    
}
