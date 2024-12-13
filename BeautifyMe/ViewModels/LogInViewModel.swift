//
//  LogInViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 19/10/24.
//
import Foundation

class LogInViewModel: ObservableObject{
    private var sessionManager: SessionManager
    private(set) var jwtToken: String?
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isAuthenticated: Bool = false
    
    init(sessionManager: SessionManager = SessionManager.shared) {
            self.sessionManager = sessionManager
        }
        
        func updateToken() {
            self.sessionManager.jwtToken = self.jwtToken ?? ""
        }
        
        func authenticateUser() {
            guard !email.isEmpty else {
                return
            }
            
            guard !password.isEmpty else {
                return
            }
            
            authenticateUser(identifier: email, password: password) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let jwtToken):
                        print("Token JWT recibido: \(jwtToken)")
                        self?.jwtToken = jwtToken
                        self?.updateToken()
                        self?.isAuthenticated = true
                        self?.sessionManager.userMail = self?.email
                        self?.sessionManager.fetchUserIDByEmail()
                        self?.sessionManager.isAuthenticated = true
                        
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        self?.isAuthenticated = false
                    }
                }
            }
        }
        
        private func authenticateUser(identifier: String, password: String, completion: @escaping (Result<String, ErrorManager>) -> Void) {
            guard let url = URL(string: "http://localhost:1337/api/auth/local") else {
                completion(.failure(.invalidResponse))
                return
            }
            
            let parameters: [String: Any] = [
                "identifier": identifier,
                "password": password
            ]
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = httpBody
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    completion(.failure(.serverError))
                    return
                }
                
                guard let data = data,
                      let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                if httpResponse.statusCode == 400 {
                    completion(.failure(.invalidCredentials))
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let jwt = json["jwt"] as? String {
                        completion(.success(jwt))
                    } else {
                        completion(.failure(.invalidResponse))
                    }
                } catch {
                    completion(.failure(.invalidResponse))
                }
            }.resume()
        }
}
