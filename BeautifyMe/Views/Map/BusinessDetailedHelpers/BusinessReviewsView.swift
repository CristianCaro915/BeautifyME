//
//  BusinessReviewsView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 25/10/24.
//

import SwiftUI

struct BusinessReviewsView: View {
    let reviews: [Comment]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Reviews")
                    .font(.title2)
                    .fontWeight(.bold)
                    .accessibilityLabel(Text("Section Title"))
                    .accessibilityValue(Text("Reviews"))

                Spacer()

                Button("View all") {
                    // Acción
                }
                .foregroundColor(AppColors.darkBlue)
                .accessibilityLabel(Text("View all reviews"))
            }
            .padding()
            
            ForEach(reviews, id: \.self) { review in
                ReviewCard(
                    imageURL: review.commenterImage,
                    description: review.description,
                    userName: review.commenterName,
                    rating: review.rating
                )
                .accessibilityElement(children: .combine) // Combina elementos de la tarjeta para accesibilidad
                .accessibilityLabel(Text("Review by \(review.commenterName)"))
                .accessibilityValue(Text("Rating: \(review.rating, specifier: "%.1f") stars. Comment: \(review.description)"))
            }
        }

    }
}

/**
#Preview {
    BusinessReviewsView()
}
 */
