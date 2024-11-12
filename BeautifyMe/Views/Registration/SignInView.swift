//
//  SignInView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//

import SwiftUI

struct SignInView: View {
    @StateObject var viewModel = SignInViewModel()
    @StateObject var verificationViewModel = VerificationViewModel()
    @State var showAlert = false
    @Binding var isOnLoginScreen: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()
            
            // Título
            Text("Create an account,")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(AppColors.black)
                .accessibilityLabel("Create an account title")

            // Subtítulo
            Text("Please type full information below and we can create your account.")
                .font(.subheadline)
                .foregroundColor(AppColors.darkGrey)
                .accessibilityLabel("Subtitle: Please type full information below and we can create your account.")

            // Input para nombre
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(AppColors.mediumGrey)
                        .padding(10)
                        .accessibilityLabel("Icon for name input")
                    TextField("Name", text: $viewModel.name)
                        .padding()
                        .background(AppColors.white)
                        .foregroundColor(AppColors.black)
                        .accessibilityLabel("Name input field")
                        .accessibilityValue(viewModel.name.isEmpty ? "Empty" : viewModel.name)
                        .onChange(of: viewModel.name) { _ in
                            verificationViewModel.validateName(viewModel.name)
                        }
                        .overlay(
                            VStack {
                                Spacer().frame(height: 70)
                                Group {
                                    if verificationViewModel.nameError {
                                        Text(verificationViewModel.nameErrorMessage)
                                            .foregroundColor(.red)
                                            .font(.footnote)
                                    }
                                }
                            }
                        )
                }
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.mediumGrey, lineWidth: 1))
            }
            
            // Input para correo electrónico
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(AppColors.mediumGrey)
                        .padding(10)
                        .accessibilityLabel("Icon for email input")
                    TextField("Email address", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(AppColors.white)
                        .foregroundColor(AppColors.black)
                        .accessibilityLabel("Email input field")
                        .accessibilityValue(viewModel.email.isEmpty ? "Empty" : viewModel.email)
                        .onChange(of: viewModel.email) { _ in
                            verificationViewModel.validateEmail(viewModel.email)
                        }
                        .overlay(
                            VStack {
                                Spacer().frame(height: 70)
                                Group {
                                    if verificationViewModel.emailError {
                                        Text(verificationViewModel.mailErrorMessage)
                                            .foregroundColor(.red)
                                            .font(.footnote)
                                    }
                                }
                            }
                        )
                }
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.mediumGrey, lineWidth: 1))
            }

            // Input para número de móvil
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(AppColors.mediumGrey)
                        .padding(10)
                        .accessibilityLabel("Icon for phone number input")
                    TextField("Phone Number", text: $viewModel.phone)
                        .padding()
                        .accessibilityLabel("Phone number input field")
                        .accessibilityValue(viewModel.phone.isEmpty ? "Empty" : viewModel.phone)
                        .onChange(of: viewModel.phone) { _ in
                            verificationViewModel.validatePhoneNumber(viewModel.phone)
                        }
                        .overlay(
                            VStack {
                                Spacer().frame(height: 70)
                                Group {
                                    if verificationViewModel.phoneError {
                                        Text(verificationViewModel.phoneErrorMessage)
                                            .foregroundColor(.red)
                                            .font(.footnote)
                                    }
                                }
                            }
                        )
                }
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.mediumGrey, lineWidth: 1))
            }

            // Input para contraseña
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(AppColors.mediumGrey)
                        .padding(10)
                        .accessibilityLabel("Icon for password input")
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .accessibilityLabel("Password input field")
                        .onChange(of: viewModel.password) { _ in
                            verificationViewModel.validatePassword(viewModel.password)
                        }
                        .overlay(
                            VStack {
                                Spacer().frame(height: 70)
                                Group {
                                    if verificationViewModel.passwordError {
                                        Text(verificationViewModel.passwordErrorMessage)
                                            .foregroundColor(.red)
                                            .font(.footnote)
                                    }
                                }
                            }
                        )
                }
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.mediumGrey, lineWidth: 1))
            }

            // "Forgot Password?"
            VStack {
                Text("By signing in you agree to our")
                    .foregroundColor(AppColors.mediumGrey)
                    .font(.footnote)
                    .accessibilityLabel("Agreement notice")
                Button(action: {
                    // acción para mover a la página de inicio de sesión
                }) {
                    Text("Term of use and privacy notice")
                        .foregroundColor(AppColors.darkBlue)
                        .fontWeight(.bold)
                        .font(.footnote)
                        .accessibilityLabel("Terms of use and privacy notice link")
                }
            }
            .padding(.horizontal, 60)

            // Botón "Sign In"
            Button(action: {
                // Acción de inicio de sesión, llamar API
                if verificationViewModel.singInHasAnyError {
                    showAlert = true
                } else{
                    viewModel.createUser()
                }
            }) {
                Text("Join Now")
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.darkBlue)
                    .cornerRadius(20)
                    .accessibilityLabel("Join Now button")
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

            // Botón "Sign In with Google"
            Button(action: {
                // acción para inicio de sesión con Google
            }) {
                HStack {
                    Image(systemName: "globe") // cambiar al símbolo de Google
                    Text("Join with Google")
                }
                .foregroundColor(AppColors.darkBlue)
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.darkBlue, lineWidth: 1))
                .accessibilityLabel("Join with Google button")
            }

            // Enlace para registrarse
            HStack {
                Text("Already have an account?")
                    .foregroundColor(AppColors.mediumGrey)
                    .font(.footnote)
                    .accessibilityLabel("Already have an account text")
                Button(action: {
                    // acción para mover a la página de inicio de sesión
                    isOnLoginScreen = true
                }) {
                    Text("Log In")
                        .foregroundColor(AppColors.darkBlue)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .accessibilityLabel("Log In button")
                }
            }
            .padding(.horizontal, 30)

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

/*
#Preview {
    SignInView()
}
 */
