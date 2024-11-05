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
                print(self?.reservations)
            }
            .store(in: &cancellables)
    }
    func getReservation(id: Int)-> Reservation{
        let now = Date()
        var rta = Reservation(id: 99, title: "error", observation: "error", startDate: now, endDate: now)
        // check id existance
        if !self.reservations.contains(where: { $0.id == id }){
            print("The reservation with the given id was not found")
            return rta
        }
        // get reservation
        for reservation in self.reservations{
            if reservation.id == id{
                rta = reservation
                break
            }
        }
        return rta
    }
    
    func createReservation(reservationId: Int, title: String, totalValue: Int, startDate: Date, endDate: Date, employeeId: Int, userId: Int){
        // Construir el cuerpo de la solicitud manualmente
        let body: [String: Any] = [
            "data": [
                "id": reservationId,
                "tittle": title,
                "totalValue": totalValue,
                "startDate":startDate,
                "endDate":endDate,
                "employee":[
                    "connect":[
                        ["id": employeeId]
                    ]
                ],
                "user":[
                    "connect":[
                        ["id": userId]
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
        guard let url = URL(string: "http://localhost:1337/api/reservations") else {
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
                    print("Reservation creado con éxito.")
                case .failure(let error):
                    print("Error al crear la reservation: \(error.localizedDescription)")
                }
            }, receiveValue: { data in
                // Imprimir la respuesta cruda en caso de necesitarla
                print("Respuesta del servidor: \(String(data: data, encoding: .utf8) ?? "No se recibió respuesta")")
            })
            .store(in: &cancellables)
    }
    func deleteReservation(idReservation: Int){
        //Check the relations and ID existance
        if !self.reservations.contains(where: { $0.id == idReservation }){
            print("The reservation with the given id was not found")
            return
        }
        
        
        guard let url = URL(string: "http://localhost:1337/api/reservations/\(idReservation)") else {
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
                    print("Reservation borrado con éxito.")
                case .failure(let error):
                    print("Error al borrar la reservation: \(error)")
                }
            }, receiveValue: { response in
                // Manejo de la respuesta si es necesario
                print("Respuesta del servidor: \(response)")
            })
            .store(in: &cancellables)
    }
    
    func updateReservation(reservationId: Int,
                       newTitle: String? = nil,
                       newStartDate: Date? = nil,
                       newEndDate: Date? = nil,
                       newObservation: String? = nil
    )->AnyPublisher<Void, Error>{
        
        // Endpoint
        guard let url = URL(string: "http://localhost:1337/api/reservations/\(reservationId)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        var reservationData: [String: Any] = [:]
        
        // Only add the fields that have non-nil values
        if let title = newTitle {
            reservationData["title"] = title
        }
        if let startDate = newStartDate {
            reservationData["startDate"] = startDate
        }
        if let endDate = newEndDate {
            reservationData["endDate"] = endDate
        }
        if let observation = newObservation {
            reservationData["observation"] = observation
        }
        
        let requestBody: [String: Any] = ["data": reservationData]
        
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
    
    func updateReservationRelations(reservationId: Int, employeeId: Int, userId: Int){
        let body: [String: Any] = [
            "data": [
                "employee": [
                    "set": [
                        ["id": employeeId]
                    ]
                ],
                "user": [
                    "set": [
                        ["id": userId]
                    ]
                ]
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error al serializar el cuerpo en JSON")
            return
        }
        
        guard let url = URL(string: "http://localhost:1337/api/reservations/\(reservationId)") else {
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
