//
//  BusinessDetailViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 19/10/24.
//

import Foundation
import Combine

class BusinessDetailViewModel: ObservableObject{
    private var sessionManager: SessionManager
    private var dataViewModel: DataViewModel
    
    @Published var currentBusiness: Business?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var serviceIDs: [Int] = []
    @Published var employeeIDs: [Int] = []
    @Published var commentIDs: [Int] = []
    
    @Published var user: User?
    
    @Published var servicesBusiness: [Service] = []
    @Published var employeesBusiness: [Employee] = []
    @Published var commentsBusiness: [Comment] = []
    
    @Published var users: [User] = []
    @Published var services: [Service] = []
    @Published var employees: [Employee] = []
    @Published var comments: [Comment] = []
    
    init(sessionManager: SessionManager = SessionManager.shared, dataViewModel: DataViewModel = DataViewModel.shared) {
        self.sessionManager = sessionManager
        self.dataViewModel = dataViewModel
        
        updateCurrentBusiness()
        getDataFromAPI()
        fetchIdsFromAPI()
    }
    
    
    func updateCurrentBusiness() {
        self.sessionManager.$businessSelected
            .sink { [weak self] business in
                self?.currentBusiness = business 
            }
            .store(in: &cancellables)
        
        self.sessionManager.$users
            .sink { [weak self] users in
                self?.users = users
            }
            .store(in: &cancellables)
    }
    
    func getDataFromAPI(){
        self.dataViewModel.$services
            .sink { [weak self] services in
                self?.services = services
            }
            .store(in: &cancellables)
        
        self.dataViewModel.$comments
            .sink { [weak self] comments in
                self?.comments = comments
            }
            .store(in: &cancellables)
        
        self.dataViewModel.$employees
            .sink { [weak self] employees in
                self?.employees = employees
            }
            .store(in: &cancellables)
        
    }
    
    
    func fetchIdsFromAPI() {
        guard let currentBusiness = currentBusiness,
              let url = URL(string: "http://localhost:1337/api/businesses/\(currentBusiness.id)?populate[services][fields][0]=id&populate[employees][fields][0]=id&populate[comments][fields][0]=id") else {
            print("URL no válida")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .tryMap { data in
                // Intentar convertir los datos en un JSON válido
                guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let dataDict = jsonObject["data"] as? [String: Any],
                      let attributes = dataDict["attributes"] as? [String: Any] else {
                    throw URLError(.badServerResponse)
                }
                
                // Extraer los IDs de los servicios, empleados y comentarios
                let serviceIDs = (attributes["services"] as? [String: Any])?["data"] as? [[String: Any]] ?? []
                let employeeIDs = (attributes["employees"] as? [String: Any])?["data"] as? [[String: Any]] ?? []
                let commentIDs = (attributes["comments"] as? [String: Any])?["data"] as? [[String: Any]] ?? []
                
                return (
                    serviceIDs.compactMap { $0["id"] as? Int },
                    employeeIDs.compactMap { $0["id"] as? Int },
                    commentIDs.compactMap { $0["id"] as? Int }
                )
            }
            .receive(on: DispatchQueue.main) // Actualizar en el hilo principal
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error al obtener los datos: \(error)")
                }
            }, receiveValue: { [weak self] serviceIDs, employeeIDs, commentIDs in
                self?.serviceIDs = serviceIDs
                self?.employeeIDs = employeeIDs
                self?.commentIDs = commentIDs
                // call to update real lists of items
                self?.setBusinessRelations()
                
            })
            .store(in: &cancellables)
    }
    
    func setBusinessRelations(){
        for service in self.services{
            if self.serviceIDs.contains(service.id){
                self.servicesBusiness.append(service)
            }
        }
        for employee in self.employees{
            if self.employeeIDs.contains(employee.id){
                self.employeesBusiness.append(employee)
            }
        }
        for comment in self.comments{
            if self.commentIDs.contains(comment.id){
                self.commentsBusiness.append(comment)
            }
        }
        
        /*
        print("Business services")
        print(self.servicesBusiness)
        print("Business employees")
        print(self.employeesBusiness)
        print("Business comments")
        print(self.commentsBusiness)
        */
    }
}
