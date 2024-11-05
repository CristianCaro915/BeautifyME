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
                .accessibilityLabel(Text("Business Name"))
                .accessibilityValue(Text(name))
            
            Text(address)
                .foregroundColor(.gray)
                .accessibilityLabel(Text("Business Address"))
                .accessibilityValue(Text(address))
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(AppColors.darkBlue)
                    .accessibilityHidden(true) // No relevante para accesibilidad, ya que el texto "Open Today" o "Closed" lo describe
                
                Text(isOpen ? "Open Today" : "Closed")
                    .padding(6)
                    .background(isOpen ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .foregroundColor(AppColors.darkBlue)
                    .cornerRadius(4)
                    .accessibilityLabel(Text("Business Status"))
                    .accessibilityValue(Text(isOpen ? "Open Today" : "Closed"))
                
                Text("-58% (6 pax available)")
                    .foregroundColor(AppColors.darkBlue)
                    .padding(.horizontal, 20)
                    .accessibilityLabel(Text("Discount and Availability"))
                    .accessibilityValue(Text("-58% discount, 6 places available"))
            }
            
            HStack {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(AppColors.orange)
                        .accessibilityHidden(true)
                    
                    Text("\(rating, specifier: "%.1f") (\(reviewsCount)k)")
                        .accessibilityLabel(Text("Rating"))
                        .accessibilityValue(Text("\(rating, specifier: "%.1f") stars, \(reviewsCount) thousand reviews"))
                }
                
                Spacer()
                
                HStack {
                    Image(systemName: "eye")
                        .foregroundColor(AppColors.mediumGrey)
                        .accessibilityHidden(true)
                    
                    Text("\(viewsCount)k views")
                        .accessibilityLabel(Text("Views"))
                        .accessibilityValue(Text("\(viewsCount) thousand views"))
                }
                .padding(.horizontal, 50)
                
                Spacer()
            }
        }
        .accessibilityElement(children: .combine) // Combina los elementos para que se lean como un solo bloque en VoiceOver

    }
}


#Preview {
    BusinessInfoView(name: "Business 1", address: "122 Riverside Rd. Eacho City, NY 34856",isOpen: true, rating: 5,reviewsCount: 4, viewsCount: 2)
}
