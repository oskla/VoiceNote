//
//  User.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-27.
//

import Foundation
import FirebaseFirestoreSwift


struct UserDocument: Identifiable, Codable {
    
    
    @DocumentID var id: String?
    var name: String
    var recording: [String]?
    var notes: [Note]?
    
}
