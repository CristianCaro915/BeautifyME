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
        ScrollView{
            VStack(alignment: .leading, spacing: 20) {
                // Header with user name
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(sessionManager.user?.username ?? "User")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Find the service you want, and treat yourself")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    // Icon to search (button)
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.white)
                        .padding(5)
                        .background(AppColors.darkBlue)
                        .cornerRadius(20)
                }
                .padding(.horizontal)
                
                // Section 1: ¿what do you want to do?
                VStack(alignment: .leading, spacing: 16) {
                    Text("What do you want to do?")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    // Services
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            // services listed
                            ForEach(dataViewModel.services, id: \.self) { service in
                                IconTextView(imageURL: service.icon, title: service.name)
                                    .onTapGesture {
                                        // Almacena el negocio seleccionado
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
                    Text("Salon you follow")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    // Scroll of businesses
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            // businesses
                            ForEach(dataViewModel.businesses, id: \.self) { business in
                                IconAloneView(image: business.logo)
                                    .onTapGesture {
                                        // Almacena el negocio seleccionado
                                        sessionManager.businessSelected = business
                                        print("Servicio seleccionado: \(business.name)")
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                // Sección 3: Salones destacados
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Featured Salon")
                            .font(.headline)
                        Spacer()
                        Text("View all")
                            .font(.footnote)
                            .foregroundColor(AppColors.darkBlue)
                    }
                    .padding(.horizontal)
                    
                    // featured salon
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            // featured businesses
                            ForEach(dataViewModel.businesses, id: \.self) { business in
                                IconRectangleView(image: business.images[0])
                                    .onTapGesture {
                                        // Almacena el negocio seleccionado
                                        sessionManager.businessSelected = business
                                        print("Negocio seleccionado: \(business.name)")
                                        navigateBusinessDetail = true
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                // Section 4: most search interest
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Most search interests")
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Imágenes destacadas
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            // services
                            ForEach(dataViewModel.services, id: \.self) { service in
                                IconTextView(imageURL: service.icon, title: service.name)
                                    .onTapGesture {
                                        // Almacena el negocio seleccionado
                                        sessionManager.serviceSelected = service
                                        print("Servicio seleccionado: \(service.name)")
                                        navigateServiceSearch = true
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                // Section 5
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Nearby Offers")
                            .font(.headline)
                        Spacer()
                        Text("View all")
                            .font(.footnote)
                            .foregroundColor(AppColors.darkBlue)
                    }
                    .padding(.horizontal)
                    
                    // Imágenes destacadas
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            // salons
                            ForEach(dataViewModel.businesses, id: \.self) { business in
                                IconRectangleView(image: business.images[0])
                                    .onTapGesture {
                                        // Almacena el negocio seleccionado
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
            .background(Color(.white).ignoresSafeArea())
        }
        .background(Color(.white).ignoresSafeArea())
        .fullScreenCover(isPresented: $navigateBusinessDetail) {
            BusinessDetailedView() // This presents the BusinessDetailedView component in full-screen mode
        }
    }
}
/*
 #Preview {
 HomeView()
 }
 */
