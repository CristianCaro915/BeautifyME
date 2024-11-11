//
//  SignInViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 19/10/24.
//

import Foundation
import Combine


class SignInViewModel: ObservableObject{
    private var sessionManager: SessionManager
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var password: String = ""
    @Published var isBusinessAdmin: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private(set) var jwtToken: String?
    
    init(sessionManager: SessionManager = SessionManager.shared) {
        self.sessionManager = sessionManager
    }
    
    func createUser() {
        // URL de la solicitud
        guard let url = URL(string: "http://localhost:1337/api/auth/local/register") else {
            print("URL no válida")
            return
        }
        
        let body: [String: Any] = [
            "username": self.name,
            "email": self.email,
            "password": self.password,
            "phone": self.phone
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error al convertir el cuerpo de la solicitud a JSON")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> [String: Any] in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []),
                      let responseDict = jsonResponse as? [String: Any] else {
                    throw URLError(.cannotParseResponse)
                }
                
                return responseDict
            }
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error al crear el usuario: \(error)")
                }
            }, receiveValue: { [weak self] responseDict in
                // Almacena el JWT si está presente en la respuesta
                if let jwt = responseDict["jwt"] as? String {
                    self?.jwtToken = jwt
                    print("JWT guardado exitosamente: \(jwt)")
                } else {
                    print("JWT no encontrado en la respuesta")
                }
            })
            .store(in: &cancellables)
    }
    
    func updateUserRole(currentUserId: Int, jwtToken: String) {
            // URL de la solicitud
            guard let url = URL(string: "http://localhost:1337/api/users/\(currentUserId)") else {
                print("URL no válida")
                return
            }

            // Configuración del cuerpo de la solicitud
            let body: [String: Any] = [
                "role": [
                    "disconnect": [
                        ["id": 1]
                    ],
                    "connect": [
                        ["id": 3]
                    ]
                ]
            ]

            // Conversión del cuerpo a JSON Data
            guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
                print("Error al convertir el cuerpo de la solicitud a JSON")
                return
            }

            // Configuración de la solicitud
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData

            // Realiza la solicitud usando Combine
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { data, response -> [String: Any] in
                    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                        throw URLError(.badServerResponse)
                    }

                    // Convierte el JSON de respuesta a un diccionario
                    guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []),
                          let responseDict = jsonResponse as? [String: Any] else {
                        throw URLError(.cannotParseResponse)
                    }

                    return responseDict
                }
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error al actualizar el rol del usuario: \(error)")
                    }
                }, receiveValue: { responseDict in
                    print("Rol del usuario actualizado exitosamente:", responseDict)
                })
                .store(in: &cancellables)
        }
    
    
}
