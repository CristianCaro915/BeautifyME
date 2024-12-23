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
    var userId: Int?
    
    init(sessionManager: SessionManager = SessionManager.shared) {
        self.sessionManager = sessionManager
    }
    
    func updateToken(){
        self.sessionManager.jwtToken = self.jwtToken ?? ""
        //print("TOKEN UPDATED IN SESSION MANAGER: \(self.sessionManager.jwtToken)")
    }
    
    func createUser(completion: @escaping (Result<Void, ErrorManager>) -> Void) {
        // Validaciones previas
        guard !name.isEmpty else {
            completion(.failure(.invalidUsername))
            return
        }
        guard !email.isEmpty else {
            completion(.failure(.invalidEmail))
            return
        }
        guard !password.isEmpty else {
            completion(.failure(.invalidPassword))
            return
        }
        guard !phone.isEmpty else {
            completion(.failure(.invalidPhone))
            return
        }

        // Verifica si el nombre de usuario ya existe
        checkUsernameExists(username: name) { [weak self] exists in
            guard let self = self else { return }

            if exists {
                completion(.failure(.usernameAlreadyExists))
                return
            }

            // Continúa con la creación del usuario si el nombre no existe
            guard let url = URL(string: "http://localhost:1337/api/auth/local/register") else {
                completion(.failure(.invalidURL))
                return
            }

            let body: [String: Any] = [
                "username": self.name,
                "email": self.email,
                "password": self.password,
                "phone": self.phone,
                "profile_photo": [
                    "set": [
                        ["id": 31] // ID de `person_generic_icon` en Strapi
                    ]
                ]
            ]

            guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
                completion(.failure(.serializationError))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { data, response -> [String: Any] in
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw ErrorManager.serverError
                    }
                    guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []),
                          let responseDict = jsonResponse as? [String: Any] else {
                        throw ErrorManager.responseParsingError
                    }
                    return responseDict
                }
                .sink(receiveCompletion: { completionStatus in
                    if case .failure(let error) = completionStatus {
                        completion(.failure(error as? ErrorManager ?? .unknown))
                    }
                }, receiveValue: { responseDict in
                    guard let jwt = responseDict["jwt"] as? String else {
                        completion(.failure(.jwtNotFound))
                        return
                    }
                    guard let data = responseDict["user"] as? [String: Any],
                    let id = data["id"] as? Int else {
                        completion(.failure(.invalidData))
                        return
                    }
                    
                    self.userId = id
                    self.jwtToken = jwt
                    //print("JWT guardado exitosamente: \(jwt)")

                    guard let userData = responseDict["user"] as? [String: Any],
                          let email = userData["email"] as? String else {
                        print("Datos del usuario no encontrados en la respuesta")
                        completion(.failure(.invalidResponse))
                        return
                    }

                    DispatchQueue.main.sync {
                        self.updateToken()
                        self.sessionManager.userMail = email

                        do {
                            try self.sessionManager.fetchUserIDByEmail()
                            self.sessionManager.isAuthenticated = true
                            completion(.success(()))
                        } catch {
                            print("Error actualizando el estado del usuario: \(error)")
                            completion(.failure(.updateError))
                        }
                    }
                })
                .store(in: &self.cancellables)
        }
    }

    private func checkUsernameExists(username: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://localhost:1337/api/users?filters[username][$eq]=\(username)") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(false)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                  let data = data,
                  let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []),
                  let responseDict = jsonResponse as? [String: Any],
                  let users = responseDict["data"] as? [[String: Any]] else {
                completion(false)
                return
            }

            // Retorna true si se encuentra al menos un usuario con el nombre
            completion(!users.isEmpty)
        }.resume()
    }

    
    
    func updateUserRole(currentUserId: Int, jwtToken: String, isAdmin: Bool, completion: @escaping (Result<Void, ErrorManager>) -> Void) {
        guard currentUserId > 0 else {
            completion(.failure(.invalidUserId))
            return
        }
        guard !jwtToken.isEmpty else {
            completion(.failure(.invalidJWT))
            return
        }
        
        let roleId = isAdmin ? 3 : 4
        
        guard let url = URL(string: "http://localhost:1337/api/users/\(currentUserId)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let body: [String: Any] = [
            "role": [
                "disconnect": [
                    ["id": 1]
                ],
                "connect": [
                    ["id": roleId]
                ]
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            completion(.failure(.serializationError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> [String: Any] in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw ErrorManager.serverError
                }
                guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []),
                      let responseDict = jsonResponse as? [String: Any] else {
                    throw ErrorManager.responseParsingError
                }
                return responseDict
            }
            .sink(receiveCompletion: { completionStatus in
                if case .failure(let error) = completionStatus {
                    completion(.failure(error as? ErrorManager ?? .unknown))
                }
            }, receiveValue: { _ in
                completion(.success(()))
            })
            .store(in: &cancellables)
    }
    
    
    func deleteUserByEmail(email: String, completion: @escaping (Result<Void, ErrorManager>) -> Void) {
        // Busca al usuario por su email
        findUserByEmail(email: email) { result in
            switch result {
            case .success(let userId):
                // Si se encuentra el usuario, procede a eliminarlo
                self.deleteUser(byId: userId, completion: completion)
            case .failure(let error):
                // Si no se encuentra o hay un error, retorna el error
                completion(.failure(error))
            }
        }
    }

    private func findUserByEmail(email: String, completion: @escaping (Result<Int, ErrorManager>) -> Void) {
        guard let url = URL(string: "http://localhost:1337/api/users?filters[email][$eq]=\(email)") else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknown))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                  let data = data,
                  let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []),
                  let responseArray = jsonResponse as? [[String: Any]],
                  let firstUser = responseArray.first,
                  let userId = firstUser["id"] as? Int else {
                completion(.failure(.invalidEmail)) // Usuario no encontrado
                return
            }

            // Retorna el ID del usuario encontrado
            completion(.success(userId))
        }.resume()
    }

    private func deleteUser(byId userId: Int, completion: @escaping (Result<Void, ErrorManager>) -> Void) {
        guard let url = URL(string: "http://localhost:1337/api/users/\(userId)") else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknown))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError))
                return
            }

            // Usuario eliminado correctamente
            completion(.success(()))
        }.resume()
    }

}
