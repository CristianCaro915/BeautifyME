//
//  SessionManager.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 19/10/24.
//
import SwiftUI

class SessionManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var user: User?
    @Published var userMail: String?
    @Published var userID: Int?
    @Published var users: [User] = []
    
    static let shared = SessionManager()
    
    //singleton
    private init() {}
    
    func loginUser(){
        self.isAuthenticated = true
    }
    
    func logoutUser() {
        self.isAuthenticated = false
    }
    
    func fetchUserIDByEmail() {
        guard let email = userMail else {
            print("No hay email disponible.")
            return
        }
        
        let urlString = "http://localhost:1337/api/users"
        guard let url = URL(string: urlString) else {
            print("URL no válida.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Realiza la solicitud a la API
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
                // Analiza la respuesta como un array de diccionarios
                if let users = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    // Busca el usuario con el email correspondiente
                    for user in users {
                        if let userEmail = user["email"] as? String, userEmail == email,
                           let userID = user["id"] as? Int {
                            DispatchQueue.main.async {
                                self?.userID = userID // Guarda el ID del usuario
                                //print("ID del usuario encontrado: \(userID)")
                                self?.fetchUsers()
                            }
                            return
                        }
                    }
                    print("No se encontró un usuario con el email: \(email)")
                }
            } catch {
                print("Error decodificando los datos: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func fetchUsers() {
            let urlString = "http://localhost:1337/api/users?populate[profile_photo][fields]=url&fields[0]=id&fields[1]=username&fields[2]=email&populate[role][fields]=name"
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
                                      let roleDict = dict["role"] as? [String: Any],
                                      let roleName = roleDict["name"] as? String,
                                      let profilePhoto = dict["profile_photo"] as? [String: Any],
                                      let imageUrl = profilePhoto["url"] as? String else {
                                    return nil
                                }
                                // Crear el objeto User
                                return User(id: id, username: username, email: email, role: roleName, imageURL: imageUrl)
                            }
                            self?.searchUser()
                        }
                    }
                    
                    
                } catch {
                    print("Error decodificando los datos: \(error.localizedDescription)")
                }
            }.resume()
        }
    
    func searchUser(){
        for user in self.users {
            if user.id == self.userID {
                self.user = user
                //print("User hallado")
                //print(self.user)
                break // Sale del bucle una vez que se encuentra el usuario
            }
        }
    }
}
