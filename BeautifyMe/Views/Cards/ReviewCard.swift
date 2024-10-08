//
//  ReviewCard.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 8/10/24.
//
import SwiftUI

struct ReviewCard: View {
    let review: Review
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(review.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(review.name)
                        .font(.headline)
                    Spacer()
                    Text(review.timeAgo)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= review.rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                }
                
                Text(review.comment)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}


#Preview {
    ReviewCard(review: Review(name: "Tomas Whang", image: "tomas_montaña", rating: 4, timeAgo: "2 days ago", comment: "The place was clean, great serivce, staff are friendly. I will certainly recommend to my friends and visit again! :)"))
}
