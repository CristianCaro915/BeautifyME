//
//  IconAloneView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 6/10/24.
//

import SwiftUI

struct IconAloneView: View {
    let image: String
    
    var body: some View {
        Image(systemName: image)
            .resizable()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
    }
}

#Preview {
    IconAloneView(image: "lock")
}
