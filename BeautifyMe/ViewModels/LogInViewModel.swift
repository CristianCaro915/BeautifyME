//
//  LogInViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 19/10/24.
//
import Foundation

class LogInViewModel: ObservableObject{
    private var sessionManager: SessionManager
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isAuthenticated: Bool = false
    
    init(sessionManager: SessionManager = SessionManager.shared) {
        self.sessionManager = sessionManager
    }
    
    func authenticateUser() {
            authenticateUser(identifier: email, password: password) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let jwtToken):
                        print("Token JWT recibido: \(jwtToken)")
                        self?.isAuthenticated = true
                        self?.sessionManager.loginUser()
                        self?.sessionManager.userMail = self?.email
                        self?.sessionManager.fetchUserIDByEmail()
                        
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        self?.isAuthenticated = false
                        self?.sessionManager.isAuthenticated = false
                    }
                }
            }
        }
    
    private func authenticateUser(identifier: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Define el endpoint de autenticación de Strapi
        guard let url = URL(string: "http://localhost:1337/api/auth/local") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        // Configura el cuerpo de la solicitud con las credenciales del usuario
        let parameters: [String: Any] = [
            "identifier": identifier,
            "password": password
        ]
        
        // Serializa el cuerpo a JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            completion(.failure(NSError(domain: "Invalid JSON", code: 400, userInfo: nil)))
            return
        }
        
        // Configura la solicitud HTTP
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        // Realiza la solicitud
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "Invalid response", code: 400, userInfo: nil)))
                return
            }
            
            do {
                // Decodifica la respuesta JSON para obtener el token
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let jwt = json["jwt"] as? String {
                    completion(.success(jwt))
                } else {
                    completion(.failure(NSError(domain: "Invalid data", code: 400, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}