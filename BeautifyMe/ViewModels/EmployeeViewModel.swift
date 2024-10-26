//
//  EmployeeViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 25/10/24.
//

import Foundation
import Combine

class EmployeeViewModel: ObservableObject{
    private var sessionManager: SessionManager
    private var dataViewModel: DataViewModel
    private var cancellables = Set<AnyCancellable>()
    
    @Published var employees: [Employee] = []
    
    init(sessionManager: SessionManager = SessionManager.shared, dataViewModel: DataViewModel = DataViewModel.shared) {
        self.sessionManager = sessionManager
        self.dataViewModel = dataViewModel
        
        updateDataFromAPI()
    }
    
    func updateDataFromAPI(){
        self.dataViewModel.$employees
            .sink { [weak self] employees in
                self?.employees = employees
            }
            .store(in: &cancellables)
    }
    func getEmployee(id: Int){
        
    }
    
    func createEmployee(business: Business){
        
    }
    func deleteEmployee(id: Int){
        
    }
}
