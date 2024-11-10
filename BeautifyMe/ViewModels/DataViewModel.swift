//
//  DataViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 25/10/24.
//

import Foundation
import Combine

class DataViewModel:ObservableObject{
    @Published var users: [User] = []
    @Published var services: [Service] = []
    @Published var businesses: [Business] = []
    @Published var comments: [Comment] = []
    @Published var employees: [Employee] = []
    @Published var invoices: [Invoice] = []
    @Published var reservations: [Reservation] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let serialQueue = DispatchQueue(label: "com.tuapp.queue.serial")
    static let shared = DataViewModel()
    
    private init() {
            Task {
                await fetchUsers()  // Espera a que `fetchUsers` termine
                await fetchComments()  // Luego ejecuta `fetchComments`
                fetchServices()
                fetchEmployees()
                fetchBusinesses()
                fetchInvoices()
                fetchReservations()
            }
        }
    
    func fetchUsers() async {
        //print("USERS INITIALIZED")
        let urlString = "http://localhost:1337/api/users?populate[profile_photo][fields]=url&fields[0]=id&fields[1]=username&fields[2]=email&fields[3]=phone&populate[role][fields]=name"
        guard let url = URL(string: urlString) else {
            print("URL no válida.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error realizando la solicitud: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No se recibieron datos.")
                return
            }
            
            do {
                // Decodificar el JSON en un array de diccionarios
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    DispatchQueue.main.async {
                        self?.users = jsonArray.compactMap { dict in
                            // Extraer los campos necesarios
                            guard let id = dict["id"] as? Int,
                                  let username = dict["username"] as? String,
                                  let email = dict["email"] as? String,
                                  let phone = dict["phone"] as? String,
                                  let roleDict = dict["role"] as? [String: Any],
                                  let roleName = roleDict["name"] as? String,
                                  let profilePhoto = dict["profile_photo"] as? [String: Any],
                                  let imageUrl = profilePhoto["url"] as? String else {
                                return nil
                            }
                            // Crear el objeto User
                            return User(id: id, username: username, email: email, phone: phone, role: roleName, imageURL: imageUrl)
                        }
                        
                        //print("DATA VIEW MODEL USERS")
                        //print(self?.users)
                        //print("USERS FINISHED")
                    }
                }
                
            } catch {
                print("Error decodificando los datos: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func fetchServices() {
        //print("SERVICES INITIALIZED")
        let endpoint = "http://localhost:1337/api/services?populate[icon][fields]=url&fields[0]=name&fields[1]=description&fields[2]=price&fields[3]=category"
        
        guard let url = URL(string: endpoint) else {
            print("Error: URL inválida.")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> [[String: Any]] in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                // Parse JSON using JSONSerialization
                let jsonObject = try JSONSerialization.jsonObject(with: result.data, options: [])
                guard let jsonDict = jsonObject as? [String: Any],
                      let dataArray = jsonDict["data"] as? [[String: Any]] else {
                    throw URLError(.cannotParseResponse)
                }
                return dataArray
            }
            .map { dataArray -> [Service] in
                dataArray.compactMap { serviceDict -> Service? in
                    guard let id = serviceDict["id"] as? Int,
                          let attributes = serviceDict["attributes"] as? [String: Any],
                          let name = attributes["name"] as? String,
                          let description = attributes["description"] as? String,
                          let price = attributes["price"] as? Int,
                          let category = attributes["category"] as? String,
                          let iconData = attributes["icon"] as? [String: Any],
                          let iconInnerData = iconData["data"] as? [String: Any],
                          let iconAttributes = iconInnerData["attributes"] as? [String: Any],
                          let iconURL = iconAttributes["url"] as? String else {
                        return nil
                    }
                    
                    return Service(id: id, name: name, description: description, price: price, category: category, icon: iconURL)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error en la solicitud: \(error)")
                }
            }, receiveValue: { [weak self] services in
                self?.services = services
                //print("SERVICES FINIHEDD")
            })
            .store(in: &cancellables)
    }
    
