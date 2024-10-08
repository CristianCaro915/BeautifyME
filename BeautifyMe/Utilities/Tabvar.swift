//
//  Tabvar.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//
import Foundation
import SwiftUI

enum Tab: Hashable {
    case home
    case services
    case activity
    case account
}

struct Tabvar: View {
    @State private var selectedTab: Tab

    init(startingTab: Tab = .home) {
        _selectedTab = State(initialValue: startingTab)
        UITabBar.appearance().barTintColor = UIColor.white // Set the tab bar's background color to white

    }

    var body: some View {
        TabView(selection: $selectedTab) {
            
            HomeView()
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            .tag(Tab.home) // Tag this view with the corresponding enum value
            
            //MapView
            MapView()
            .tabItem {
                Image(systemName: "circle.grid.3x3.fill")
                Text("Services")
            }
            .tag(Tab.services)
            
            //Calendar
            HomeView()
            .tabItem {
                Image(systemName: "calendar")
                Text("Calendar")
            }
            .tag(Tab.activity)
            
            ProfileView()
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(Tab.account)
        }
        .accentColor(AppColors.darkBlue)
        
    }
}

#Preview {
    Tabvar()
}
