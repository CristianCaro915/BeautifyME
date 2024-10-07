//
//  SearchBar.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 6/10/24.
//
import SwiftUI

struct SearchBar: View {
    var body: some View {
        HStack{
            Rectangle()
                .fill(AppColors.darkBlue)
                .frame(width: 8, height: 8)
                .padding(.horizontal)
                .cornerRadius(20)
            Text("Seach a business")
                .foregroundColor(Color(.darkGray))
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 90, height: 50)
        .background(
            Rectangle()
                .fill(Color.white)
                .cornerRadius(15)
                .overlay(
                        RoundedRectangle(cornerRadius: 20) // Match the corner radius with the fill
                            .stroke(AppColors.darkBlue, lineWidth: 2) // Apply stroke as overlay
                    )
//                .shadow(color: .black,radius: 6)
        )
    }
}

#Preview {
    SearchBar()
}
