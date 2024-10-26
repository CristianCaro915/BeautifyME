//
//  BusinessViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 25/10/24.
//

import Foundation
import Combine

class BusinessViewModel: ObservableObject{
    private var sessionManager: SessionManager
    private var dataViewModel: DataViewModel
    private var cancellables = Set<AnyCancellable>()
    
    @Published var businesses: [Business] = []
    
    init(sessionManager: SessionManager = SessionManager.shared, dataViewModel: DataViewModel = DataViewModel.shared) {
        self.sessionManager = sessionManager
        self.dataViewModel = dataViewModel
        
        updateDataFromAPI()
    }
    
    func updateDataFromAPI(){
        self.dataViewModel.$businesses
            .sink { [weak self] businesses in
                self?.businesses = businesses
            }
            .store(in: &cancellables)
    }
    
    func getBusiness(id: Int){
        
    }
    
    func createBusiness(business: Business){
        
    }
    func deleteBusiness(id: Int){
        
    }
}
