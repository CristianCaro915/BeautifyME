//
//  ResetPasswordView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @StateObject var viewModel = ResetPasswordViewModel()
    @StateObject var verificationViewModel = VerificationViewModel()
    @State private var email = ""
    @State private var password = ""
    @State var showAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()
            
            // Tittle
            Text("Reset Password,")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(AppColors.black)
            
            // subtittle
            Text("Now you can create new password and confirm it below.")
                .font(.subheadline)
                .foregroundColor(AppColors.darkGrey)
            
            Spacer()
            Spacer()
            // Input for email
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(AppColors.mediumGrey)
                        .padding(10)
                    SecureField("New password", text: $viewModel.newPassword)
                        .padding()
                        .onChange(of: viewModel.newPassword) { _ in
                            verificationViewModel.validatePassword(viewModel.newPassword)
                        }
                        .overlay(
                            VStack{
                                Spacer().frame(height: 70)
                                Group {
                                    if verificationViewModel.passwordError{
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
            
            // Confirm password
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(AppColors.mediumGrey)
                        .padding(10)
                    SecureField("Confirm new password", text: $viewModel.confirmPassword)
                        .padding()
                        .onChange(of: viewModel.confirmPassword) { _ in
                            verificationViewModel.validateNewPassword(newPassword: viewModel.newPassword, confirmPassword: viewModel.confirmPassword)
                        }
                        .overlay(
                            VStack{
                                Spacer().frame(height: 70)
                                Group {
                                    if verificationViewModel.samePasswordError{
                                        Text(verificationViewModel.samePasswordErrorMessage)
                                            .foregroundColor(.red)
                                            .font(.footnote)
                                    }
                                }
                            }
                            
                        )
                }
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.mediumGrey, lineWidth: 1))
            }
            
            Spacer()
            // "New password" Button
            Button(action: {
                // new password action, call API
                if verificationViewModel.resetPasswordHasAnyError{
                    showAlert = true
                } else{
                    print("Send API request for new password")
                }
                
                
                
            }) {
                Text("Confirm New Password")
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.darkBlue)
                    .cornerRadius(20)
            }
            
            Spacer()
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 32)
        .background(AppColors.white.ignoresSafeArea())
        .alert("The fields do not have the correct values", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Please put the correct values.")
                }
        Spacer()
    }
}


#Preview {
    ResetPasswordView()
}
