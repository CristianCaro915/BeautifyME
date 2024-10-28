//
//  ForgotPasswordView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var verificationViewModel = VerificationViewModel()
    @StateObject private var viewModel = ForgotPasswordViewModel()
    @State private var mail: Bool = true
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                
                // Tittle
                Text("Forgot Password,")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                // subtittle
                Text("Please type your email below and we will give you a OTP code.")
                    .font(.subheadline)
                    .foregroundColor(AppColors.darkGrey)
                
                Spacer()
                Spacer()
                
                // Input for email
                VStack(alignment: .leading) {
                    HStack {
                        if mail{
                            Image(systemName: "envelope.fill")
                                .foregroundColor(AppColors.mediumGrey)
                                .padding(10)
                            TextField("Email Address", text: $viewModel.email)
                                .padding()
                            
                        } else{
                            Image(systemName: "phone.fill")
                                .foregroundColor(AppColors.mediumGrey)
                                .padding(10)
                            TextField("Phone Number", text: $viewModel.phoneNumber)
                                .padding()
                        }
                        
                    }
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.mediumGrey, lineWidth: 1))
                }
                
                // "Use phone number?"
                HStack {
                    Spacer()
                    if mail{
                        Text("Use phone number?")
                            .font(.footnote)
                            .foregroundColor(AppColors.darkBlue)
                            .padding(.top, 5)
                            .onTapGesture {
                                mail.toggle()
                            }
                    } else{
                        Text("Use mail address?")
                            .font(.footnote)
                            .foregroundColor(AppColors.darkBlue)
                            .padding(.top, 5)
                            .onTapGesture {
                                mail.toggle()
                            }
                    }
                }
                Spacer()
                // "Send code button
                NavigationLink(destination: ResetPasswordView()){
                    Button(action: {
                        // new password action, call API
                        if mail{
                            verificationViewModel.validateEmail(viewModel.email)
                        } else{
                            verificationViewModel.validatePhoneNumber(viewModel.phoneNumber)
                        }
                        
                    }) {
                        Text("Send Code")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.darkBlue)
                            .cornerRadius(20)
                    }
                    
                }
                Spacer()
                Spacer()
                Spacer()
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .background(Color(.white).ignoresSafeArea())
    }
}

#Preview {
    ForgotPasswordView()
}
