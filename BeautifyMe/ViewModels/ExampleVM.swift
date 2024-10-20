//
//  ExampleVM.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 18/10/24.
//

import Foundation

@MainActor
class ExampleVM: ObservableObject {
    @Published var selectedBusiness: Business?
    @Published var selectedService: Service?
    @Published var services: [Service] = []
    @Published var businesses: [Business] = []
    
    init() {
            fetchServices()
            fetchBusinesses()
        }
    
    func fetchServices() {
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
                }
            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }.resume() // Iniciar la tarea
    }
    
    func fetchBusinesses() {
        let endpoint = "http://localhost:1337/api/businesses?populate=images&fields[0]=name&fields[1]=category&fields[2]=description&fields[3]=latitude&fields[4]=longitude"

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
                let businessResponse = try decoder.decode(BusinessResponse.self, from: data)
                let businessList = businessResponse.data.map { businessData in
                    let imageUrls = businessData.attributes.images.data.map { imageData in
                        imageData.attributes.url
                    }
                    
                    return Business(
                        id: businessData.id,
                        name: businessData.attributes.name,
                        category: businessData.attributes.category,
                        description: businessData.attributes.description,
                        images: imageUrls, 
                        latitude: businessData.attributes.latitude,
                        longitude: businessData.attributes.longitude
                    )
                }
                
                // Actualizar la lista de servicios en el hilo principal
                DispatchQueue.main.async {
                    self.businesses = businessList
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
    let id: Int
    let attributes: BusinessAtributes
}

struct BusinessAtributes: Decodable{
    let name: String
    let category: String
    let description: String
    let images: ImagesData
    let latitude: String
    let longitude: String
}

struct ImagesData: Decodable{
    let data: [ImageData]
}

struct ImageData: Decodable{
    let id: Int
    let attributes: ImageAtributes
}

struct ImageAtributes: Decodable{
    let url: String
}
