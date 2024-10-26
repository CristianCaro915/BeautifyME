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
    @Published var currentBusiness: Business?
    
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
    
    func getBusiness(by id: Int) -> Business{
        var rta = Business(id: 99, name: "", category: "", description: "", images: [""], latitude: "", longitude: "", gallery: [""], logo: "")
        // Check the Id existance
        if !self.businesses.contains(where: { $0.id == id }){
            print("The business with the given id was not found")
            return rta
        }
        // get business
        for business in self.businesses{
            if business.id == id{
                rta = business
                break
            }
        }
        return rta
    }
    
    func createBusiness(business: Business){
        
    }
    
    func deleteBusiness(businessID: Int) {
        //Check the relations and ID existance
        if !self.businesses.contains(where: { $0.id == businessID }){
            print("The business with the given id was not found")
            return
        }
        
        
        guard let url = URL(string: "http://localhost:1337/api/businesses/\(businessID)") else {
            print("URL inválida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data in
                    // Check if it is null
                    if data.isEmpty {
                        throw NSError(domain: "APIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No se recibió respuesta del servidor."])
                    }
                    return data
                }
            .decode(type: [String: Business].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Business borrado con éxito.")
                case .failure(let error):
                    print("Error al borrar el business: \(error)")
                }
            }, receiveValue: { response in
                // Manage the response if neede
                print("Respuesta del servidor: \(response)")
            })
            .store(in: &cancellables)
    }
}
