//
//  HeaderImageView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 25/10/24.
//

import SwiftUI

struct HeaderImageView: View {
    let imageURL: String?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if let iconURL = URL(string: "http://localhost:1337" + (imageURL ?? "")) {
                AsyncImage(url: iconURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
            }
        }
    }
}

#Preview {
    HeaderImageView(imageURL: "/uploads/thumbnail_spa_center1_a90222483a.jpeg")
}
