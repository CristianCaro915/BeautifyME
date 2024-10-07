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
    var price: String
    var duration: String
    var discount: String
    var description: String
    var iconButton: String
    
    var body: some View {
        HStack {
            // Imagen de la izquierda
            Image(systemName: imageName)
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(10)
            
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
                    Text(price)
                        .font(.subheadline)
                        .foregroundColor(AppColors.darkBlue)
                    Text("-")
                    Text(duration)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
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
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    ServiceCardView(imageName: "person.2", title: "Bob/ Lob Cut", price: "$55", duration: "1.5 hours", discount: "-20%", description: "Lob haircut is a women's hairstyle.", iconButton: "plus.circle")
}
