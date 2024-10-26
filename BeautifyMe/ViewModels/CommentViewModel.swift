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
        print("comment being cooked")
        guard let url = URL(string: "http://localhost:1337/api/comments") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Aquí creamos un diccionario con los datos necesarios para el comentario
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
        print(parameters)
        
        do {
            // Convertimos el diccionario a JSON
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
                // Decodificamos la respuesta en el mismo formato que tienes en tu estructura
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
    
    
    func deleteComment(commentId: Int) {
        // Check the ID existance
        if !self.comments.contains(where: { $0.id == commentId }){
            print("The comment with the given id was not found")
            return
            
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
                    // Comprobar si la respuesta es null
                    if data.isEmpty {
                        throw NSError(domain: "APIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No se recibió respuesta del servidor."])
                    }
                    return data
                }
                .decode(type: [String: Comment].self, decoder: JSONDecoder())
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Comentario borrado con éxito.")
                    case .failure(let error):
                        print("Error al borrar el comentario: \(error)")
                    }
                }, receiveValue: { response in
                    // Manejo de la respuesta si es necesario
                    print("Respuesta del servidor: \(response)")
                })
                .store(in: &cancellables)
        }
        
        
    }
}
