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
    
    func createEmployee(id: Int, name: String, gender: String, mail: String, phone: String, earnings: Int, photoURL: String, businessId: Int, serviceId: Int) {
            // Construir el cuerpo de la solicitud manualmente
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
                        "connect":[
                            ["id": serviceId]
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
            guard let url = URL(string: "http://localhost:1337/api/employees") else {
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
                        print("Empleado creado con éxito.")
                    case .failure(let error):
                        print("Error al crear el empleado: \(error.localizedDescription)")
                    }
                }, receiveValue: { data in
                    // Imprimir la respuesta cruda en caso de necesitarla
                    print("Respuesta del servidor: \(String(data: data, encoding: .utf8) ?? "No se recibió respuesta")")
                })
                .store(in: &cancellables)
        }
    
    func addEmployeeService(employeeId: Int, serviceId: Int) ->  AnyPublisher<Bool, Error> {
        // Endpoint
        guard let url = URL(string: "http://localhost:1337/api/employees/\(employeeId)") else {
            fatalError("URL no válida")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
    func deleteEmployee(employeeID: Int) {
        //Check the relations and ID existance
        if !self.employees.contains(where: { $0.id == employeeID }){
            print("The employee with the given id was not found")
            return
        }
        
        
        guard let url = URL(string: "http://localhost:1337/api/employees/\(employeeID)") else {
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
            //.decode(type: [String: Employee].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Employee borrado con éxito.")
                case .failure(let error):
                    print("Error al borrar el employee: \(error)")
                }
            }, receiveValue: { response in
                // Manejo de la respuesta si es necesario
                print("Respuesta del servidor: \(response)")
            })
            .store(in: &cancellables)
    }
    func updateEmployee(employeeId: Int,
        newName: String? = nil,
        newGender: String? = nil,
        newMail: String? = nil,
        newPhone: String? = nil,
        newEarning: Int? = nil,
        newUrl: String? = nil
    ) -> AnyPublisher<Void, Error> {
        // Endpoint
        guard let url = URL(string: "http://localhost:1337/api/employees/\(employeeId)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var photoData: [String: Any] = [:]
        var photo: [String: Any] = [:]
        var employeeData: [String: Any] = [:]
        
        // Only add the fields that have non-nil values
        if let name = newName {
            employeeData["name"] = name
        }
        if let gender = newGender {
            employeeData["gender"] = gender
        }
        if let mail = newMail {
            employeeData["mail"] = mail
        }
        if let phone = newPhone {
            employeeData["phone"] = phone
        }
        if let earning = newEarning {
            employeeData["earning"] = earning
        }
        if let url = newUrl {
            photo["url"] = url
            photoData = ["data": photo]
            employeeData["photo"] = photoData
        }
        
        let requestBody: [String: Any] = ["data": employeeData]
        
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
/* CREATE EMPLOYEE
employeeViewModel.createEmployee(id: 1, name: "try", gender: "try", mail: "try", phone: "234567892", earnings: 22, photoURL: "url", businessId: 1, serviceId: 1)
*/



/* ADD EMPLOYEE RELATION WITH SERVICE
employeeViewModel.addEmployeeService(employeeId: 6, serviceId: 2)
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

/* ADD EMPLOYEE RELATION WITH RESERVATION
employeeViewModel.addEmployeeReservation(employeeId: 6, reservationId: 1)
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

//employeeViewModel.deleteEmployee(employeeID: 7)


/* UPDATE EMPLOYEE INSTANCE ATRIBUTES
employeeViewModel.updateEmployee(employeeId: 6, newName: "new-name", newGender: "new-gender", newMail: "new-main", newPhone: "3214567891")
    .sink(
        receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("Actualización exitosa.")
            case .failure(let error):
                print("Error al actualizar el empleado:", error.localizedDescription)
            }
        },
        receiveValue: { _ in
            print("HELLO SON EMPLOYEE")
            // Este bloque se llama solo en caso de éxito, puedes agregar lógica adicional aquí si es necesario.
        }
    )
    .store(in: &cancellables)
 */

//employeeViewModel.updateEmployeeRelations(employeeId: 6, businessId: 2, serviceId: 3, reservationId: 3)
