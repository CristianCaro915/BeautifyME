//
//  LocationCell.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 6/10/24.
//
import SwiftUI

struct LocationCell: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack{
            Image(systemName: "building")
                .resizable()
                .foregroundColor(AppColors.darkBlue)
                .accentColor(AppColors.white)
                .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 4){
                Text(title)
                    .font(.body)
                Text(subtitle)
                    .font(.system(size: 15))
                    .foregroundColor(AppColors.mediumGrey)
                Divider()
            }
            .padding(.leading, 8)
            .padding(.vertical, 8)
        }
        .padding(.leading)
    }
}

#Preview {
    LocationCell(title: "starbucks", subtitle: "direction")
}
