//
//  FirestoreConnection.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-27.
//

import Foundation
import Firebase


class FirestoreConnection: ObservableObject {
    
    private var fireStore = Firestore.firestore()
    
    @Published var userLoggedIn = false
    @Published var currentUser: User?
    @Published var userDocument: UserDocument?    
     
     var userDocumentListener: ListenerRegistration?
    
    init() {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("error signing out")
        }
        
        Auth.auth().addStateDidChangeListener {
            auth, user in
            
            if let user = user {
                
                // if logged in
                self.userLoggedIn = true
                self.currentUser = user
                self.listenToFirestore {
                    print("Done listening to Firestore")
                }
                            
                
            } else {
                // if not logged in
                
                self.userLoggedIn = false
                self.currentUser = nil
                self.stopListeningToFirestore()
                
                
            }
        }
    }
    

    
    
   func stopListeningToFirestore() {
       if userDocument != nil {
           userDocumentListener?.remove()
       }
    }
    

    
    
    func listenToFirestore(completion:@escaping()->() ) {
    
        if let currentUser = currentUser {
            userDocumentListener = self.fireStore.collection("userData").document(currentUser.uid).addSnapshotListener { snapshot, error in
                
                if let error = error {
                    print("Error occured \(error)")
                    return
                }
                
                guard let snapshot = snapshot else { return }
                
                let result = Result {
                    try snapshot.data(as: UserDocument.self)
                }
                
                switch result {
                case .success(let userData):
                    self.userDocument = userData
                case .failure(let failure):
                    print("Something went wrong. Error \(failure)")
                }
                
                completion()
               
               // print(self.userDocument)
            }
            
        }
}
    
    func loginUser(userName: String, password: String) {
        
        Auth.auth().signIn(withEmail: userName, password: password) {
            authDataResult, error in
            
           // authDataResult?.user.uid
           // self.userLoggedIn = true
            
            if let error = error {
                print("Error logging in \(error)")
            }
            
        }
        
    }
    
    func registerUser(userName: String, password: String) {
        Auth.auth().createUser(withEmail: userName, password: password) {
            authDataResult, error in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let authDataResult = authDataResult {
                let newUserDocument = UserDocument(id: authDataResult.user.uid, name: userName)
                
                do {
                    // Creating new document in database
                    _ = try self.fireStore.collection("userData").document(authDataResult.user.uid).setData(from: newUserDocument)
                    self.loginUser(userName: userName, password: password)
                } catch {
                    print("error")
                }
                
            }
            
        }
    }
        
    
    func addRecordingToDb(urlPath: String, id: String?) {
        
        if let currentUser = currentUser {
            
          //  fireStore.collection("userData").document(currentUser.uid).updateData(["recording": FieldValue.arrayUnion([urlPath])])
           
            fireStore.collection("userData").document(currentUser.uid).updateData([
                "recording": FieldValue.arrayUnion([[
                    "name": urlPath,
                    "id": id
                    
               ]])
            ])
            
            
            
//            fireStore.collection("userData").document(currentUser.uid).updateData([
//                "recording": ["Name": FieldValue.arrayUnion([urlPath]),
//                              "id": "839tui"
//                             ]
//            ])
                                                                        
                                                                                   
            
            print("upload should be done. urlPath: \(urlPath), currentUser: \(currentUser)")
        } else {
            print("Something went wrong when uploading to Firestore")
        }
        
    }
    
    func deleteRecordingFromDb(urlPath: String) {
        
        if let currentUser = currentUser {
            fireStore.collection("userData").document(currentUser.uid).updateData(["recording": FieldValue.arrayRemove([urlPath])])
        }
       
        
    }
    
    func addNoteToDb(note: Note) {
        
        if let currentUser = currentUser {
            
           // fireStore.collection("userData").document(currentUser.uid).updateData(["notes": FieldValue.arrayRemove([note])])
           
//            fireStore.collection("userData").document(currentUser.uid).updateData([
//                "notes": FieldValue.arrayUnion([[note]])
//            ])
            
            fireStore.collection("userData").document(currentUser.uid).updateData([
                "notes": FieldValue.arrayUnion([[
                    "id": "\(note.id)",
                    "noteTitle": note.noteTitle,
                    "noteContent": note.noteContent
                    
               ]])
            ])
            
            
            
//            do {
//                _ = try fireStore.collection("userData").document(currentUser.uid).updateData([
//                     "notes":
//                         Firestore.Encoder().encode([notes])
//
//                 ])
//            } catch {
//                print("error\(error.localizedDescription)")
//            }
            
          
            
        }
        
    }
    
    func listenToDb() {
        
        if let currentUser = currentUser {
            userDocumentListener = self.fireStore.collection("userData").document(currentUser.uid).addSnapshotListener {
                snapshot, error in
                
                if let error = error {
                    print("Error occured: \(error)")
                    return
                    
                }
                
                guard let snapshot = snapshot else { return }
                let result = Result {
                    try snapshot.data(as: UserDocument.self)
                }
                
                switch result {
                case .success(let userData):
                    self.userDocument = userData
                case .failure(let error):
                    print("Something went wrong, error: \(error)")
                }
                
                
                
            }
        }
        
        
    }
    
    func stopListeningToDb() {
        if let userDocument = userDocument {
            userDocumentListener?.remove()
        }
    }
    
    
    
}
