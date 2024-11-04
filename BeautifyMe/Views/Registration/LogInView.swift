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
    @StateObject private var commentViewModel = CommentViewModel()
    @State private var feedbackMessage: String = ""
    @EnvironmentObject var sessionManager: SessionManager
    @Binding var isOnLoginScreen: Bool
    @State var showAlert = false
    
    // DELETE THIS AFTER TESTING
    @State private var cancellables = Set<AnyCancellable>()
    
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
                            .onChange(of: viewModel.email) { _ in
                                verificationViewModel.validateEmail(viewModel.email)
                            }
                            .overlay(
                                VStack{
                                    Spacer().frame(height: 70)
                                    Group {
                                        if verificationViewModel.emailError{
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
                //Spacer().frame(height: 8)
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
                            .onChange(of: viewModel.password) { _ in
                                verificationViewModel.validatePassword(viewModel.password)
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
                Spacer().frame(height: 3)
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
                    if verificationViewModel.logInHasAnyError{
                        showAlert = true
                    } else{
                        viewModel.authenticateUser()
                    }
                    

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
                    
                    
                    // TRYING SOMETHING HERE
                    
                    print("comment se va a borrar")
                     /*  ADD RELATIONS TO THE INSTANCE OF A CLASS
                    let commentId = 15  // ID del comentario (por ejemplo)
                    let userId = 5    // ID del usuario (por ejemplo)
                    let businessId = 1 // ID business
                    
                    cancellable = commentViewModel.addCommentRelations(commentId: commentId, userId: userId, businessId: businessId)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .failure(let error):
                                print(error.localizedDescription)
                                print("Failed")
                            case .finished:
                                break
                            }
                        }, receiveValue: { success in
                            print("Success")
                        })
                      */
                    
                    
                    //commentViewModel.deleteComment(commentId: 10)
                    
                    
                    /* CREATE COMMENT
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
                     */
                    
                    
                    /* UPDATE THE INSTANCE OF A CLASS
                    commentViewModel.updateComment(commentId: 15, newDescription: "Comentario actualizado", newRanking: 4)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .finished:
                                print("Comentario actualizado con éxito.")
                            case .failure(let error):
                                print("Error al actualizar el comentario: \(error)")
                            }
                        }, receiveValue: {
                            // No se espera valor de retorno
                        })
                        .store(in: &cancellables)
                     */
                    
                     /* UPDATE RELATIONS
                    commentViewModel.updateCommentRelations(commentId: 15, userId: 5, businessId: 1)
                     */
                    
                    
                    
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
                    Button(action: {
                        // action to move to SinIn page
                        isOnLoginScreen = false
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
