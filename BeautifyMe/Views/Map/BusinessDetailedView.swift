//
//  BusinessDetailedView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 8/10/24.
//

import SwiftUI

struct BusinessDetailedView: View {
    @StateObject private var businessDetailedViewModel = BusinessDetailViewModel()
    
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var dataViewModel: DataViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Imagen del negocio
                ZStack(alignment: .topLeading) {
                    if let iconURL = URL(string: "http://localhost:1337" + (businessDetailedViewModel.currentBusiness?.images.first ?? "")) {
                        AsyncImage(url: iconURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .accessibilityLabel(Text("Business image"))
                                .accessibilityValue(Text(businessDetailedViewModel.currentBusiness?.name ?? "Business image"))
                        } placeholder: {
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .accessibilityLabel(Text("Loading business image"))
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Información del negocio
                BusinessInfoView(
                    name: businessDetailedViewModel.currentBusiness?.name ?? "Business Name",
                    address: "122 Riverside Rd. Eacho City, NY 34856",
                    isOpen: true,
                    rating: 4,
                    reviewsCount: 2,
                    viewsCount: 10
                )
                .accessibilityElement(children: .combine)
                .accessibilityLabel(Text("Business Information"))
                .accessibilityValue(Text("\(businessDetailedViewModel.currentBusiness?.name ?? "Business Name"), Address: 122 Riverside Rd. Eacho City, NY 34856, Rating: 4 stars"))

                // Horario de apertura
                OpeningHoursView()
                    .accessibilityLabel(Text("Opening hours"))
                
                // Lista de servicios
                BusinessServiceListView(services: businessDetailedViewModel.servicesBusiness)
                    .accessibilityLabel(Text("Services offered by the business"))
                
                // Galería
                GalleryView(images: businessDetailedViewModel.currentBusiness?.gallery ?? [])
                    .accessibilityLabel(Text("Business gallery"))

                // Especialistas
                SpecialistsView(specialists: businessDetailedViewModel.employeesBusiness)
                    .accessibilityLabel(Text("Business specialists"))

                // Reseñas del negocio
                BusinessReviewsView(reviews: businessDetailedViewModel.commentsBusiness)
                    .accessibilityLabel(Text("Customer reviews"))
            }
            .padding()
        }
        .background(AppColors.white.ignoresSafeArea())
        .edgesIgnoringSafeArea(.top)

        }
}
/*
#Preview {
    BusinessDetailedView()
}
*/
