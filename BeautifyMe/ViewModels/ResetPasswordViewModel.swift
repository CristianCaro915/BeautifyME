//
//  ResetPasswordViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 27/10/24.
//

import Foundation
import Combine

class ResetPasswordViewModel: ObservableObject{
    private var sessionManager: SessionManager
    private var cancellables = Set<AnyCancellable>()
    
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var similarityPasswordError: Bool = false
    @Published var auxUser: User = User(id: 101, username: "Error", email: "", phone: "", role: "", imageURL: "")
    
    init(sessionManager: SessionManager = SessionManager.shared) {
        self.sessionManager = sessionManager
        
        updateDataFromAPI()
    }
    
    func updateDataFromAPI(){
        self.sessionManager.$auxUser
            .sink { [weak self] auxUser in
                self?.auxUser = auxUser
            }
            .store(in: &cancellables)
    }
    
    func updateUser(){
        // PUT query
    }
}
