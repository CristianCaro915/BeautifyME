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
    
    func getService(id: Int) -> Service{
        var rta = Service(id: 99, name: "error", description: "error", price: 2, category: "error", icon: "")
        // check id existance
        if !self.services.contains(where: { $0.id == id }){
            print("The service with the given id was not found")
            return rta
        }
        // get service
        for service in self.services{
            if service.id == id{
                rta = service
                break
            }
        }
        return rta
    }
    
    func createService(id: Int, description: String, price: Int, name: String, category: String, iconURL: String){
        // Construir el cuerpo de la solicitud manualmente
        let body: [String: Any] = [
            "data": [
                "id": id,
                "description": description,
                "price": price,
                "name": name,
                "category": category,
                "icon": [
                    "data": [
                        "attributes": [
                            "url": iconURL
                        ]
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
        guard let url = URL(string: "http://localhost:1337/api/services") else {
            print("URL inválida")
            return
        }
        
        // Configurar la solicitud
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
                    print("Service creado con éxito.")
                case .failure(let error):
                    print("Error al crear el service: \(error.localizedDescription)")
                }
            }, receiveValue: { data in
                // Imprimir la respuesta cruda en caso de necesitarla
                print("Respuesta del servidor: \(String(data: data, encoding: .utf8) ?? "No se recibió respuesta")")
            })
            .store(in: &cancellables)
    }
    func addBusinessServiceRelation(serviceId: Int, businessId: Int) -> AnyPublisher<Bool, Error>{
        // Endpoint
        guard let url = URL(string: "http://localhost:1337/api/services/\(serviceId)") else {
            fatalError("URL no válida")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "data": [
                "businesses":[
                    "connect":[
                        ["id": businessId]
                    ]
                ]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Bool in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return true // good
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    func addEmployeeServiceRelation(serviceId: Int, employeeId: Int) -> AnyPublisher<Bool, Error>{
        // Endpoint
        guard let url = URL(string: "http://localhost:1337/api/services/\(serviceId)") else {
            fatalError("URL no válida")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "data": [
                "employees":[
                    "connect":[
                        ["id": employeeId]
                    ]
                ]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Bool in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return true // good
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    func deleteService(serviceId: Int){
        //Check the relations and ID existance
        if !self.services.contains(where: { $0.id == serviceId }){
            print("The service with the given id was not found")
            return
        }
        
        
        guard let url = URL(string: "http://localhost:1337/api/services/\(serviceId)") else {
            print("URL inválida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
                    print("Service borrado con éxito.")
                case .failure(let error):
                    print("Error al borrar el service: \(error)")
                }
            }, receiveValue: { response in
                // Manejo de la respuesta si es necesario
                print("Respuesta del servidor: \(response)")
            })
            .store(in: &cancellables)
    }
    func updateService(serviceId: Int,
                       newDescription:String? = nil,
                       newPrice: Int? = nil,
                       newName: String? = nil,
                       newCategory: String? = nil,
                       newUrl: String? = nil
    )->AnyPublisher<Void, Error>{
        
        // Endpoint
        guard let url = URL(string: "http://localhost:1337/api/services/\(serviceId)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var iconData: [String: Any] = [:]
        var icon: [String: Any] = [:]
        var serviceData: [String: Any] = [:]
        
        // Only add the fields that have non-nil values
        if let name = newName {
            serviceData["name"] = name
        }
        if let price = newPrice {
            serviceData["price"] = price
        }
        if let description = newDescription {
            serviceData["description"] = description
        }
        if let category = newCategory {
            serviceData["category"] = category
        }
        if let url = newUrl {
            icon["url"] = url
            iconData = ["data": icon]
            serviceData["icon"] = iconData
        }
        
        let requestBody: [String: Any] = ["data": serviceData]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
            return Fail(error: URLError(.cannotParseResponse)).eraseToAnyPublisher()
        }
        
        // Configure query
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
    func updateServiceRelations(serviceId: Int, businessId: Int, employeeId: Int){
        let body: [String: Any] = [
            "data": [
                "businesses": [
                    "set": [
                        ["id": businessId]
                    ]
                ],
                "employees": [
                    "set": [
                        ["id": employeeId]
                    ]
                ]
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error al serializar el cuerpo en JSON")
            return
        }
        
        guard let url = URL(string: "http://localhost:1337/api/services/\(serviceId)") else {
            print("URL inválida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
/* CREATE SERVICE
serviceViewModel.createService(id: 99, description: "try", price: 22, name: "try", category: "try", iconURL: "")
 */

/* ADD BUSINESS SERVICE RELATIONS
serviceViewModel.addBusinessServiceRelation(serviceId: 6, businessId: 1)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("Relación actualizada correctamente")
        case .failure(let error):
            print("Error al actualizar la relación: \(error)")
        }
    }, receiveValue: { success in
        print("¿Actualización exitosa? \(success)")
    })
    .store(in: &cancellables)
 */

/* ADD EMPLOYEE SERVICE RELATION
serviceViewModel.addEmployeeServiceRelation(serviceId: 6, employeeId: 1)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("Relación actualizada correctamente")
        case .failure(let error):
            print("Error al actualizar la relación: \(error)")
        }
    }, receiveValue: { success in
        print("¿Actualización exitosa? \(success)")
    })
    .store(in: &cancellables)
 */

//serviceViewModel.updateServiceRelations(serviceId: 6, businessId: 2, employeeId: 2)

/* UPDATE SERVICE ATRIBUTES
serviceViewModel.updateService(serviceId: 6, newDescription: "updated-description", newPrice: 10000, newName:"updated-name")
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("Relación actualizada correctamente")
        case .failure(let error):
            print("Error al actualizar la relación: \(error)")
        }
    }, receiveValue: { success in
        print("¿Actualización exitosa? \(success)")
    })
    .store(in: &cancellables)
 */

//serviceViewModel.deleteService(serviceId: 6)
