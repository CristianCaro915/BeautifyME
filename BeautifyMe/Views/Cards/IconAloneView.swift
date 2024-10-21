//
//  IconAloneView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 6/10/24.
//

import SwiftUI

struct IconAloneView: View {
    let image: String
    
    var body: some View {
        if let iconURL = URL(string: "http://localhost:1337"+image) {
            AsyncImage(url: iconURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            } placeholder: {
                ProgressView()
            }
        }
        
        Image(image)
            .resizable()
            
    }
}

#Preview {
    IconAloneView(image: "/uploads/chickens_beauty_logo_bc54d64d1c.jpeg")
}
