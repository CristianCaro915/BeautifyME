//
//  BussinessServiceListView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 25/10/24.
//

import SwiftUI

struct BusinessServiceListView: View {
    let services: [Service]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Our Services")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
                .accessibilityLabel(Text("Section Title"))
                .accessibilityValue(Text("Our Services"))

            ForEach(services, id: \.self) { service in
                ServiceCardView(
                    imageName: service.icon,
                    title: service.name,
                    price: service.price,
                    duration: "2 hours",
                    discount: "-20%",
                    description: service.description,
                    iconButton: "plus.circle"
                )
                .accessibilityElement(children: .combine) // Combina los elementos de la tarjeta para la accesibilidad
                .accessibilityLabel(Text("Service: \(service.name)"))
                .accessibilityValue(Text("Price: \(service.price), Duration: 2 hours, Discount: -20%. Description: \(service.description)"))
            }
        }

    }
}

/*
#Preview {
    BussinessServiceListView()
}
 */
