//
//  InvoiceViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 25/10/24.
//

import Foundation
import Combine

class InvoiceViewModel: ObservableObject{
    private var sessionManager: SessionManager
    private var dataViewModel: DataViewModel
    private var cancellables = Set<AnyCancellable>()
    
    @Published var invoices: [Invoice] = []
    
    init(sessionManager: SessionManager = SessionManager.shared, dataViewModel: DataViewModel = DataViewModel.shared) {
        self.sessionManager = sessionManager
        self.dataViewModel = dataViewModel
        
        updateDataFromAPI()
    }
    
    func updateDataFromAPI(){
        self.dataViewModel.$invoices
            .sink { [weak self] invoices in
                self?.invoices = invoices
            }
            .store(in: &cancellables)
    }
    func getInvoice(id: Int){
        
    }
    
    func createInvoice(){
        
    }
    func deleteInvoice(id: Int){
        
    }
}
