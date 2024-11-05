//
//  GalleryView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 25/10/24.
//

import SwiftUI

struct GalleryView: View {
    let images: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Gallery")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
                .accessibilityLabel(Text("Section Title"))
                .accessibilityValue(Text("Gallery"))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(images, id: \.self) { image in
                        IconRectangleView(image: image)
                            .accessibilityElement()
                            .accessibilityLabel(Text("Gallery Image"))
                            .accessibilityValue(Text("Image \(images.firstIndex(of: image) ?? 0 + 1) of \(images.count)"))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

/*
#Preview {
    GalleryView()
}
 */
