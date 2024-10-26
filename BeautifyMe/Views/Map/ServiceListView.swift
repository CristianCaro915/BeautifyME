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
                        // services
                        ForEach(dataViewModel.services, id: \.self) { service in
                            IconTextView(imageURL: service.icon, title: service.name)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Sección de cards
                ScrollView {
                    VStack() {
                        ForEach(dataViewModel.services, id: \.self) { service in
                            ServiceCardView(imageName: service.icon, title: service.name, price: service.price, duration: "2 hours", discount: "-20%", description: service.description, iconButton: "plus.circle")
                        }
                    }
                    .padding(.horizontal)
                    
                    // Sección de resumen y botón Book Now
                    VStack(spacing: 16) {
                        Divider()
                        HStack {
                            Text("Total (1 Service)")
                                .font(.headline)
                            Spacer()
                            Text("$40")
                                .font(.headline)
                                .foregroundColor(AppColors.darkBlue)
                            Text("$50")
                                .font(.headline)
                                .strikethrough(true, color: .red)
                                .foregroundColor(AppColors.darkBlue)
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
