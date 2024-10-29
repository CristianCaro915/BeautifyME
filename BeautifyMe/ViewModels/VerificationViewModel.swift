//
//  VerificationViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 27/10/24.
//

import Foundation

class VerificationViewModel: ObservableObject{
    @Published var nameError: Bool = false
    @Published var emailError: Bool = false
    @Published var passwordError: Bool = false
    @Published var phoneError: Bool = false
    @Published var samePasswordError: Bool = false
    
    @Published var mailErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var phoneErrorMessage: String = ""
    @Published var nameErrorMessage: String = ""
    @Published var samePasswordErrorMessage: String = ""
    
    // Restrict input fields
    let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_-.@"))
    let restrictedWords = ["select", "insert", "update", "delete", "drop", "alter", "from", "where", "join"]
    
    //delete
    var hasAnyError: Bool {
            return emailError || passwordError || phoneError
    }
    
    
    
    func validateEmail(_ email: String){
        self.emailError = false
        if email == ""{
            self.mailErrorMessage = "Email cannot be empty"
            self.emailError = true
        }
        // Verify characters
        let filteredEmail = String(email.unicodeScalars.filter { scalar in
            allowedCharacters.contains(scalar) && scalar != "?"
        }.prefix(20))
        
        // Verify restricted words
        for word in restrictedWords {
            if filteredEmail.lowercased().contains(word) {
                self.emailError = true
                self.mailErrorMessage = "There is a restricted word in the email"
                return
            }
        }
        
        // Verify mail format with predicate
        let emailPattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        self.emailError = !emailPredicate.evaluate(with: filteredEmail)
        self.mailErrorMessage = "There is an error in the email format"
    }
    
    func validatePassword(_ password: String){
        self.passwordError = false
        if password == ""{
            self.passwordErrorMessage = "Password cannot be empty"
            self.passwordError = true
        }
        // Verify characters
        let filteredPassword = String(password.unicodeScalars.filter { scalar in
            allowedCharacters.contains(scalar) && scalar != "?"
        }.prefix(8))
        
        // Verify restricted words
        for word in restrictedWords {
            if filteredPassword.lowercased().contains(word) {
                self.passwordErrorMessage = "There is a restricted word in the password"
                self.passwordError =  true
                return
            }
        }
        // Verify password format with predicate
        let passwordRegex = "^(?=.*[A-Z])(?=.*\\d)(?=.*[a-z])[A-Za-z\\d]{8}$"
        let regex = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        self.passwordErrorMessage = "Invalid password format"
        self.passwordError = !regex.evaluate(with: password)
        
    }
    
    func validatePhoneNumber(_ phoneNumber: String){
        self.phoneError = false
        if phoneNumber == ""{
            self.phoneErrorMessage = "Phone Number cannot be empty"
            self.phoneError = true
        }
        // Has 9 digits
        guard phoneNumber.count == 10 else {
            self.phoneErrorMessage = "The phone number must have 10 digits"
            self.phoneError =  true
            return
        }
        // Starts with 3 and all the digits are numbers
        let phoneNumberPattern = "^3\\d{9}$"
        let phoneNumberPredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberPattern)
        self.phoneErrorMessage = "Invalid phone number format"
        self.phoneError = !phoneNumberPredicate.evaluate(with: phoneNumber)
    }
    
    func validateNewPassword(newPassword: String, confirmPassword: String){
        self.samePasswordError = false
        if newPassword != confirmPassword{
            self.samePasswordErrorMessage = "The passwords are not the same"
            self.samePasswordError = true
        }
    }
    func validateName(_ name: String) {
        self.nameError = false
        if name == "" {
            self.nameErrorMessage = "Username cannot be blank"
            self.nameError = true
        } else if name.count < 3 {
            self.nameErrorMessage = "Username must be at least 3 characters"
            self.nameError = true
        } else if name.count > 15{
            self.nameErrorMessage = "Username cannot exceed 15 characters"
            self.nameError = true
        }
    }
}
