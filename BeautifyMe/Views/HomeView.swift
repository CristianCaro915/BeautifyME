//
//  HomeView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//

import SwiftUI

struct HomeView: View {
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
                            // service 1
                            VStack{
                                Image(systemName: "lock")
                                    .font(.system(size: 40))
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                Text("New password")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            // service 2
                            VStack{
                                Image(systemName: "lock")
                                    .font(.system(size: 40))
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                Text("New password")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            // service 3
                            VStack{
                                Image(systemName: "lock")
                                    .font(.system(size: 40))
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                Text("New password")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            // service 4
                            VStack{
                                Image(systemName: "lock")
                                    .font(.system(size: 40))
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                Text("New password")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
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
                            // salon 1
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            
                            // salon 2
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            
                            // salon 3
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            
                            // salon 4
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            
                            // salon 5
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            
                            // salon 6
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
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
                    
                    // Imágenes destacadas
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            // salon 1
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 200, height: 120)
                                .cornerRadius(10)
                                .overlay(Rectangle().stroke(Color.gray, lineWidth: 2))
                            // salon 2
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 200, height: 120)
                                .cornerRadius(10)
                                .overlay(Rectangle().stroke(Color.gray, lineWidth: 2))
                            // salon 3
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 200, height: 120)
                                .cornerRadius(10)
                                .overlay(Rectangle().stroke(Color.gray, lineWidth: 2))
                            // salon 4
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 200, height: 120)
                                .cornerRadius(10)
                                .overlay(Rectangle().stroke(Color.gray, lineWidth: 2))
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
                            // service 1
                            VStack{
                                Image(systemName: "lock")
                                    .font(.system(size: 40))
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                Text("New password")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            // service 2
                            VStack{
                                Image(systemName: "lock")
                                    .font(.system(size: 40))
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                Text("New password")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            // service 3
                            VStack{
                                Image(systemName: "lock")
                                    .font(.system(size: 40))
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                Text("New password")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            // service 4
                            VStack{
                                Image(systemName: "lock")
                                    .font(.system(size: 40))
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                Text("New password")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
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
                            // salon 1
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 200, height: 120)
                                .cornerRadius(10)
                                .overlay(Rectangle().stroke(Color.gray, lineWidth: 2))
                            // salon 2
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 200, height: 120)
                                .cornerRadius(10)
                                .overlay(Rectangle().stroke(Color.gray, lineWidth: 2))
                            // salon 3
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 200, height: 120)
                                .cornerRadius(10)
                                .overlay(Rectangle().stroke(Color.gray, lineWidth: 2))
                            // salon 4
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 200, height: 120)
                                .cornerRadius(10)
                                .overlay(Rectangle().stroke(Color.gray, lineWidth: 2))
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
