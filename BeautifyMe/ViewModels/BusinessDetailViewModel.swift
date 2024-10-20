//
//  BusinessDetailViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 19/10/24.
//

import Foundation
import Combine

class BusinessDetailViewModel: ObservableObject{
    @Published var currentBusiness: Business?
    private var cancellables = Set<AnyCancellable>()
    
    init(businessViewModel: ExampleVM) {
        Task { @MainActor in
            businessViewModel.$selectedBusiness
                .sink { [weak self] business in
                    self?.currentBusiness = business
                    print("El negocio seleccionado es: \(String(describing: business))")
                }
                .store(in: &cancellables)
        }
    }
    
    
}
