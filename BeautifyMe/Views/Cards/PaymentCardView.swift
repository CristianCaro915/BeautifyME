//
//  PaymentCardView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 6/10/24.
//

import SwiftUI

struct PaymentCardView: View {
    let image: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16){
            Image(systemName: image)
                .padding(2)
                .foregroundColor(.black)
            Text(text)
                .foregroundColor(.black)
            Spacer()
            
            Button(action: {
                // new password action, call API
            }) {
                Text("Remove")
                    .foregroundColor(Color(.red))
                    .padding()
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    PaymentCardView(image: "lock.fill", text:"payment")
}
