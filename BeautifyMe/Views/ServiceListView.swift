//
//  ServiceListView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//

import SwiftUI

struct ServiceListView: View {
    let services: [String:String] =
    ["barber_service":"barber","hair_cut_woman_service":"hair cut","manicure_service":"manicure","spa_service":"spa","pedicire_logo":"pedicure"]
    
    var body: some View {
            VStack(spacing: 20) {
                // Sección de iconos
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 16) {
                        // services
                        ForEach(Array(services.keys), id: \.self) { key in
                            if let value = services[key] {
                                IconTextView(image: key, title: value)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Sección de cards
                ScrollView {
                    VStack(spacing: 16) {
                        ServiceCardView(imageName: "peinados1", title: "Woman Blunt Cut", price: "$50", duration: "2 hours", discount: "-20%", description: "A blunt cut bob is a shorter hairstyle.", iconButton: "plus.circle")
                        
                        ServiceCardView(imageName: "peinados2", title: "Bob/ Lob Cut", price: "$55", duration: "1.5 hours", discount: "-20%", description: "Lob haircut is a women's hairstyle.", iconButton: "plus.circle")
                        
                        ServiceCardView(imageName: "peinados3", title: "Medium Length Layer Cut", price: "$80", duration: "1 hour", discount: "", description: "Layered hair is a hairstyle that gives the illusion.", iconButton: "plus.circle")
                        
                        ServiceCardView(imageName: "peinados4", title: "V-Shaped Cut", price: "$90", duration: "2.5 hours", discount: "-5%", description: "There are a lot of variations between v-shaped.", iconButton: "plus.circle")
                    }
                    .padding(.horizontal)
                    
                    // Sección de resumen y botón Book Now
                    VStack(spacing: 16) {
                        Divider()
                        HStack {
                            Text("Total (1 Service)")
                                .font(.headline)
                            Spacer()
                            Text("$40")
                                .font(.headline)
                                .foregroundColor(AppColors.darkBlue)
                            Text("$50")
                                .font(.headline)
                                .strikethrough(true, color: .red)
                                .foregroundColor(AppColors.darkBlue)
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


#Preview {
    ServiceListView()
}