    func fetchBusinesses() {
        //print("BUSINESSES INITIALIZED")
        let endpoint = "http://localhost:1337/api/businesses?populate[images][fields]=url&populate[gallery][fields]=url&populate[logo][fields]=url&fields[0]=name&fields[1]=category&fields[2]=description&fields[3]=latitude&fields[4]=longitude"
        
        guard let url = URL(string: endpoint) else {
            print(ErrorManager.invalidURL)
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .tryMap { data -> [[String: Any]] in
                guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let dataArray = jsonObject["data"] as? [[String: Any]] else {
                    throw URLError(.cannotParseResponse)
                }
                return dataArray
            }
            .map { dataArray in
                dataArray.compactMap { item -> Business? in
                    guard let id = item["id"] as? Int,
                          let attributes = item["attributes"] as? [String: Any],
                          let name = attributes["name"] as? String,
                          let category = attributes["category"] as? String,
                          let description = attributes["description"] as? String,
                          let latitude = attributes["latitude"] as? String,
                          let longitude = attributes["longitude"] as? String,
                          let imagesData = (attributes["images"] as? [String: Any])?["data"] as? [[String: Any]],
                          let galleryData = (attributes["gallery"] as? [String: Any])?["data"] as? [[String: Any]],
                          let logoData = (attributes["logo"] as? [String: Any])?["data"] as? [String: Any],
                          let logoUrl = (logoData["attributes"] as? [String: Any])?["url"] as? String else {
                        return nil
                    }
                    
                    let imageUrls = imagesData.compactMap { $0["attributes"] as? [String: Any] }.compactMap { $0["url"] as? String }
                    let galleryUrls = galleryData.compactMap { $0["attributes"] as? [String: Any] }.compactMap { $0["url"] as? String }
                    
                    return Business(
                        id: id,
                        name: name,
                        category: category,
                        description: description,
                        images: imageUrls,
                        latitude: latitude,
                        longitude: longitude,
                        gallery: galleryUrls,
                        logo: logoUrl
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("Error fetching businesses: \(error)")
                    }
                },
                receiveValue: { [weak self] businessList in
                    self?.businesses = businessList
                    //print("BUSINESS FINISHED")
                }
            )
            .store(in: &cancellables)
    }
    func fetchComments() async {
        await Task.sleep( 2 * 1_000_000_000) // test performance, fetch users being called 3-5 times
        //print("COMMENTS INITIALIZED")
        guard let url = URL(string: "http://localhost:1337/api/comments?populate[user][fields]=id&fields[0]=description&fields[1]=ranking") else {
            print("URL no válida")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> [[String: Any]] in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                // Parse JSON usando JSONSerialization
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDict = jsonObject as? [String: Any],
                      let dataArray = jsonDict["data"] as? [[String: Any]] else {
                    throw URLError(.cannotParseResponse)
                }
                return dataArray
            }
            .map { dataArray -> [Comment] in
                dataArray.compactMap { commentDict -> Comment? in
                    guard let id = commentDict["id"] as? Int,
                          let attributes = commentDict["attributes"] as? [String: Any],
                          let description = attributes["description"] as? String,
                          let ranking = attributes["ranking"] as? Int,
                          let userData = attributes["user"] as? [String: Any],
                          let userInnerData = userData["data"] as? [String: Any],
                          let userId = userInnerData["id"] as? Int else {
                        return nil
                    }
                    
                    // Busca el usuario correspondiente en la lista de usuarios
                    //print("DEBUG: user id to seach is \(userId)")
                    let user = self.searchUser(userId: userId)
                    //print("\(user.username)")
                    
                    return Comment(
                        id: id,
                        description: description,
                        rating: ranking,
                        commenterName: user.username,
                        commenterImage: user.imageURL
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error al obtener comentarios: \(error)")
                }
            }, receiveValue: { [weak self] comments in
                self?.comments = comments
                //print("DATA VIEW MODEL COMMENTS")
                //print(self?.comments)
                //print("COMMENTS FINISHED")
            })
            .store(in: &cancellables)
    }
    func searchUser(userId: Int) -> User{
        var rta = User(id: 99, username: "wrong user", email: "wrong@gmail.com", phone: "1234354617", role: "client", imageURL: "")
        for user in self.users{
            if user.id == userId{
                rta = user
                break
            }
        }
        return rta
    }
    
    func fetchEmployees() {
        //print("EMPLOYEES INITIALIZED")
        guard let url = URL(string: "http://localhost:1337/api/employees?populate[photo][fields]=url&fields[0]=name&fields[1]=gender&fields[2]=mail&fields[3]=phone&fields[4]=earning") else {
            print("URL no válida")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> [[String: Any]] in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                // Parseo del JSON usando JSONSerialization
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDict = jsonObject as? [String: Any],
                      let dataArray = jsonDict["data"] as? [[String: Any]] else {
                    throw URLError(.cannotParseResponse)
                }
                return dataArray
            }
            .map { dataArray -> [Employee] in
                dataArray.compactMap { employeeDict -> Employee? in
                    guard let id = employeeDict["id"] as? Int,
                          let attributes = employeeDict["attributes"] as? [String: Any],
                          let name = attributes["name"] as? String,
                          let gender = attributes["gender"] as? String,
                          let mail = attributes["mail"] as? String,
                          let phone = attributes["phone"] as? String,
                          let earning = attributes["earning"] as? Int,
                          let photoData = attributes["photo"] as? [String: Any],
                          let photoInnerData = photoData["data"] as? [String: Any],
                          let photoAttributes = photoInnerData["attributes"] as? [String: Any],
                          let photoURL = photoAttributes["url"] as? String else {
                        return nil
                    }
                    
                    return Employee(
                        id: id,
                        name: name,
                        gender: gender,
                        mail: mail,
                        phone: phone,
                        earnings: earning,
                        photo: photoURL
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error al obtener empleados: \(error)")
                }
            }, receiveValue: { [weak self] employees in
                self?.employees = employees
                //print("DATA VIEW MODEL EMPLOYYEES")
                //print(self!.employees)
                //print("EMPLOYEES FINISHED")
            })
            .store(in: &cancellables)
    }
    
    func fetchInvoices(){
        //print("Fetching invoices")
        guard let url = URL(string: "http://localhost:1337/api/invoices?populate[business][fields]=id&populate[reservation][fields]=id&fields[0]=paymentDate&fields[1]=totalValue") else {
            print("URL no válida")
            return
        }
        
        // Configuración del DateFormatter para la conversión de fechas
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> [[String: Any]] in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                // Parseo del JSON usando JSONSerialization
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDict = jsonObject as? [String: Any],
                      let dataArray = jsonDict["data"] as? [[String: Any]] else {
                    throw URLError(.cannotParseResponse)
                }
                return dataArray
            }
            .map { dataArray -> [Invoice] in
                dataArray.compactMap { invoiceDict -> Invoice? in
                    guard let id = invoiceDict["id"] as? Int,
                          let attributes = invoiceDict["attributes"] as? [String: Any],
                          let paymentDateString = attributes["paymentDate"] as? String,
                          let paymentDate = dateFormatter.date(from: paymentDateString),
                          let totalValue = attributes["totalValue"] as? Int,
                          
                          let business = attributes["business"] as? [String: Any],
                          let businessData = business["data"] as? [String: Any],
                          let businessId = businessData["id"] as? Int,
                          let reservation = attributes["reservation"] as? [String: Any],
                          let reservationData = reservation["data"]as? [String: Any],
                          let reservationId = reservationData["id"] as? Int else {
                        return nil
                    }
                    
                    return Invoice(
                        id: id,
                        paymentDate: paymentDate,
                        totalValue: totalValue,
                        reservationId: reservationId,
                        businessId: businessId
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error al obtener invoices: \(error)")
                }
            }, receiveValue: { [weak self] invoices in
                self?.invoices = invoices
                //print("DATA VIEW MODEL INVOICES")
                //print(self!.invoices)
            })
            .store(in: &cancellables)
    }
    
