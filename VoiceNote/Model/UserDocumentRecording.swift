//
//  UserDocumentRecording.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-29.
//

import Foundation

struct UserDocumentRecording: Identifiable, Codable, Hashable {


    var id = ""
    var name: String?
    var nickname: String?
    var recNumber: Int64?

    
}
