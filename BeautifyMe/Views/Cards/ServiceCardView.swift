//
//  ServiceCardView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 6/10/24.
//

import SwiftUI

struct ServiceCardView: View {
    var imageName: String
    var title: String
    var price: Int
    var duration: String
    var discount: String
    var description: String
    var iconButton: String
    
    var body: some View {
        HStack {
            // Imagen de la izquierda
            if let iconURL = URL(string: "http://localhost:1337"+imageName) {
                AsyncImage(url: iconURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 100)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
            }
            
            // Información del servicio
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(title)
                        .font(.headline)
                    if !discount.isEmpty {
                        Spacer()
                        Image(systemName: "lock")
                            .foregroundColor(AppColors.orange)
                        Text(discount)
                            .font(.caption)
                            .foregroundColor(AppColors.orange)
                    }
                }
                HStack{
                    Text("$\(price)")
                        .font(.subheadline)
                        .foregroundColor(AppColors.darkBlue)
                    Text("-")
                    Text(duration)
                        .font(.subheadline)
                        .foregroundColor(AppColors.mediumGrey)
                }
                
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(AppColors.mediumGrey)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Botón de acción (icono)
            Button(action: {
                // Acción para el botón
            }) {
                Image(systemName: iconButton)
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.white)
                    .background(AppColors.darkBlue)
                    .cornerRadius(20)
            }
        }
        .padding()
        .background(AppColors.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    ServiceCardView(imageName: "/uploads/barber_service_6c2bcb6a56.jpeg", title: "Bob/ Lob Cut", price: 2000, duration: "1.5 hours", discount: "-20%", description: "Lob haircut is a women's hairstyle.", iconButton: "plus.circle")
}
