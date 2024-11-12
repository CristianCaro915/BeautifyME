//
//  ReservationViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 25/10/24.
//

import Foundation
import Combine

class ReservationViewModel: ObservableObject{
    // VARIABLES FOR TESTING
    @Published var endDate: Date = Date()
    @Published var endDateString: String = ""
    @Published var startDate: Date = Date()
    @Published var startDateString: String = ""
    
    
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
    
    func updateReservationDates(){
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        self.startDateString = isoFormatter.string(from: self.startDate)
        self.endDateString = isoFormatter.string(from: self.endDate)
        
        print("START DATE : \(self.startDate)")
        print("START DATE STRING: \(self.startDateString)")
        print("END DATE : \(self.endDate)")
        print("END DATE STRING: \(self.endDateString)")
    }
    
    func getReservation(id: Int)-> Reservation{
        let now = Date()
        var rta = Reservation(id: 99, title: "error", observation: "error", startDate: now, endDate: now, isActive: true)
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
    
    func createReservation(reservationId: Int, title: String, totalValue: Int, startDate: String, endDate: String, observation: String, isActive: Bool, employeeId: Int, userId: Int){
        // Construir el cuerpo de la solicitud manualmente
        let body: [String: Any] = [
            "data": [
                "id": reservationId,
                "title": title,
                "totalValue": totalValue,
                "startDate":startDate,
                "endDate": endDate,
                "observation": observation,
                "isActive": isActive,
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
/* CREATE RESERVATION
reservationViewModel.updateReservationDates()
reservationViewModel.createReservation(reservationId: 99, title: "try-reserve", totalValue: 9999, startDate: reservationViewModel.startDateString, endDate: reservationViewModel.endDateString,observation: "try-observation", isActive: true, employeeId: 3, userId: 5)
 */

/* UPDATE RESERVATION INSTANCE
reservationViewModel.updateReservation(reservationId: 7,newTitle: "new-title",newObservation: "new-observation")
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

//reservationViewModel.updateReservationRelations(reservationId: 7, employeeId: 1, userId: 6)

//reservationViewModel.deleteReservation(idReservation: 7)


/* ADD TO THE VIEW BUT NEEDS FORMAT
DatePicker(
        "Start Date",
        selection: $reservationViewModel.startDate,
        displayedComponents: [.date, .hourAndMinute]
    )

DatePicker(
        "End Date",
        selection: $reservationViewModel.endDate,
        displayedComponents: [.date, .hourAndMinute]
    )
 */
