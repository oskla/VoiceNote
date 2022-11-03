//
//  RegisterView.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-27.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var firestoreConnection: FirestoreConnection
    @State var lightGray = Color.init(red: 245/255, green: 245/255, blue: 245/255)
    @State var userName = ""
    @State var password = ""
    @Binding var showLoginPage: Bool
    @Binding var showRegisterPage: Bool
     var body: some View {
         
         
         VStack(alignment: .leading) {
             Spacer()
             Text("Register new account").font(.system(size: 21))
             Spacer()
             RegisterFieldsView(dbConnection: firestoreConnection, userName: $userName, password: $password, lightGray: lightGray)
             Spacer()
             Button(action: {
                 print("registering")
                 
                 if userName != "" && password != "" {
                     firestoreConnection.registerUser(userName: userName, password: password)
                 }
                 
                 
             }, label: {
                 Text("Sign up")
                     .foregroundColor(.black)
                     .font(.system(size: 21))
                     .bold()
             }).frame(maxWidth: .infinity)
                     .padding(20)
                     .border(Color.black, width: 2)
                     .background(.white)
             
             HStack(spacing: 0) {
                 Spacer()
                 Text("Already have an account? ")
                 Text("Login here")
                     .foregroundColor(.blue)
                     .onTapGesture{
                         showLoginPage.toggle()
                         showRegisterPage.toggle()
                     }
                 Spacer()
             }
             Spacer()
             
         }.padding(50)
         
     }
}



struct RegisterFieldsView: View {
    @ObservedObject var dbConnection: FirestoreConnection
    
    @Binding var userName: String
    @Binding var password: String
    @State var confirmPassword = ""
    var lightGray: Color
    
    var body: some View {
        
        VStack(alignment: .leading) {
            

            HStack {
                Image(systemName: "envelope")
                TextField("Your email", text: $userName)
                    .font(.system(size: 22))
                    .frame(height: 50)
                    .background(.white)
            }
            Rectangle().frame(height: 1)
                .padding(.bottom, 5)
      
            HStack {
                Image(systemName: "key")
                TextField("Your password", text: $password)
                    .font(.system(size: 22))
                    .frame(height: 50)
                    .background(.white)
            }
            Rectangle().frame(height: 1)
                .padding(.bottom, 5)
            HStack {
                Image(systemName: "key")
                TextField("Confirm password", text: $confirmPassword)
                    .font(.system(size: 22))
                    .frame(height: 50)
                    .background(.white)
            }
            Rectangle().frame(height: 1)
                .padding(.bottom, 5)
            
        }
        
        
    }
    
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(firestoreConnection: FirestoreConnection(), showLoginPage: .constant(false), showRegisterPage: .constant(true))
    }
}
