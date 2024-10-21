//
//  BusinessDetailViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 19/10/24.
//

import Foundation
import Combine

class BusinessDetailViewModel: ObservableObject{
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
    
    func updateCurrentBusiness(from sessionManager: SessionManager) {
        sessionManager.$businessSelected
            .sink { [weak self] business in
                self?.currentBusiness = business 
            }
            .store(in: &cancellables)
        
        sessionManager.$users
            .sink { [weak self] users in
                self?.users = users
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
                self?.selectBusinessRelations()
                
            })
            .store(in: &cancellables)
    }
    
    func fetchServices() {
        let endpoint = "http://localhost:1337/api/services?populate[icon][fields]=url&fields[0]=name&fields[1]=description&fields[2]=price&fields[3]=category"

        guard let url = URL(string: endpoint) else {
            print(ErrorManager.invalidURL)
            return
        }

        // Realizar la solicitud
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Manejar errores de la solicitud
            if let error = error {
                print("Error en la solicitud: \(error)")
                return
            }
            
            // Verificar la respuesta HTTP
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print(ErrorManager.invalidResponse)
                return
            }

            // Verificar y decodificar los datos
            guard let data = data else {
                print(ErrorManager.invalidData)
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let serviceResponse = try decoder.decode(ServiceResponse.self, from: data)
                let servicesList = serviceResponse.data.map { serviceData in
                    return Service(
                        id: serviceData.id,
                        name: serviceData.attributes.name,
                        description: serviceData.attributes.description,
                        price: serviceData.attributes.price,
                        category: serviceData.attributes.category,
                        icon: serviceData.attributes.icon.data.attributes.url
                    )
                }
                
                // Actualizar la lista de servicios en el hilo principal
                DispatchQueue.main.async {
                    self.services = servicesList
                }
            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }.resume() // Iniciar la tarea
    }
    func fetchComments() {
        guard let url = URL(string: "http://localhost:1337/api/comments?populate[user][fields]=id&fields[0]=description&fields[1]=ranking") else {
            print("URL no válida")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: CommentAPIResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error al obtener comentarios: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] apiResponse in
                self?.comments = apiResponse.data.compactMap { commentData in
                    let userId = commentData.attributes.user.data.id
                    // Busca el usuario correspondiente en la lista de usuarios
                    for user in self!.users {
                        if user.id == userId {
                            self!.user = user
                            break // Sale del bucle una vez que se encuentra el usuario
                        }
                    }
                    return Comment(
                        id: commentData.id,
                        description: commentData.attributes.description,
                        rating: commentData.attributes.ranking,
                        commenterName: self?.user?.username ?? "Unknown",
                        commenterImage: self?.user?.imageURL ?? "defaultImage.png"
                    )
                }
            })
            .store(in: &cancellables)
    }
    
    func fetchEmployees() {
            guard let url = URL(string: "http://localhost:1337/api/employees?populate[photo][fields]=url&fields[0]=name&fields[1]=gender&fields[2]=mail&fields[3]=phone&fields[4]=earning") else {
                print("URL no válida")
                return
            }

            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: EmployeeResponse.self, decoder: JSONDecoder())
                .replaceError(with: EmployeeResponse(data: []))
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] response in
                    self?.employees = response.data.map { employee in
                        Employee(
                            id: employee.id,
                            name: employee.attributes.name,
                            gender: employee.attributes.gender,
                            mail: employee.attributes.mail,
                            phone: employee.attributes.phone,
                            earnings: employee.attributes.earning,
                            photo: employee.attributes.photo.data.attributes.url
                        )
                    }
                    //print("Employees")
                    //print(self?.employees)
                })
                .store(in: &cancellables)
        }
    
    func selectBusinessRelations(){
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
        print("Business services")
        print(self.servicesBusiness)
        print("Business employees")
        print(self.employeesBusiness)
        print("Business comments")
        print(self.commentsBusiness)
    }
    
    struct ServiceResponse: Decodable {
        let data: [ServiceData]
    }

    struct ServiceData: Decodable {
        let id: Int
        let attributes: ServiceAttributes
    }
    struct ServiceAttributes: Decodable {
        let name: String
        let description: String
        let price: Int
        let category: String
        let icon: IconData
    }
    struct IconData: Decodable {
        let data: IconAttributes
    }

    struct IconAttributes: Decodable {
        let attributes: IconURL
    }

    struct IconURL: Decodable {
        let url: String
    }
    
    struct CommentAPIResponse: Decodable {
        let data: [CommentData]
    }

    struct CommentData: Decodable {
        let id: Int
        let attributes: CommentAttributes
    }

    struct CommentAttributes: Decodable {
        let description: String
        let ranking: Int64
        let user: UserData
    }

    struct UserData: Decodable {
        let data: UserIdWrapper
    }

    struct UserIdWrapper: Decodable {
        let id: Int
    }
    
    struct EmployeeResponse: Decodable {
        let data: [EmployeeData]
    }

    struct EmployeeData: Decodable {
        let id: Int
        let attributes: EmployeeAttributes
    }

    struct EmployeeAttributes: Decodable {
        let name: String
        let gender: String
        let mail: String
        let phone: String
        let earning: Int
        let photo: PhotoData
    }

    struct PhotoData: Decodable {
        let data: PhotoAttributes
    }

    struct PhotoAttributes: Decodable {
        let attributes: PhotoAttributesDetails
    }

    struct PhotoAttributesDetails: Decodable {
        let url: String
    }
}
