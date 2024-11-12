//
//  IconRectangleView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 6/10/24.
//

import SwiftUI

struct IconRectangleView: View {
    let image: String
    
    var body: some View {
        if let iconURL = URL(string: "http://localhost:1337"+image) {
            AsyncImage(url: iconURL) { image in
                image.resizable()
                    .resizable()
                    .frame(width: 200, height: 140)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .overlay(Rectangle().stroke(AppColors.mediumGrey, lineWidth: 2))
            } placeholder: {
                ProgressView()
            }
        }
    }
}

#Preview {
    IconRectangleView(image: "/uploads/spa_center1_a90222483a.jpeg")
}
