//
//  ContentView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 9/09/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    
    var body: some View {
        VStack {
            if sessionManager.isAuthenticated {
                Tabvar() // Vista que se muestra si el usuario está autenticado
            } else {
                LogInView() // Vista de login si el usuario no está autenticado
            }
        }
        .animation(.easeInOut, value: sessionManager.isAuthenticated)
        .transition(.slide)
    }
}

/*
#Preview {
    ContentView()
}
 */
