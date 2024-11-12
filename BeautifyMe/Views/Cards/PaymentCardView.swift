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
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .padding(2)
                .foregroundColor(AppColors.black)
            Text(text)
                .foregroundColor(AppColors.black)
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
    PaymentCardView(image: "debit:credit_icon", text:"payment")
}
