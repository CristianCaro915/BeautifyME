//
//  FavouritesView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//

import SwiftUI

struct FavouritesView: View {
    var body: some View {
            NavigationView {
                VStack {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Lista de Cards
                            ForEach(0..<5) { _ in
                                BusinessCardView()
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle("Favorite Businesses")
            }
        }
}

struct BusinessCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Nombre del lugar y ubicación
            HStack {
                VStack(alignment: .leading) {
                    Text("Business Name")
                        .font(.headline)
                    
                    Text("Location")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Ícono de corazón
                Image(systemName: "heart.fill")
                    .foregroundColor(AppColors.orange)
            }
            
            // Descripción del negocio
            Text("This is a short description of the business, offering services that you love.")
                .font(.body)
                .foregroundColor(.gray)
            
            // Botón de reorder booking
            HStack {
                Spacer()
                Button(action: {
                    // Acción para reordenar el booking
                }) {
                    Text("Reorder Booking")
                        .padding()
                        .frame(minWidth: 150)
                        .background(AppColors.white)
                        .foregroundColor(AppColors.darkBlue)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColors.darkBlue, lineWidth: 1))
                }
            }
        }
        .padding()
        .background(AppColors.darkWhite)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    FavouritesView()
}
