//
//  VerificationViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 27/10/24.
//

import Foundation

class VerificationViewModel: ObservableObject{
    @Published var emailError: Bool = false
    @Published var passwordError: Bool = false
    @Published var phoneError: Bool = false
    
    // Restrict input fields
    let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_-.@"))
    let maxLength = 25
    let restrictedWords = ["select", "insert", "update", "delete", "drop", "alter", "from", "where", "join"]
    
    
    
    
    func validateEmail(_ email: String){
        // Verify characters
        let filteredEmail = String(email.unicodeScalars.filter { scalar in
            allowedCharacters.contains(scalar) && !isEmoji(Character(scalar)) && scalar != "?"
        }.prefix(maxLength))
        
        // Verify restricted words
        for word in restrictedWords {
            if filteredEmail.lowercased().contains(word) {
                self.emailError = true
            }
        }
        
        // Verify mail format with predicate
        let emailPattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        
        self.emailError = !emailPredicate.evaluate(with: filteredEmail)
    }
    
    func validatePassword(_ password: String){
        // Verify characters
        let filteredPassword = String(password.unicodeScalars.filter { scalar in
            allowedCharacters.contains(scalar) && !isEmoji(Character(scalar)) && scalar != "?"
        }.prefix(maxLength))
        
        // Verify restricted words
        for word in restrictedWords {
            if filteredPassword.lowercased().contains(word) {
                self.passwordError =  true
            }
        }
        
        self.passwordError = !(filteredPassword.count <= maxLength)
    }
    
    func isEmoji(_ character: Character) -> Bool {
        return character.unicodeScalars.contains { scalar in
            (0x1F600...0x1F64F).contains(scalar.value) ||   // Emoji
            (0x1F300...0x1F5FF).contains(scalar.value) ||   // Symbols and vectors
            (0x1F680...0x1F6FF).contains(scalar.value) ||   // Symbols of transport and maps
            (0x1F700...0x1F77F).contains(scalar.value) ||   // Extra symbols
            (0x1F900...0x1F9FF).contains(scalar.value) ||   // Additional symbols
            (0x2600...0x26FF).contains(scalar.value) ||     // Other symbols
            (0x2700...0x27BF).contains(scalar.value)        // Dingbats
        }
    }
    
    func validatePhoneNumber(_ phoneNumber: String){
        // Has 9 digits
        guard phoneNumber.count == 9 else {
            self.phoneError =  true
            return
        }
        // Starts with 3 and all the digits are numbers
        let phoneNumberPattern = "^3\\d{8}$"
        let phoneNumberPredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberPattern)
        
        self.phoneError = !phoneNumberPredicate.evaluate(with: phoneNumber)
    }
}
