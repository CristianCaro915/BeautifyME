//
//  ContentView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 9/09/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State private var isOnLoginScreen = true
    
    var body: some View {
        VStack {
            
            if sessionManager.isAuthenticated {
                Tabvar() // Auth
            } else {
                if isOnLoginScreen{
                    LogInView(isOnLoginScreen: $isOnLoginScreen) // No auth, login
                }
                else{
                    SignInView(isOnLoginScreen: $isOnLoginScreen) // No auth, signin
                }
                
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
