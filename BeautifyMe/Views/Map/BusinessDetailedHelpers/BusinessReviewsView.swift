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
                Spacer()
                Button("View all") {
                    // Acción
                }
                .foregroundColor(AppColors.darkBlue)
            }
            .padding()
            
            ForEach(reviews, id: \.self) { review in
                ReviewCard(
                    imageURL: review.commenterImage,
                    description: review.description,
                    userName: review.commenterName,
                    rating: review.rating
                )
            }
        }
    }
}

/**
#Preview {
    BusinessReviewsView()
}
 */
