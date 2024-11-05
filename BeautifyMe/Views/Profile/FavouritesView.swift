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
                        ForEach(0..<5) { index in
                            BusinessCardView()
                                .accessibilityElement(children: .contain)
                                .accessibilityLabel("Business Card \(index + 1)")
                                .accessibilityHint("Displays details about a favorite business")
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Favorite Businesses")
            .accessibilityLabel("Favorite Businesses")
            .accessibilityHint("List of your favorite businesses")
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
                        .accessibilityLabel("Business Name")
                        .accessibilityValue("Business Name Placeholder")
                    
                    Text("Location")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .accessibilityLabel("Location")
                        .accessibilityValue("Location Placeholder")
                }
                
                Spacer()
                
                // Ícono de corazón
                Image(systemName: "heart.fill")
                    .foregroundColor(AppColors.orange)
                    .accessibilityLabel("Favorite Icon")
                    .accessibilityHint("Indicates this is a favorite business")
            }
            
            // Descripción del negocio
            Text("This is a short description of the business, offering services that you love.")
                .font(.body)
                .foregroundColor(.gray)
                .accessibilityLabel("Description")
                .accessibilityValue("Short description of the business")
            
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
                .accessibilityLabel("Reorder Booking Button")
                .accessibilityHint("Tap to reorder booking")
            }
        }
        .padding()
        .background(Color(.white).ignoresSafeArea())
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}


#Preview {
    FavouritesView()
}
