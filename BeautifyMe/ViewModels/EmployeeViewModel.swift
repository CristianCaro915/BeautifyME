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
    @Published var employeeId: Int?
    
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
    
    func getEmployee(id: Int) -> Employee{
        var rta = Employee(id: 99, name: "", gender: "", mail: "", phone: "", earnings: 2, photo: "")
        // check id existance
        if !self.employees.contains(where: { $0.id == id }){
            print("The employee with the given id was not found")
            return rta
        }
        // get employee
        for employee in self.employees{
            if employee.id == id{
                rta = employee
                break
            }
        }
        return rta
    }
    
    func createEmployee(
        id: Int,
        name: String?,
        gender: String?,
        mail: String?,
        phone: String?,
        earnings: Int?,
        photoURL: String,
        businessId: Int,
        serviceId: Int,
        completion: @escaping (Result<Void, ErrorManager>) -> Void
    ) {
        // 1. Validaciones de entrada
        guard let name = name, !name.isEmpty else {
            completion(.failure(.invalidUsername))
            return
        }
        
        guard let gender = gender, !gender.isEmpty else {
            completion(.failure(.invalidGender))
            return
        }
        
        guard let mail = mail, !mail.isEmpty else {
            completion(.failure(.invalidEmail))
            return
        }
        
        guard let phone = phone, !phone.isEmpty else {
            completion(.failure(.invalidPhone))
            return
        }
        
        guard let earnings = earnings, earnings > 0 else {
            completion(.failure(.invalidEarnings))
            return
        }
        
        // 2. Validar existencia de negocio y servicio
        guard dataViewModel.businesses.contains(where: { $0.id == businessId }) else {
            completion(.failure(.invalidBusinessId))
            return
        }
        
        guard dataViewModel.services.contains(where: { $0.id == serviceId }) else {
            completion(.failure(.invalidServiceId))
            return
        }
        
        // 3. Construir el cuerpo de la solicitud
        let body: [String: Any] = [
            "data": [
                "id": id,
                "name": name,
                "gender": gender,
                "mail": mail,
                "phone": phone,
                "earning": earnings,
                "photo": [
                    "data": [
                        "attributes": [
                            "url": photoURL
                        ]
                    ]
                ],
                "business": [
                    "connect": [
                        ["id": businessId]
                    ]
                ],
                "services": [
                    "connect": [
                        ["id": serviceId]
                    ]
                ]
            ]
        ]
        
        // 4. Serializar el cuerpo a JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            completion(.failure(.serializationError))
            return
        }
        
        // 5. Crear URL del endpoint
        guard let url = URL(string: "http://localhost:1337/api/employees") else {
            completion(.failure(.invalidURL))
            return
        }
        
        // 6. Configurar la solicitud HTTP
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        // 7. Realizar la solicitud POST
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { response -> Data in
                guard let httpResponse = response.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return response.data
            }
            .sink(receiveCompletion: { completionStatus in
                // Eliminar completion(.success) aquí para evitar duplicidad
                if case .failure = completionStatus {
                    completion(.failure(.serverError))
                }
            }, receiveValue: { [weak self] data in
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let dataDict = jsonResponse["data"] as? [String: Any],
                       let employeeId = dataDict["id"] as? Int {
                        self?.employeeId = employeeId
                        print("Employee creado con éxito. ID: \(employeeId)")
                        completion(.success(()))  // Se llama una sola vez aquí
                    } else {
                        print("No se pudo extraer el ID del employee.")
                        completion(.failure(.invalidData))
                    }
                } catch {
                    completion(.failure(.invalidData))
                }
            })
            .store(in: &self.cancellables)
    }

    
    func addEmployeeService(employeeId: Int, serviceId: Int) ->  AnyPublisher<Bool, Error> {
        // Endpoint
        guard let url = URL(string: "http://localhost:1337/api/employees/\(employeeId)") else {
            fatalError("URL no válida")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if (self.sessionManager.isAuthenticated){
            request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
        }
        
        let body: [String: Any] = [
            "data": [
                "services": [
                    "connect":[
                        ["id": serviceId]
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
            .mapError {error in
                print("Error en la solicitud: \(error.localizedDescription)") // Debugging
                return error
            }
            .eraseToAnyPublisher()
    }
    func addEmployeeReservation(employeeId: Int,reservationId: Int) ->  AnyPublisher<Bool, Error> {
        // Endpoint
        guard let url = URL(string: "http://localhost:1337/api/employees/\(employeeId)") else {
            fatalError("URL no válida")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if (self.sessionManager.isAuthenticated){
            request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
        }
        
        let body: [String: Any] = [
            "data": [
                "reservations":[
                    "connect":[
                        ["id": reservationId]
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
    func deleteEmployee(employeeID: Int, completion: @escaping (Result<Void, ErrorManager>) -> Void) {
        guard self.employees.contains(where: { $0.id == employeeID }) else {
            completion(.failure(.invalidUserId))
            return
        }
        
        guard let url = URL(string: "http://localhost:1337/api/employees/\(employeeID)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        if self.sessionManager.isAuthenticated {
            request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .finished:
                    completion(.success(()))
                case .failure:
                    completion(.failure(.serverError))
                }
            }, receiveValue: { _ in
                print("Empleado eliminado correctamente.")
            })
            .store(in: &cancellables)
    }
    
    func editEmployee(employeeId: Int, newEarnings: Int?, completion: @escaping (Result<Void, ErrorManager>) -> Void) {
        
        // Validación de ganancias negativas
        if let newEarnings = newEarnings, newEarnings <= 0 {
            completion(.failure(.invalidEarnings))
            return
        }
        
        var updateData: [String: Any] = [:]
        
        if let newEarnings = newEarnings {
            updateData["earning"] = newEarnings
        }
        
        let body: [String: Any] = ["data": updateData]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            completion(.failure(.serializationError))
            return
        }
        
        guard let url = URL(string: "http://localhost:1337/api/employees/\(employeeId)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if self.sessionManager.isAuthenticated {
            request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = jsonData
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { response -> Data in
                guard let httpResponse = response.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return response.data
            }
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .finished:
                    completion(.success(()))
                case .failure:
                    completion(.failure(.serverError))
                }
            }, receiveValue: { data in
                print("Empleado actualizado correctamente.")
            })
            .store(in: &cancellables)
    }
    
    
    func updateEmployeeRelations(employeeId: Int, businessId: Int,serviceId: Int ,reservationId: Int){
        let body: [String: Any] = [
            "data": [
                "business": [
                    "set": [
                        ["id": businessId]
                    ]
                ],
                "services": [
                    "set": [
                        ["id": serviceId]
                    ]
                ],
                "reservations":[
                    "set": [
                        ["id":reservationId]
                    ]
                ]
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error al serializar el cuerpo en JSON")
            return
        }
        
        guard let url = URL(string: "http://localhost:1337/api/employees/\(employeeId)") else {
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
    
    func findEmployeeByName(name: String, completion: @escaping (Result<Int, ErrorManager>) -> Void) {
        guard let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "http://localhost:1337/api/employees?filters[name][$eq]=\(encodedName)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { response -> Data in
                guard let httpResponse = response.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return response.data
            }
            .tryMap { data -> Int? in
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                
                guard let jsonDict = jsonObject as? [String: Any],
                      let dataArray = jsonDict["data"] as? [[String: Any]],
                      let firstEmployee = dataArray.first,
                      let id = firstEmployee["id"] as? Int else {
                    return nil
                }
                return id
            }
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .failure:
                    completion(.failure(.serverError))
                case .finished:
                    break
                }
            }, receiveValue: { employeeID in
                if let employeeID = employeeID {
                    completion(.success(employeeID))
                } else {
                    completion(.failure(.invalidUserId))
                }
            })
            .store(in: &cancellables)
    }


}
