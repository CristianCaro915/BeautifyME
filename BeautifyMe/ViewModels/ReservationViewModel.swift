//
//  ReservationViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 25/10/24.
//

import Foundation
import Combine

class ReservationViewModel: ObservableObject{
    private var sessionManager: SessionManager
    private var dataViewModel: DataViewModel
    private var cancellables = Set<AnyCancellable>()
    
    @Published var reservations: [Reservation] = []
    
    init(sessionManager: SessionManager = SessionManager.shared, dataViewModel: DataViewModel = DataViewModel.shared) {
        self.sessionManager = sessionManager
        self.dataViewModel = dataViewModel
        
        updateDataFromAPI()
    }
    
    func updateDataFromAPI(){
        self.dataViewModel.$reservations
            .sink { [weak self] reservations in
                self?.reservations = reservations
            }
            .store(in: &cancellables)
    }
    func getReservation(id: Int){
        
    }
    
    func createReservation(){
        
    }
    func deleteReservation(id: Int){
        
    }
}
