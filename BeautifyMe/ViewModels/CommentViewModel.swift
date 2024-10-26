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
    }
    func getComment(id: Int){
        
    }
    
    func createComment(business: Business){
        
    }
    func deleteComment(id: Int){
        
    }
}
