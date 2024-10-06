//
//  ServiceListView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//

import SwiftUI

struct ServiceListView: View {
    var body: some View {
            VStack(spacing: 20) {
                // Sección de iconos
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 16) {
                        // service 1
                        VStack{
                            Image(systemName: "lock")
                                .font(.system(size: 40))
                                .frame(width: 60, height: 60)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                            Text("New password")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        // service 2
                        VStack{
                            Image(systemName: "lock")
                                .font(.system(size: 40))
                                .frame(width: 60, height: 60)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                            Text("New password")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        // service 3
                        VStack{
                            Image(systemName: "lock")
                                .font(.system(size: 40))
                                .frame(width: 60, height: 60)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                            Text("New password")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        // service 4
                        VStack{
                            Image(systemName: "lock")
                                .font(.system(size: 40))
                                .frame(width: 60, height: 60)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                            Text("New password")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        // service 5
                        VStack{
                            Image(systemName: "lock")
                                .font(.system(size: 40))
                                .frame(width: 60, height: 60)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                            Text("New password")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Sección de cards
                ScrollView {
                    VStack(spacing: 16) {
                        ServiceCardView(imageName: "person", title: "Woman Blunt Cut", price: "$50", duration: "2 hours", discount: "-20%", description: "A blunt cut bob is a shorter hairstyle.", iconButton: "plus.circle")
                        
                        ServiceCardView(imageName: "person.2", title: "Bob/ Lob Cut", price: "$55", duration: "1.5 hours", discount: "-20%", description: "Lob haircut is a women's hairstyle.", iconButton: "plus.circle")
                        
                        ServiceCardView(imageName: "person.3", title: "Medium Length Layer Cut", price: "$80", duration: "1 hour", discount: "", description: "Layered hair is a hairstyle that gives the illusion.", iconButton: "plus.circle")
                        
                        ServiceCardView(imageName: "person.4", title: "V-Shaped Cut", price: "$90", duration: "2.5 hours", discount: "-5%", description: "There are a lot of variations between v-shaped.", iconButton: "plus.circle")
                    }
                    .padding(.horizontal)
                    
                    // Sección de resumen y botón Book Now
                    VStack(spacing: 16) {
                        Divider()
                        HStack {
                            Text("Total (1 Service)")
                                .font(.headline)
                            Spacer()
                            Text("$40 $10")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            // Acción para "Book Now"
                        }) {
                            Text("Book Now")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                }
            }
            .padding(.top, 20)
            .background(Color(UIColor.systemBackground))
        }
}

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
                        Text(discount)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                
                Text(price)
                    .font(.subheadline)
                    .foregroundColor(.green)
                
                Text(duration)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
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
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}


#Preview {
    ServiceListView()
}
