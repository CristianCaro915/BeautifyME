//
//  SpecialistsView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 25/10/24.
//

import SwiftUI

struct SpecialistsView: View {
    let specialists: [Employee]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Our Specialists")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
                .accessibilityLabel(Text("Our Specialists"))
                .accessibilityValue(Text("List of specialists available at the business"))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(specialists, id: \.self) { specialist in
                        IconTextView(imageURL: specialist.photo, title: specialist.name)
                            .accessibilityLabel(Text(specialist.name))
                            .accessibilityValue(Text("Specialist available"))
                    }
                }
                .padding(.horizontal)
            }
        }

    }
}

/**
#Preview {
    SpecialistsView()
}
 */
