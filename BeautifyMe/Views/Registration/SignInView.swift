//
//  SignInView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//

import SwiftUI

struct SignInView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()
            
            // Tittle
            Text("Create an account,")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            // subtittle
            Text("Please type full information bellow and we can create your account.")
                .font(.subheadline)
                .foregroundColor(AppColors.darkGrey)
            
            // Input for name
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(AppColors.mediumGrey)
                        .padding(10)
                    TextField("Name", text: $email)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                }
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.mediumGrey, lineWidth: 1))
            }
            
            // Input for email
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(AppColors.mediumGrey)
                        .padding(10)
                    TextField("Email adress", text: $email)
                        .padding()
                        .background(Color.white) 
                        .foregroundColor(.black)
                }
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.mediumGrey, lineWidth: 1))
            }
            
            
            // Input for mobile number
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(AppColors.mediumGrey)
                        .padding(10)
                    TextField("Phone Number", text: $email)
                        .padding()
                }
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.mediumGrey, lineWidth: 1))
            }
            
            
            // Input for password
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(AppColors.mediumGrey)
                        .padding(10)
                    SecureField("Password", text: $password)
                        .padding()
                }
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.mediumGrey, lineWidth: 1))
            }
            // "Forgot Password?"
            VStack {
                Text("By signing in you agree to our")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Button(action: {
                    // action to move to sigIn page
                }) {
                    Text("Term of use and privacy notice")
                        .foregroundColor(AppColors.darkBlue)
                        .fontWeight(.bold)
                        .font(.footnote)
                }
            }
            .padding(.horizontal, 60)
            
            // "Sign In" Button
            Button(action: {
                // Login action, call API
            }) {
                Text("Join Now")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.darkBlue)
                    .cornerRadius(20)
            }
            
            // Separador
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(AppColors.mediumGrey)
                Text("or")
                    .foregroundColor(Color.gray)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray)
            }
            .padding(.vertical)
            
            // Button "Sign In with Google"
            Button(action: {
                // action for google Sign In
            }) {
                HStack {
                    Image(systemName: "globe") // change to google symbol
                    Text("Join with Google")
                }
                .foregroundColor(AppColors.darkBlue)
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.darkBlue, lineWidth: 1))
            }
            
            // Link to register
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                Button(action: {
                    // action to move to sigIn page
                }) {
                    Text("Log In")
                        .foregroundColor(AppColors.darkBlue)
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal,30)
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .background(Color(.white).ignoresSafeArea())
    }
}

#Preview {
    SignInView()
}
