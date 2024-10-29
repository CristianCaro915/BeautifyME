//
//  ForgotPasswordViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 27/10/24.
//

import Foundation
import Combine

class ForgotPasswordViewModel: ObservableObject{
    @Published var shouldNavigate: Bool = false
    private var dataViewModel: DataViewModel
    private var cancellables = Set<AnyCancellable>()
    
    @Published var email: String =  ""
    @Published var phoneNumber: String = ""
    @Published var users: [User] = []
    @Published var emailExists: Bool = false
    @Published var phoneNumberExists: Bool = false
    
    init(dataViewModel: DataViewModel = DataViewModel.shared) {
        self.dataViewModel = dataViewModel
        
        updateDataFromAPI()
    }
    
    func updateDataFromAPI(){
        self.dataViewModel.$users
            .sink { [weak self] users in
                self?.users = users
            }
            .store(in: &cancellables)
    }
    
    func checkEmail(){
        for user in self.users{
            if user.email == self.email{
                self.emailExists = true
                break
            }
        }
    }
    
    func checkPhoneNumber(){
        for user in self.users{
            if user.phone == self.phoneNumber{
                self.phoneNumberExists = true
                break
            }
        }
    }
}
