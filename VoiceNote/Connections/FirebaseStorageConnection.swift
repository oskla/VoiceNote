//
//  FirebaseStorageConnection.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-27.
//

import Foundation
import FirebaseStorage


//class FirebaseStorageConnection: ObservableObject, Identifiable {
//  
//    
// 
//    
//    func deleteFiles(_ fileToDelete: String) {
//            let fName = fileToDelete.getFileName()
//            let fExtension = fileToDelete.getFileExtension()
//            
//            let fURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            
//            let deleteAtURL = fURL.appendingPathComponent(fName).appendingPathExtension(fExtension)
//            
//            do {
//                try FileManager.default.removeItem(at: deleteAtURL)
//                print("Recording has been deleted")
//            } catch {
//                print(error)
//            }
//        }
//    
//}
