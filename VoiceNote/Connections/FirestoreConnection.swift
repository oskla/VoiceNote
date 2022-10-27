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
                self.listenToFirestore()
                
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
    
    
    
    func listenToFirestore() {
    
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
                } catch {
                    print("error")
                }
                
            }
            
        }
    }
    
    
    func addRecordingToDb(urlPath: String) {
        
        if let currentUser = currentUser {
            
            fireStore.collection("userData").document(currentUser.uid).updateData(["recording": FieldValue.arrayUnion([urlPath])
                                                                                  ])
            
            
        }
        
    }
    
    func addNoteToDb(urlPath: String) {
        
        if let currentUser = currentUser {
            
            fireStore.collection("userData").document(currentUser.uid).updateData(["notes": FieldValue.arrayUnion([urlPath])])
            
        }
        
    }
    
    
    
}
