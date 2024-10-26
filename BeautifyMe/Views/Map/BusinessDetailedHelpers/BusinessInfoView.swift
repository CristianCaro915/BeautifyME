//
//  BusinessInfoView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 25/10/24.
//

import SwiftUI

struct BusinessInfoView: View {
    let name: String
    let address: String
    let isOpen: Bool
    let rating: Double
    let reviewsCount: Int
    let viewsCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .font(.title)
                .fontWeight(.bold)
            Text(address)
                .foregroundColor(.gray)
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(AppColors.darkBlue)
                Text(isOpen ? "Open Today" : "Closed")
                    .padding(6)
                    .background(isOpen ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .foregroundColor(AppColors.darkBlue)
                    .cornerRadius(4)
                
                Text("-58% (6 pax available)")
                    .foregroundColor(AppColors.darkBlue)
                    .padding(.horizontal, 20)
            }
            
            HStack {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(AppColors.orange)
                    Text("\(rating, specifier: "%.1f") (\(reviewsCount)k)")
                }
                Spacer()
                HStack {
                    Image(systemName: "eye")
                        .foregroundColor(AppColors.mediumGrey)
                    Text("\(viewsCount)k views")
                }
                .padding(.horizontal, 50)
                Spacer()
            }
        }
    }
}


#Preview {
    BusinessInfoView(name: "Business 1", address: "122 Riverside Rd. Eacho City, NY 34856",isOpen: true, rating: 5,reviewsCount: 4, viewsCount: 2)
}
