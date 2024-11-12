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
    
    func createBusiness(id:Int, name: String, category: String, description:String, latitude: String, longitude:String){
        // Construir el cuerpo de la solicitud manualmente
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
            print("Error al serializar el cuerpo en JSON")
            return
        }
        
        // Crear la URL de la API
        guard let url = URL(string: "http://localhost:1337/api/businesses") else {
            print("URL inválida")
            return
        }
        
        // Configurar la solicitud
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        // Realizar la solicitud POST usando Combine
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { response -> Data in
                // Verificar el código de estado HTTP
                guard let httpResponse = response.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return response.data
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Business creado con éxito.")
                case .failure(let error):
                    print("Error al crear el business: \(error.localizedDescription)")
                }
            }, receiveValue: { data in
                // Imprimir la respuesta cruda en caso de necesitarla
                print("Respuesta del servidor: \(String(data: data, encoding: .utf8) ?? "No se recibió respuesta")")
            })
            .store(in: &cancellables)
    }
    
    func deleteBusiness(businessID: Int) {
        //Check the relations and ID existance
        if !self.businesses.contains(where: { $0.id == businessID }){
            print("The reservation with the given id was not found")
            return
        }
        
        
        guard let url = URL(string: "http://localhost:1337/api/business/\(businessID)") else {
            print("URL inválida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data in
                // Comprobar si la respuesta es null
                if data.isEmpty {
                    throw NSError(domain: "APIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No se recibió respuesta del servidor."])
                }
                return data
            }
        //.decode(type: [String: Service].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Business borrado con éxito.")
                case .failure(let error):
                    print("Error al borrar el business: \(error)")
                }
            }, receiveValue: { response in
                // Manejo de la respuesta si es necesario
                print("Respuesta del servidor: \(response)")
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
        request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
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
        request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
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
        request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
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
        request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
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
        request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
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
        request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
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
