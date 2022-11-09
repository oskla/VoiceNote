//
//  LoginView.swift
//  VoiceNote
//
//  Created by Oskar Larsson on 2022-10-27.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @State var lightGray = Color.init(red: 245/255, green: 245/255, blue: 245/255)
    @State var showRegisterPage = false
    @State var showLoginPage = true
    @State var userName = ""
    @State var password = ""

    var body: some View {
        
        ZStack {
            
        
            VStack (alignment: .leading) {
            
            if showLoginPage {
                
                Spacer()
                Text("Login to your account")
                    .font(.regular24)
                    
                Spacer()
                LoginFieldsView(userName: $userName, password: $password, lightGray: lightGray)
                Spacer()
                Button(action: {
                    print("logging in")
                    if userName != "" && password != "" {
                    firestoreConnection.loginUser(userName: userName, password: password)
                    showLoginPage.toggle()
                    }
                }, label: {
                    Text("Sign in")
                        .foregroundColor(.black)
                        .font(.btnBold)
                            
                        //.font(.system(size: 21))
                       // .bold()
                }).frame(maxWidth: .infinity)
                    .padding(20)
                    .border(Color.black, width: 2)
                    .background(.white)
                    
                
               
                HStack(spacing: 0) {
                    Spacer()
                    Text("Don't have an account? ")
                    Text("Register here")
                        .foregroundColor(.blue)
                        .onTapGesture {
                        showLoginPage.toggle()
                        showRegisterPage.toggle()
                    }
                    Spacer()
                }.font(.light16) // TODO: Make light18
                
                Spacer()
            }
           
            }.onAppear{userName = "9@9.se";password = "Hejhej"}
            .padding(50)
            if showRegisterPage {
                RegisterView(firestoreConnection: firestoreConnection, showLoginPage: $showLoginPage, showRegisterPage: $showRegisterPage)
            }
            
            
        }
        
    }
}

struct LoginFieldsView: View {
    @EnvironmentObject var firestoreConnection: FirestoreConnection
    @Binding var userName: String
    @Binding var password: String
    var lightGray: Color
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
 
            HStack {
                Image(systemName: "envelope")
                TextField(" Your email", text: $userName)
                    .font(.regular24)
                    .frame(height: 50)
                    .background(.white)
                .cornerRadius(7)
            }
            Rectangle().frame(height: 1)
                .padding(.bottom, 5)
            
            HStack {
                Image(systemName: "key")
                SecureField(" Your password", text: $password)
                    .font(.regular24)
                    .frame(height: 50)
                    .background(.white)
                .cornerRadius(7)
            }.padding(.top, 5)
            Rectangle().frame(height: 1)
            
        }
        
        
    }
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(FirestoreConnection())
    }
}
