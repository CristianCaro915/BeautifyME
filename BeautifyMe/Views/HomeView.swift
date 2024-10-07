//
//  HomeView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//

import SwiftUI

struct HomeView: View {
    let images6 = ["lock", "trash", "lock","pencil", "lock"]
    let images4 = ["lock", "lock", "lock","lock"]
    let textImages6: [String:String] =
    ["lock":"password","pencil":"password","rectangle":"password","pencil.tip":"password","lasso":"helloword","trash":"trashy"]
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 20) {
                // Header with user name
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Hello, Samantha")
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
                            ForEach(Array(textImages6.keys), id: \.self) { key in
                                if let value = textImages6[key] {
                                    IconTextView(image: key, title: value)
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
                            ForEach(images6, id: \.self) { image in
                                IconAloneView(image: image)
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
                            ForEach(images4, id: \.self) { image in
                                IconRectangleView(image: image)
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
                            ForEach(Array(textImages6.keys), id: \.self) { key in
                                if let value = textImages6[key] {
                                    IconTextView(image: key, title: value)
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
                            ForEach(images4, id: \.self) { image in
                                IconRectangleView(image: image)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                Spacer()
            }
            .padding(.top, 20)
            .background(Color(UIColor.systemBackground))
        }
    }
}

#Preview {
    HomeView()
}
