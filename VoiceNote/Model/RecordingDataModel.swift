//
//  RecordingDataModel.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-17.
//

import Foundation

struct Recording: Decodable, Encodable, Equatable, Identifiable {
   
    var id: UUID?
    let fileURL: URL
    let createdAt: Date
    var belongsToNoteId: UUID?

}
