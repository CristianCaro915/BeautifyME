//
//  IconTextView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 6/10/24.
//

import SwiftUI

struct IconTextView: View {
    let image: String
    let title: String
    
    var body: some View {
        VStack{
            Image(systemName: image)
                .font(.system(size: 40))
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.2))
                .clipShape(Circle())
            Text(title)
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    IconTextView(image: "lock", title: "New password")
}
