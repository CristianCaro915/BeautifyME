//
//  MapView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 6/10/24.
//

import SwiftUI

struct MapView: View {
    @State private var appState = AppState.noInput
    
    var body: some View {
        ZStack(alignment:.bottom){
            ZStack(alignment: .top){
                // Map
                MapRepresentable(appState: $appState)
                
                if appState == .searchingForLocation{
                    LocationSearchView(appState: $appState)
                } else if appState == .noInput{
                    SearchBar()
                        .padding(.top, 60)
                        .onTapGesture{
                            withAnimation(.spring()){
                                appState = .searchingForLocation
                            }
                        }
                }
                
                OptionsButton(appState: $appState)
                    .padding(.leading)
                    .padding(.top,4)
                
            }
            
        }
    }
}

#Preview {
    MapView()
}
