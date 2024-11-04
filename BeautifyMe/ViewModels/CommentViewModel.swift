//
//  CommentViewModel.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 25/10/24.
//

import Foundation
import Combine

class CommentViewModel: ObservableObject{
    private var sessionManager: SessionManager
    private var dataViewModel: DataViewModel
    private var cancellables = Set<AnyCancellable>()
    
    @Published var user: User?
    @Published var comments: [Comment] = []
    
    init(sessionManager: SessionManager = SessionManager.shared, dataViewModel: DataViewModel = DataViewModel.shared) {
        self.sessionManager = sessionManager
        self.dataViewModel = dataViewModel
        
        updateDataFromAPI()
    }
    
    func updateDataFromAPI(){
        self.dataViewModel.$comments
            .sink { [weak self] comments in
                self?.comments = comments
                print(self?.comments)
            }
            .store(in: &cancellables)
        
        self.sessionManager.$user
            .sink { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)
    }
    func getComment(by id: Int) -> Comment{
        var rta = Comment(id: 99, description: "", rating: 1, commenterName: "", commenterImage: "")
        // Check the ID existance
        if !self.comments.contains(where: { $0.id == id }){
            print("The comment with the given id was not found")
            return rta
        }
        // get comment
        for comment in self.comments{
            if comment.id == id{
                rta = comment
                break
            }
        }
        return rta
    }
    
    func createComment(comment: Comment, businessId: Int, completion: @escaping (Result<Comment, Error>) -> Void) {
        //print("comment being cooked")
        guard let url = URL(string: "http://localhost:1337/api/comments") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "data": [
                "description": comment.description,
                "ranking": comment.rating,
                "user": [
                    "data": [
                        "id": self.user?.id
                    ]
                ],
                "business": [
                    "data": [
                        "id": businessId
                    ]
                ]
            ]
        ]
        //print(parameters)
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No se recibió data"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode([String: Comment].self, from: data)
                if let createdComment = responseData["data"] {
                    completion(.success(createdComment))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Comentario no encontrado en la respuesta"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    func addCommentRelations(commentId: Int, userId: Int, businessId: Int) -> AnyPublisher<Bool, Error> {
        // Endpoint
        guard let url = URL(string: "http://localhost:1337/api/comments/\(commentId)") else {
            fatalError("URL no válida")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "data": [
                "user": [
                    "connect": [
                        ["id": userId]
                    ]
                ],
                "business": [
                    "connect":[
                        ["id": businessId]
                    ]
                ]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Bool in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return true // good
            }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func deleteComment(commentId: Int) {
        // Check the ID existence
        print("AAA: ", self.comments.contains(where: { $0.id == commentId }))
        if !self.comments.contains(where: { $0.id == commentId }) {
            print("The comment with the given id was not found")
            return
        }
        
        // Build the URL and request after confirming comment exists
        guard let url = URL(string: "http://localhost:1337/api/comments/\(commentId)") else {
            print("URL inválida")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data in
                // Check if the response is empty
                if data.isEmpty {
                    throw NSError(domain: "APIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No se recibió respuesta del servidor."])
                }
                return data
            }
            //.decode(type: [String: Comment].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Comentario borrado con éxito.")
                case .failure(let error):
                    print("Error al borrar el comentario: \(error)")
                }
            }, receiveValue: { response in
                // Handle the response if necessary
                print("Respuesta del servidor: \(response)")
            })
            .store(in: &cancellables)
    }
    
    func updateComment(commentId: Int, newDescription: String?, newRanking: Int?) -> AnyPublisher<Void, Error> {
        // Endpoint
        guard let url = URL(string: "http://localhost:1337/api/comments/\(commentId)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var commentData: [String: Any] = [:]
        if let description = newDescription {
            commentData["description"] = description
        }
        if let ranking = newRanking {
            commentData["ranking"] = ranking
        }
        
        let requestBody: [String: Any] = ["data": commentData]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
            return Fail(error: URLError(.cannotParseResponse)).eraseToAnyPublisher()
        }
        
        // Configure query
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                // Valid response
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func updateCommentRelations(commentId: Int, userId: Int, businessId: Int) {
            let body: [String: Any] = [
                "data": [
                    "user": [
                        "set": [
                            ["id": userId]
                        ]
                    ],
                    "business": [
                        "set": [
                            ["id": businessId]
                        ]
                    ]
                ]
            ]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
                print("Error al serializar el cuerpo en JSON")
                return
            }

            guard let url = URL(string: "http://localhost:1337/api/comments/\(commentId)") else {
                print("URL inválida")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { response -> Data in
                    // Verificar el código de estado HTTP
                    guard let httpResponse = response.response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        throw URLError(.badServerResponse) // Error for weird error like 500
                    }
                    return response.data
                }
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Relaciones actualizadas con éxito.")
                    case .failure(let error):
                        print("Error al actualizar las relaciones: \(error.localizedDescription)")
                    }
                }, receiveValue: { data in
                    // Show server response to updated instance
                    print("Respuesta recibida: \(String(data: data, encoding: .utf8) ?? "No se recibió respuesta")")
                })
                .store(in: &cancellables)
        }
    
}
