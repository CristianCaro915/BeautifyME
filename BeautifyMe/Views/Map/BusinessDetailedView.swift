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
                    
                    ZStack(alignment: .topLeading) {
                        if let iconURL = URL(string: "http://localhost:1337" + (businessDetailedViewModel.currentBusiness?.images.first ?? "")) {
                                AsyncImage(url: iconURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill() // Asegúrate de que la imagen llene el espacio
                                        //.clipped() // Recorta cualquier parte que sobresalga
                                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ocupa todo el espacio disponible
                                } placeholder: {
                                    ProgressView()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Asegúrate de que el placeholder también ocupe todo el espacio
                                }
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    
                    BusinessInfoView(
                        name: businessDetailedViewModel.currentBusiness?.name ?? "Business Name",
                        address: "122 Riverside Rd. Eacho City, NY 34856",
                        isOpen: true,
                        rating: 4,
                        reviewsCount: 2,
                        viewsCount: 10
                    )
                    
                    OpeningHoursView()
                    
                    BusinessServiceListView(services: businessDetailedViewModel.servicesBusiness)
                    
                    GalleryView(images: businessDetailedViewModel.currentBusiness?.gallery ?? [])
                    
                    SpecialistsView(specialists: businessDetailedViewModel.employeesBusiness)
                    
                    BusinessReviewsView(reviews: businessDetailedViewModel.commentsBusiness)
                }
                .padding()
            }
            .background(Color(.white).ignoresSafeArea())
            .edgesIgnoringSafeArea(.top)
        }
}
/*
#Preview {
    BusinessDetailedView()
}
*/
