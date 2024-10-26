//
//  ReviewCard.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 8/10/24.
//
import SwiftUI

struct ReviewCard: View {
    let imageURL: String
    let description: String
    let userName: String
    let rating: Int
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let iconURL = URL(string: "http://localhost:1337"+imageURL) {
                AsyncImage(url: iconURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(userName)
                        .font(.headline)
                    Spacer()
                    Text("1 week ago")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                }
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}


#Preview {
    ReviewCard(imageURL: "/uploads/maria_jose_profile_4ececaf718.jpeg", description: "best business ever", userName: "Michael Path",rating:5)
}
