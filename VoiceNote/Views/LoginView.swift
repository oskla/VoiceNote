//
//  LoginView.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-27.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var firestoreConnection: FirestoreConnection
    @State var lightGray = Color.init(red: 245/255, green: 245/255, blue: 245/255)
    @State var showRegisterPage = false
    @State var showLoginPage = true
    @State var userName = ""
    @State var password = ""

    var body: some View {
        
        ZStack {
            
        
        VStack {
            
            if showLoginPage {
                LoginFieldsView(firestoreConnection: firestoreConnection, userName: $userName, password: $password, lightGray: lightGray)
                Button(action: {
                    print("logging in")
                    if userName != "" && password != "" {
                    firestoreConnection.loginUser(userName: userName, password: password)
                    showLoginPage.toggle()
                    }
                }, label: {
                    Text("Sign in")
                }).padding()
                    .background(lightGray)
                    .cornerRadius(7)
                
                Button(action: {
                    print("Register")
                    showLoginPage.toggle()
                    showRegisterPage.toggle()
                }, label: {
                    Text("Register")
                }).padding()
                    .background(lightGray)
                    .cornerRadius(7)
            }
           
        }
            if showRegisterPage {
                RegisterView(firestoreConnection: firestoreConnection)
            }
            
            
        }
        
    }
}

struct LoginFieldsView: View {
    @ObservedObject var firestoreConnection: FirestoreConnection
    @Binding var userName: String
    @Binding var password: String
    var lightGray: Color
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Username")
            TextField("", text: $userName)
                .frame(height: 30)
                .background(lightGray)
                .cornerRadius(7)
            
            Text("Password")
            TextField("", text: $password)
                .frame(height: 30)
                .background(lightGray)
                .cornerRadius(7)
            
        }.padding(50)
        
        
    }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(firestoreConnection: FirestoreConnection())
    }
}
