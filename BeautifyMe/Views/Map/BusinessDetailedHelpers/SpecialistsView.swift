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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(specialists, id: \.self) { specialist in
                        IconTextView(imageURL: specialist.photo, title: specialist.name)
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
