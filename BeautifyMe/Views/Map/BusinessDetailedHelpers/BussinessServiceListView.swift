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
            }
        }
    }
}

/*
#Preview {
    BussinessServiceListView()
}
 */
