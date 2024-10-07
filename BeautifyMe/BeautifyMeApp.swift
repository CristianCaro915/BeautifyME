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
    
    
    var body: some Scene {
        WindowGroup {
            MapView()
                .environmentObject(locationViewModel)
        }
    }
}
