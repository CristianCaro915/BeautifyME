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
    
    func createEmployee(business: Business){
        
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
            .decode(type: [String: Employee].self, decoder: JSONDecoder())
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
}
