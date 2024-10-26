//
//  BeautifyMeApp.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 9/09/24.
//

import SwiftUI

@main
struct BeautifyMeApp: App {
    init() {
        _locationViewModel = StateObject(wrappedValue: LocationSearchViewModel())
    }
    
    @StateObject var locationViewModel: LocationSearchViewModel
    @StateObject var sessionManager = SessionManager.shared
    @StateObject var dataViewModel = DataViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationViewModel)
                .environmentObject(sessionManager)
                .environmentObject(dataViewModel)
        }
    }
}
