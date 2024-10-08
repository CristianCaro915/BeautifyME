//
//  IconTextView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 6/10/24.
//

import SwiftUI

struct IconTextView: View {
    let image: String
    let title: String
    
    var body: some View {
        VStack{
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.2))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            Text(title)
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    IconTextView(image: "barber_service", title: "barber")
}
