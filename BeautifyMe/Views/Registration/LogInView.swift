//
//  LogInView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//
import SwiftUI

struct LogInView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()
            
            // Tittle
            Text("Welcome back,")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            // subtittle
            Text("Glad to meet you again!, please login to use the app.")
                .font(.subheadline)
                .foregroundColor(AppColors.darkGrey)
            
            Spacer()
            Spacer()
            // Input for email
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(AppColors.mediumGrey)
                        .padding(10)
                    TextField("Email", text: $email)
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
            HStack {
                Spacer()
                Text("Forgot password?")
                    .font(.footnote)
                    .foregroundColor(AppColors.darkBlue)
                    .padding(.top, 5)
            }
            Spacer()
            // "Sign In" Button
            Button(action: {
                // Login action, call API
            }) {
                Text("Log In")
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
                    Text("Log In with Google")
                }
                .foregroundColor(AppColors.darkBlue)
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.darkBlue, lineWidth: 1))
            }
            
            // Link to register
            HStack {
                Text("Don’t have an account?")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                Button(action: {
                    // action to move to sigIn page
                }) {
                    Text("Join Now")
                        .foregroundColor(AppColors.darkBlue)
                        .fontWeight(.bold)
                }
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .background(Color(.white).ignoresSafeArea())
    }
}

#Preview {
    LogInView()
}
