//
//  InvoiceViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 25/10/24.
//

import Foundation
import Combine

class InvoiceViewModel: ObservableObject{
    // VARIABLE PARA TESTING
    @Published var date: Date = Date()
    @Published var dateString: String = ""
    
    private var sessionManager: SessionManager
    private var dataViewModel: DataViewModel
    private var cancellables = Set<AnyCancellable>()
    
    @Published var invoices: [Invoice] = []
    
    init(sessionManager: SessionManager = SessionManager.shared, dataViewModel: DataViewModel = DataViewModel.shared) {
        self.sessionManager = sessionManager
        self.dataViewModel = dataViewModel
        
        updateDataFromAPI()
    }
    
    func updateDataFromAPI(){
        self.dataViewModel.$invoices
            .sink { [weak self] invoices in
                self?.invoices = invoices
            }
            .store(in: &cancellables)
    }
    
    func updatePaymentDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        self.dateString = dateFormatter.string(from: self.date)
    }
    
    func getInvoice(id: Int) -> Invoice{
        let now = Date()
        var rta = Invoice(id: 99, paymentDate: now, totalValue: 99, reservationId: 99, businessId: 99)
        // check id existance
        if !self.invoices.contains(where: { $0.id == id }){
            print("The invoice with the given id was not found")
            return rta
        }
        // get invoice
        for invoice in self.invoices{
            if invoice.id == id{
                rta = invoice
                break
            }
        }
        return rta
    }
    
    func createInvoice(invoiceId: Int, paymentDate: String, totalValue: Int, businessId: Int, reservationId: Int){
        // Construir el cuerpo de la solicitud manualmente
        let body: [String: Any] = [
            "data": [
                "id": invoiceId,
                "paymentDate": paymentDate,
                "totalValue": totalValue,
                "business":[
                    "connect":[
                        ["id": businessId]
                    ]
                ],
                "reservation":[
                    "connect":[
                        ["id": reservationId]
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
        guard let url = URL(string: "http://localhost:1337/api/invoices") else {
            print("URL inválida")
            return
        }
        
        // Configurar la solicitud
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if (self.sessionManager.isAuthenticated){
            request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
        }
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
                    print("Invoice creado con éxito.")
                case .failure(let error):
                    print("Error al crear el invoice: \(error.localizedDescription)")
                }
            }, receiveValue: { data in
                // Imprimir la respuesta cruda en caso de necesitarla
                print("Respuesta del servidor: \(String(data: data, encoding: .utf8) ?? "No se recibió respuesta")")
            })
            .store(in: &cancellables)
    }
    func deleteInvoice(idInvoice: Int){
        //Check the relations and ID existance
        if !self.invoices.contains(where: { $0.id == idInvoice }){
            print("The invoice with the given id was not found")
            return
        }
        
        
        guard let url = URL(string: "http://localhost:1337/api/invoices/\(idInvoice)") else {
            print("URL inválida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if (self.sessionManager.isAuthenticated){
            request.setValue("Bearer \(self.sessionManager.jwtToken)", forHTTPHeaderField: "Authorization")
        }
        
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
                    print("Invoice borrado con éxito.")
                case .failure(let error):
                    print("Error al borrar el invoice: \(error)")
                }
            }, receiveValue: { response in
                // Manejo de la respuesta si es necesario
                print("Respuesta del servidor: \(response)")
            })
            .store(in: &cancellables)
    }
    
    func updateInvoice(invoiceId: Int,
                       newPaymentDate: Date? = nil,
                       newTotalValue: Int? = nil
    )->AnyPublisher<Void, Error>{
        
        // Endpoint
        guard let url = URL(string: "http://localhost:1337/api/invoices/\(invoiceId)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        var invoiceData: [String: Any] = [:]
        
        // Only add the fields that have non-nil values
        if let paymentDate = newPaymentDate {
            invoiceData["paymentDate"] = paymentDate
        }
        if let totalValue = newTotalValue {
            invoiceData["totalValue"] = totalValue
        }
        
        let requestBody: [String: Any] = ["data": invoiceData]
        
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
    
    func updateInvoiceRelations(invoiceId: Int, businessId: Int, reservationId: Int){
        let body: [String: Any] = [
            "data": [
                "businesses": [
                    "set": [
                        ["id": businessId]
                    ]
                ],
                "reservation": [
                    "set": [
                        ["id": reservationId]
                    ]
                ]
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error al serializar el cuerpo en JSON")
            return
        }
        
        guard let url = URL(string: "http://localhost:1337/api/invoices/\(invoiceId)") else {
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
/*
print("CREANDO UN INVOICE")
invoiceViewModel.updatePaymentDate()
invoiceViewModel.createInvoice(invoiceId: 99, paymentDate: invoiceViewModel.dateString, totalValue: 9999, businessId: 1, reservationId: 1)
*/

/*
print("EDITANDO INVOICE")
invoiceViewModel.updateInvoice(invoiceId: 5, newTotalValue: 8000)
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

//invoiceViewModel.updateInvoiceRelations(invoiceId: 2, businessId: 2, reservationId: 1)

//invoiceViewModel.deleteInvoice(idInvoice: 6)


// SET ON THE VIEW but needs format and colours

/*
 DatePicker(
         "Start Date",
         selection: $invoiceViewModel.date,
         displayedComponents: [.date]
     )
 */
