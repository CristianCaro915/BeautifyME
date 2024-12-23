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
    
    func getBusiness(by id: Int) -> Result<Business, ErrorManager>{
        var rta = Business(id: 99, name: "", category: "", description: "", images: [""], latitude: "", longitude: "", gallery: [""], logo: "")
        // Check the Id existance
        if !self.businesses.contains(where: { $0.id == id }){
            return .failure(.invalidUserId)
        }
        // get business
        for business in self.businesses{
            if business.id == id{
                rta = business
                break
            }
        }
        return .success(rta)
    }
    
    func createBusiness(id: Int, name: String?, category: String?, description: String?, latitude: String?, longitude: String?, completion: @escaping (Result<Void, ErrorManager>) -> Void){
        // Construir el cuerpo de la solicitud manualmente
             
        guard let name = name, !name.isEmpty else {
            completion(.failure(.invalidUsername))
            return
        }
        
        guard let category = category, !category.isEmpty else {
            completion(.failure(.invalidUsername))
            return
        }
        
        guard let description = description, !description.isEmpty else {
            completion(.failure(.invalidDescription))
            return
        }
        
        let minLatitude: Double = -90
        let maxLatitude: Double = 90
        
        guard let latitude = latitude,
              !latitude.isEmpty,
              let latitudeValue = Double(latitude),
              latitudeValue >= minLatitude,
              latitudeValue <= maxLatitude else {
            completion(.failure(.invalidData))
            return
        }
        
        let minLongitude: Double = -180
        let maxLongitude: Double = 180
        
        guard let longitude = longitude,
              !longitude.isEmpty,
              let longitudeValue = Double(longitude),
              longitudeValue >= minLongitude,
              longitudeValue <= maxLongitude else {
            completion(.failure(.invalidData))
            return
        }
        
        if !self.sessionManager.isAuthenticated{
            //self.sessionManager.userID = 99999 // make it fail
            completion(.failure(.jwtNotFound))
            return
            
        }
        let body: [String: Any] = [
            "data": [
                "id":id,
                "name": name,
                "category": category,
                "description": description,
                "latitude":latitude,
                "longitude": longitude,
                "logo":[
                    "set":[
                        ["id": 33]
                    ]
                ],
                "owner":[
                    "set":[
                        ["id": self.sessionManager.userID]
                    ]
                ]
            ]
        ]
        
        // Convertir el cuerpo de la solicitud a JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            completion(.failure(.serializationError))
            return
        }
        
        // Crear la URL de la API
        guard let url = URL(string: "http://localhost:1337/api/businesses") else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Configurar la solicitud
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        request.httpBody = jsonData
        
        // Realizar la solicitud POST usando Combine
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { response -> Data in
                guard let httpResponse = response.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw ErrorManager.serverError
                }
                return response.data
            }
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .failure:
                    completion(.failure(.serverError))
                case .finished:
                    completion(.success(()))
                }
            }, receiveValue: { data in
                print("Business creado con éxito. Respuesta: \(String(data: data, encoding: .utf8) ?? "Sin respuesta")")
            })
            .store(in: &cancellables)
    }
    
    func deleteBusiness(businessID: Int, completion: @escaping (Result<Void, ErrorManager>) -> Void) {
        guard businesses.contains(where: { $0.id == businessID }) else {
            completion(.failure(.invalidUserId))
            return
        }
        
        guard let url = URL(string: "http://localhost:1337/api/businesses/\(businessID)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(sessionManager.jwtToken ?? "")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { response -> Data in
                guard let httpResponse = response.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw ErrorManager.serverError
                }
                return response.data
            }
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .failure:
                    completion(.failure(.serverError))
                case .finished:
                    completion(.success(()))
                }
            }, receiveValue: { _ in
                print("Business eliminado correctamente")
            })
            .store(in: &cancellables)
    }
    
    func updateBusiness(businessId: Int,
                        newName: String? = nil,
                        newCategory: Date? = nil,
                        newDescription: Date? = nil,
                        newLatitude: String? = nil,
                        newLongitude: String? = nil
    )->AnyPublisher<Void, Error>{
        
        // Endpoint
        guard let url = URL(string: "http://localhost:1337/api/businesses/\(businessId)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        var businessData: [String: Any] = [:]
        
        // Only add the fields that have non-nil values
        if let name = newName {
            businessData["name"] = name
        }
        if let category = newCategory {
            businessData["category"] = category
        }
        if let description = newDescription {
            businessData["description"] = description
        }
        if let latitude = newLatitude {
            businessData["latitude"] = latitude
        }
        if let longitude = newLongitude {
            businessData["longitude"] = longitude
        }
        
        let requestBody: [String: Any] = ["data": businessData]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
            return Fail(error: URLError(.cannotParseResponse)).eraseToAnyPublisher()
        }
        
        // Configure query
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if (self.sessionManager.isAuthenticated){
            request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = httpBody
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                // Valid response
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func updateBusinessRelations(businessId: Int, serviceId: Int, employeeId: Int, invoiceId: Int, commentId:Int){
        let body: [String: Any] = [
            "data": [
                "services": [
                    "set": [
                        ["id": serviceId]
                    ]
                ],
                "employees": [
                    "set": [
                        ["id": employeeId]
                    ]
                ],
                "invoices": [
                    "set": [
                        ["id": invoiceId]
                    ]
                ],
                "comments": [
                    "set": [
                        ["id": commentId]
                    ]
                ]
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error al serializar el cuerpo en JSON")
            return
        }
        
        guard let url = URL(string: "http://localhost:1337/api/businesses/\(businessId)") else {
            print("URL inválida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if (self.sessionManager.isAuthenticated){
            request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = jsonData
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { response -> Data in
                // Verificar el código de estado HTTP
                guard let httpResponse = response.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse) // Error for weird error like 500
                }
                return response.data
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Relaciones actualizadas con éxito.")
                case .failure(let error):
                    print("Error al actualizar las relaciones: \(error.localizedDescription)")
                }
            }, receiveValue: { data in
                // Show server response to updated instance
                print("Respuesta recibida: \(String(data: data, encoding: .utf8) ?? "No se recibió respuesta")")
            })
            .store(in: &cancellables)
    }
    
    func addBusinessServiceRelation(businessId: Int, serviceId: Int){
        let body: [String: Any] = [
            "data": [
                "services": [
                    "connect": [
                        ["id": serviceId]
                    ]
                ]
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error al serializar el cuerpo en JSON")
            return
        }
        
        guard let url = URL(string: "http://localhost:1337/api/businesses/\(businessId)") else {
            print("URL inválida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if (self.sessionManager.isAuthenticated){
            request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = jsonData
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { response -> Data in
                // Verificar el código de estado HTTP
                guard let httpResponse = response.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse) // Error for weird error like 500
                }
                return response.data
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Relaciones actualizadas con éxito.")
                case .failure(let error):
                    print("Error al actualizar las relaciones: \(error.localizedDescription)")
                }
            }, receiveValue: { data in
                // Show server response to updated instance
                print("Respuesta recibida: \(String(data: data, encoding: .utf8) ?? "No se recibió respuesta")")
            })
            .store(in: &cancellables)
    }
    
    func addBusinessEmployeeRelation(businessId: Int, employeeId: Int){
        let body: [String: Any] = [
            "data": [
                "employees": [
                    "connect": [
                        ["id": employeeId]
                    ]
                ]
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error al serializar el cuerpo en JSON")
            return
        }
        
        guard let url = URL(string: "http://localhost:1337/api/businesses/\(businessId)") else {
            print("URL inválida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if (self.sessionManager.isAuthenticated){
            request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = jsonData
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { response -> Data in
                // Verificar el código de estado HTTP
                guard let httpResponse = response.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse) // Error for weird error like 500
                }
                return response.data
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Relaciones actualizadas con éxito.")
                case .failure(let error):
                    print("Error al actualizar las relaciones: \(error.localizedDescription)")
                }
            }, receiveValue: { data in
                // Show server response to updated instance
                print("Respuesta recibida: \(String(data: data, encoding: .utf8) ?? "No se recibió respuesta")")
            })
            .store(in: &cancellables)
    }
    
    func addBusinessInvoiceRelation(businessId: Int, invoiceId: Int){
        let body: [String: Any] = [
            "data": [
                "invoices": [
                    "connect": [
                        ["id": invoiceId]
                    ]
                ]
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error al serializar el cuerpo en JSON")
            return
        }
        
        guard let url = URL(string: "http://localhost:1337/api/businesses/\(businessId)") else {
            print("URL inválida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if (self.sessionManager.isAuthenticated){
            request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = jsonData
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { response -> Data in
                // Verificar el código de estado HTTP
                guard let httpResponse = response.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse) // Error for weird error like 500
                }
                return response.data
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Relaciones actualizadas con éxito.")
                case .failure(let error):
                    print("Error al actualizar las relaciones: \(error.localizedDescription)")
                }
            }, receiveValue: { data in
                // Show server response to updated instance
                print("Respuesta recibida: \(String(data: data, encoding: .utf8) ?? "No se recibió respuesta")")
            })
            .store(in: &cancellables)
    }
    
    func addBusinessCommentRelation(businessId: Int, commentId: Int){
        let body: [String: Any] = [
            "data": [
                "comments": [
                    "connect": [
                        ["id": commentId]
                    ]
                ]
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error al serializar el cuerpo en JSON")
            return
        }
        
        guard let url = URL(string: "http://localhost:1337/api/businesses/\(businessId)") else {
            print("URL inválida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if (self.sessionManager.isAuthenticated){
            request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = jsonData
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { response -> Data in
                // Verificar el código de estado HTTP
                guard let httpResponse = response.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse) // Error for weird error like 500
                }
                return response.data
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Relaciones actualizadas con éxito.")
                case .failure(let error):
                    print("Error al actualizar las relaciones: \(error.localizedDescription)")
                }
            }, receiveValue: { data in
                // Show server response to updated instance
                print("Respuesta recibida: \(String(data: data, encoding: .utf8) ?? "No se recibió respuesta")")
            })
            .store(in: &cancellables)
    }
}
