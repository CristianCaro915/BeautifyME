//
//  LogInView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//
import SwiftUI
import Foundation
import Combine

struct LogInView: View {
    @StateObject private var viewModel = LogInViewModel()
    @StateObject private var verificationViewModel = VerificationViewModel()
    @State private var feedbackMessage: String = ""
    @EnvironmentObject var sessionManager: SessionManager
    @Binding var isOnLoginScreen: Bool
    @State var showAlert = false
    
    // DELETE THIS AFTER TESTING
    @State private var cancellables = Set<AnyCancellable>()
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                
                // Título
                Text("Welcome back,")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.black)
                    .accessibilityLabel("Welcome back message")
                
                // Subtítulo
                Text("Glad to meet you again!, please login to use the app.")
                    .font(.subheadline)
                    .foregroundColor(AppColors.darkGrey)
                    .accessibilityLabel("Login prompt message")
                
                Spacer()
                Spacer()
                
                // Input para email
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(AppColors.mediumGrey)
                            .padding(10)
                            .accessibilityHidden(true)
                        
                        TextField("Email", text: $viewModel.email)
                            .padding()
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .background(AppColors.white)
                            .foregroundColor(AppColors.black)
                            .accessibilityLabel("Email input field")
                            .accessibilityValue(viewModel.email.isEmpty ? "Empty" : viewModel.email)
                            .onChange(of: viewModel.email) { _ in
                                verificationViewModel.validateEmail(viewModel.email)
                            }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.mediumGrey, lineWidth: 1))
                }
                
                // Input para contraseña
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(AppColors.mediumGrey)
                            .padding(10)
                            .accessibilityHidden(true)
                        
                        SecureField("Password", text: $viewModel.password)
                            .padding()
                            .background(AppColors.white)
                            .foregroundColor(AppColors.black)
                            .accessibilityLabel("Password input field")
                            .accessibilityValue(viewModel.password.isEmpty ? "Empty" : "Entered")
                            .onChange(of: viewModel.password) { _ in
                                verificationViewModel.validatePassword(viewModel.password)
                            }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.mediumGrey, lineWidth: 1))
                }
                
                // "Forgot Password?"
                NavigationLink(destination: ForgotPasswordView()) {
                    HStack {
                        Spacer()
                        Text("Forgot password?")
                            .font(.footnote)
                            .foregroundColor(AppColors.darkBlue)
                            .padding(.top, 5)
                            .accessibilityLabel("Forgot password link")
                    }
                }
                
                Spacer()
                
                // Botón "Iniciar sesión"
                Button(action: {
                    if verificationViewModel.logInHasAnyError {
                        showAlert = true
                    } else {
                        //print("AUTH HAPPENING")
                        viewModel.authenticateUser()
                    }
                }) {
                    Text("Log In")
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.darkBlue)
                        .cornerRadius(20)
                        .accessibilityLabel("Log In button")
                }
                
                // Separador
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(AppColors.mediumGrey)
                    Text("or")
                        .foregroundColor(AppColors.darkGrey)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(AppColors.mediumGrey)
                }
                .padding(.vertical)
                .accessibilityHidden(true)
                
                // Botón "Iniciar sesión con Google"
                Button(action: {
                    //print("Sign In with Google")
                    
                }) {
                    HStack {
                        Image(systemName: "globe")
                        Text("Log In with Google")
                    }
                    .foregroundColor(AppColors.darkBlue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.darkBlue, lineWidth: 1))
                    .accessibilityLabel("Log In with Google button")
                }
                
                // Enlace para registrarse
                HStack {
                    Text("Don’t have an account?")
                        .foregroundColor(AppColors.mediumGrey)
                        .padding(.horizontal)
                    
                    Button(action: {
                        isOnLoginScreen = false
                    }) {
                        Text("Join Now")
                            .foregroundColor(AppColors.darkBlue)
                            .fontWeight(.bold)
                    }
                    .accessibilityLabel("Join Now link")
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding(.horizontal, 32)
            .background(AppColors.white.ignoresSafeArea())
            .alert("The fields do not have the correct values", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please put the correct values.")
            }
        }
    }
    
}

/*
Preview {
 LogInView()
}
 */
