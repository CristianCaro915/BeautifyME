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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(images, id: \.self) { image in
                        IconRectangleView(image: image)
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
