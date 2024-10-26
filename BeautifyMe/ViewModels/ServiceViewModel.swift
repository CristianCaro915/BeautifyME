//
//  ServiceViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 25/10/24.
//

import Foundation
import Combine

class ServiceViewModel: ObservableObject{
    private var sessionManager: SessionManager
    private var dataViewModel: DataViewModel
    private var cancellables = Set<AnyCancellable>()
    
    @Published var services: [Service] = []
    
    init(sessionManager: SessionManager = SessionManager.shared, dataViewModel: DataViewModel = DataViewModel.shared) {
        self.sessionManager = sessionManager
        self.dataViewModel = dataViewModel
        
        updateDataFromAPI()
    }
    
    func updateDataFromAPI(){
        self.dataViewModel.$services
            .sink { [weak self] services in
                self?.services = services
            }
            .store(in: &cancellables)
    }
    
    func getService(id: Int){
        
    }
    
    func createService(business: Business){
        
    }
    func deleteService(id: Int){
        
    }
}
