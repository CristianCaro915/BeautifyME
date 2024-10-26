//
//  LogInView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//
import SwiftUI

struct LogInView: View {
    @StateObject private var viewModel = LogInViewModel()
    @StateObject private var commentViewModel = CommentViewModel()
    @State private var feedbackMessage: String = ""
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        NavigationStack{
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
                        TextField("Email", text: $viewModel.email)
                            .padding()
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .background(Color.white)
                            .foregroundColor(.black)
                    }
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.mediumGrey, lineWidth: 1))
                }
                
                // Input for password
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(AppColors.mediumGrey)
                            .padding(10)
                        SecureField("Password", text: $viewModel.password)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                    }
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.mediumGrey, lineWidth: 1))
                }
                
                // "Forgot Password?"
                NavigationLink(destination: ForgotPasswordView()){
                    HStack {
                        Spacer()
                        Text("Forgot password?")
                            .font(.footnote)
                            .foregroundColor(AppColors.darkBlue)
                            .padding(.top, 5)
                    }
                }
                
                // validation
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
                // "Sign In" Button
                Button(action: {
                    // Login action, call API
                    viewModel.authenticateUser()
                    sessionManager.isAuthenticated = true
                }) {
                    Text("Log In")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.darkBlue)
                        .cornerRadius(20)
                }
                // validation post logging
                if viewModel.isAuthenticated {
                    Text("Logged in successfully!")
                        .foregroundColor(.green)
                        .padding()
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
                    print("comment se va a borrar")
                    let newComment = Comment(id: 6, description: "building my comment", rating: 1, commenterName: "", commenterImage: "")
                    commentViewModel.createComment(comment: newComment,businessId: 1) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let createdComment):
                                feedbackMessage = "Comentario creado con éxito: \(createdComment.description)"
                            case .failure(let error):
                                feedbackMessage = "Error: \(error.localizedDescription)"
                            }
                        }
                    }
                    print("comment se fue borrado")
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
                    NavigationLink(destination: SignInView()){
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
}

#Preview {
    LogInView()
}
