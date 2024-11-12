//
//  HomeView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//

import SwiftUI

struct HomeView: View {
    @State private var navigateBusinessDetail = false
    @State private var navigateServiceSearch = false
    
    @EnvironmentObject var dataViewModel: DataViewModel
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with user name
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(sessionManager.user?.username ?? "User")
                            .font(.title)
                            .fontWeight(.bold)
                            .accessibilityLabel(Text("Username"))
                            .accessibilityValue(Text(sessionManager.user?.username ?? "User"))
                        
                        Text("Find the service you want, and treat yourself")
                            .font(.subheadline)
                            .foregroundColor(AppColors.mediumGrey)
                            .accessibilityLabel(Text("User description"))
                            .accessibilityValue(Text("Find the service you want, and treat yourself"))
                    }
                    Spacer()
                    // Icon to search (button)
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.white)
                        .padding(5)
                        .background(AppColors.darkBlue)
                        .cornerRadius(20)
                        .accessibilityLabel(Text("Search"))
                        .accessibilityValue(Text("Tap to search for services"))
                }
                .padding(.horizontal)
                
                // Section 1: What do you want to do?
                VStack(alignment: .leading, spacing: 16) {
                    Text("What do you want to do?")
                        .font(.headline)
                        .padding(.horizontal)
                        .accessibilityLabel(Text("What do you want to do section"))
                    
                    // Services
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            // services listed
                            ForEach(dataViewModel.services, id: \.self) { service in
                                IconTextView(imageURL: service.icon, title: service.name)
                                    .accessibilityLabel(Text(service.name))
                                    .accessibilityValue(Text("Service available"))
                                    .onTapGesture {
                                        // Store the selected service
                                        sessionManager.serviceSelected = service
                                        print("Servicio seleccionado: \(service.name)")
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Section 2: Businesses you follow
                VStack(alignment: .leading, spacing: 16) {
                    Text("Businesses you follow")
                        .font(.headline)
                        .padding(.horizontal)
                        .accessibilityLabel(Text("Businesses you follow section"))
                    
                    // Scroll of businesses
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            // businesses
                            ForEach(dataViewModel.businesses, id: \.self) { business in
                                IconAloneView(image: business.logo)
                                    .accessibilityLabel(Text(business.name))
                                    .accessibilityValue(Text("Followed business"))
                                    .onTapGesture {
                                        // Store the selected business
                                        sessionManager.businessSelected = business
                                        print("Servicio seleccionado: \(business.name)")
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Section 3: Featured Salons
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Featured Salons")
                            .font(.headline)
                            .accessibilityLabel(Text("Featured Salons section"))
                        Spacer()
                        Text("View all")
                            .font(.footnote)
                            .foregroundColor(AppColors.darkBlue)
                            .accessibilityLabel(Text("View all featured salons"))
                    }
                    .padding(.horizontal)
                    
                    // featured salon
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            // featured businesses
                            ForEach(dataViewModel.businesses, id: \.self) { business in
                                IconRectangleView(image: business.images[0])
                                    .accessibilityLabel(Text(business.name))
                                    .accessibilityValue(Text("Featured business"))
                                    .onTapGesture {
                                        // Store the selected business
                                        sessionManager.businessSelected = business
                                        print("Negocio seleccionado: \(business.name)")
                                        navigateBusinessDetail = true
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Section 4: Most searched interests
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Most searched interests")
                            .font(.headline)
                            .accessibilityLabel(Text("Most searched interests section"))
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Highlighted images
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            // services
                            ForEach(dataViewModel.services, id: \.self) { service in
                                IconTextView(imageURL: service.icon, title: service.name)
                                    .accessibilityLabel(Text(service.name))
                                    .accessibilityValue(Text("Service available"))
                                    .onTapGesture {
                                        // Store the selected service
                                        sessionManager.serviceSelected = service
                                        print("Servicio seleccionado: \(service.name)")
                                        navigateServiceSearch = true
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Section 5: Nearby Offers
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Nearby Offers")
                            .font(.headline)
                            .accessibilityLabel(Text("Nearby Offers section"))
                        Spacer()
                        Text("View all")
                            .font(.footnote)
                            .foregroundColor(AppColors.darkBlue)
                            .accessibilityLabel(Text("View all nearby offers"))
                    }
                    .padding(.horizontal)
                    
                    // Highlighted images
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            // salons
                            ForEach(dataViewModel.businesses, id: \.self) { business in
                                IconRectangleView(image: business.images[0])
                                    .accessibilityLabel(Text(business.name))
                                    .accessibilityValue(Text("Nearby offer"))
                                    .onTapGesture {
                                        // Store the selected business
                                        sessionManager.businessSelected = business
                                        print("Negocio seleccionado: \(business.name)")
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                Spacer()
            }
            .padding(.top, 20)
            .background(AppColors.white.ignoresSafeArea())
        }
        .background(AppColors.white.ignoresSafeArea())
        .fullScreenCover(isPresented: $navigateBusinessDetail) {
            BusinessDetailedView() // Present the BusinessDetailedView component in full-screen mode
        }

    }
}
/*
 #Preview {
 HomeView()
 }
 */
