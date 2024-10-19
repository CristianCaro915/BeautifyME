//
//  ExampleVM.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 18/10/24.
//

import Foundation

@MainActor
class ExampleVM: ObservableObject {
    @Published var services: [Service] = []
    // /*
    init() {
            fetchServices2()
        }
    // */
    func load(){
            Task(priority: .userInitiated){
                do{
                    print("DEBUG: First Load of services")
                    try await fetchServices()
                } catch{
                    print("DEBUG: Error loading services: \(error)")
                }
            }
        }
    
    
    func fetchServices() async throws{
        let endpoint = "http://localhost:1337/api/services?populate[icon][fields]=url&fields[0]=name&fields[1]=description&fields[2]=price"

        guard let url = URL(string: endpoint) else {
            throw ErrorManager.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
            throw ErrorManager.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let serviceResponse = try decoder.decode(ServiceResponse.self, from: data)
            print("HOLA")
            
            DispatchQueue.main.async {
                print("HOLA2")
                self.services = serviceResponse.data.map { serviceData in
                    print(serviceData)
                    return Service(
                        id: serviceData.id,
                        name: serviceData.attributes.name,
                        description: serviceData.attributes.description,
                        price: serviceData.attributes.price,
                        icon: serviceData.attributes.icon.data.attributes.url
                    )
                }
            }
        } catch{
            throw ErrorManager.invalidData
        }
    }
    
    
    func fetchServices2() {
        let endpoint = "http://localhost:1337/api/services?populate[icon][fields]=url&fields[0]=name&fields[1]=description&fields[2]=price"

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
                        icon: serviceData.attributes.icon.data.attributes.url
                    )
                }
                
                // Actualizar la lista de servicios en el hilo principal
                DispatchQueue.main.async {
                    self.services = servicesList
                    print("here")
                    print(self.services)
                }
            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }.resume() // Iniciar la tarea
    }

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
struct BusinessResponse: Decodable {
    let data: [BusinessData]
}

struct BusinessData: Decodable {
    let attributes: Business
}
