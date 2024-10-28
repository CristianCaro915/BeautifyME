//
//  SignInViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 19/10/24.
//

import Foundation

class SignInViewModel: ObservableObject{
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var password: String =  ""
    @Published var role: Bool = false
    
    func createUser(){
        
    }
}
