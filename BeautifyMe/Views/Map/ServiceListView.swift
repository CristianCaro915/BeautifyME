//
//  ServiceListView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//

import SwiftUI

struct ServiceListView: View {
    @EnvironmentObject var dataViewModel: DataViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Sección de iconos
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    // Services
                    ForEach(dataViewModel.services, id: \.self) { service in
                        IconTextView(imageURL: service.icon, title: service.name)
                            .accessibilityLabel(service.name) // Accesibilidad para el nombre del servicio
                            .accessibilityValue("Service icon") // Valor de accesibilidad para el icono
                    }
                }
                .padding(.horizontal)
            }
            
            // Sección de cards
            ScrollView {
                VStack {
                    ForEach(dataViewModel.services, id: \.self) { service in
                        ServiceCardView(
                            imageName: service.icon,
                            title: service.name,
                            price: service.price,
                            duration: "2 hours",
                            discount: "-20%",
                            description: service.description,
                            iconButton: "plus.circle"
                        )
                        .accessibilityLabel("\(service.name) - \(service.price)") // Etiqueta de accesibilidad para la tarjeta del servicio
                        .accessibilityValue("Duration: 2 hours, Discount: -20%") // Valor de accesibilidad para la tarjeta
                    }
                }
                .padding(.horizontal)
                
                // Sección de resumen y botón "Book Now"
                VStack(spacing: 16) {
                    Divider()
                    HStack {
                        Text("Total (1 Service)")
                            .font(.headline)
                            .accessibilityLabel("Total for selected service") // Etiqueta de accesibilidad para el total
                        Spacer()
                        Text("$40")
                            .font(.headline)
                            .foregroundColor(AppColors.darkBlue)
                            .accessibilityLabel("Total price") // Etiqueta de accesibilidad para el precio total
                        Text("$50")
                            .font(.headline)
                            .strikethrough(true, color: .red)
                            .foregroundColor(AppColors.darkBlue)
                            .accessibilityLabel("Original price") // Etiqueta de accesibilidad para el precio original
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        // Acción para "Book Now"
                    }) {
                        Text("Book Now")
                            .font(.headline)
                            .foregroundColor(AppColors.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppColors.darkBlue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .accessibilityLabel("Book Now") // Etiqueta de accesibilidad para el botón
                    .accessibilityValue("Tap to book the service") // Valor de accesibilidad para el botón
                }
                .padding(.bottom, 20)
            }
        }
        .padding(.top, 20)
        .background(Color(.white).ignoresSafeArea())
    }
}


#Preview {
    ServiceListView()
}