    func fetchReservations(){
        print("Fetching reservations")
        guard let url = URL(string: "http://localhost:1337/api/reservations?fields[0]=title&fields[1]=startDate&fields[2]=endDate&fields[3]=observation&fields[4]=isActive") else {
            print("URL no válida")
            return
        }
        
        // Configuración del DateFormatter para la conversión de fechas
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> [[String: Any]] in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                // Parseo del JSON usando JSONSerialization
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                guard let jsonDict = jsonObject as? [String: Any],
                      let dataArray = jsonDict["data"] as? [[String: Any]] else {
                    throw URLError(.cannotParseResponse)
                }
                return dataArray
            }
            .map { dataArray -> [Reservation] in
                dataArray.compactMap { reservationDict -> Reservation? in
                    guard let id = reservationDict["id"] as? Int,
                          let attributes = reservationDict["attributes"] as? [String: Any],
                          let title = attributes["title"] as? String,
                          let startDateString = attributes["startDate"] as? String,
                          let startDate = isoDateFormatter.date(from: startDateString),
                          let endDateString = attributes["endDate"] as? String,
                          let endDate = isoDateFormatter.date(from: endDateString),
                          let observation = attributes["observation"] as? String,
                          let isActive = attributes["isActive"] as? Bool else {
                        return nil
                    }
                    
                    // AJUSTAR EL FORMATTER PARA EVITAR UTC TIME.
                    // Restar 5 horas a startDate y endDate
                    let adjustedStartDate = startDate.addingTimeInterval(-5 * 3600)
                    let adjustedEndDate = endDate.addingTimeInterval(-5 * 3600)
                    
                    return Reservation(
                        id: id,
                        title: title,
                        observation: observation,
                        startDate: adjustedStartDate,
                        endDate: adjustedEndDate,
                        isActive: isActive
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error al obtener reservations: \(error)")
                }
            }, receiveValue: { [weak self] reservations in
                self?.reservations = reservations
                print("DATA VIEW MODEL RESERVATIONS")
                print(self!.reservations)
            })
            .store(in: &cancellables)
    }
}

