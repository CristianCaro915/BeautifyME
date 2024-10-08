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
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 120)
            .cornerRadius(10)
            .overlay(Rectangle().stroke(Color.gray, lineWidth: 2))
    }
}

#Preview {
    IconRectangleView(image: "salon_belleza1")
}
