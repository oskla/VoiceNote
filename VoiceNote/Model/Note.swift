//
//  Note.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-13.
//

import Foundation

struct Note : Codable, Identifiable, Equatable {
    
    var id = UUID()
    var noteTitle: String
    var noteContent: String
  //  var date: Date
    var recording: String? // Add recording here later
   
   
}
