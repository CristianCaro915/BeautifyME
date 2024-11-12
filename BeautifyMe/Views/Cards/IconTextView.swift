//
//  IconTextView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 6/10/24.
//

import SwiftUI

struct IconTextView: View {
    let imageURL: String
    let title: String
    
    var body: some View {
        VStack{
            if let iconURL = URL(string: "http://localhost:1337"+imageURL) {
                AsyncImage(url: iconURL) { image in
                    image.resizable()
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .background(AppColors.mediumGrey.opacity(0.2))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(AppColors.mediumGrey, lineWidth: 2))
                } placeholder: {
                    ProgressView()
                }
            }
                
            Text(title)
                .font(.footnote)
                .foregroundColor(AppColors.mediumGrey)
                .frame(maxWidth: 80) // Ajusta este valor según lo necesites
                .lineLimit(2) // Limita el texto a un máximo de 2 líneas
                .truncationMode(.tail) // Agrega "..." si el texto es demasiado largo
        }
    }
}

#Preview {
    IconTextView(imageURL: "/uploads/barber_service_6c2bcb6a56.jpeg", title: "Barber Standart")
}
