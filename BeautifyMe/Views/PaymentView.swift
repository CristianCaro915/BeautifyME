//
//  PaymentView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//

import SwiftUI

struct PaymentView: View {
    @State private var selectedPayment: Payment?
    @State private var showAlert = false
    @State private var selectedMake: String?
    @State private var isShowingNewView = false
    
    let textImages6: [String:String] =
    ["lock":"password","pencil":"password","rectangle":"password","pencil.tip":"password","lasso":"helloword","trash":"trashy"]
    
    private let paymentOptions = [
        "PayPal",
        "DaviPlata",
        "PSE",
        "Bold"
    ]
    
    var body: some View {
        VStack(spacing: 8){
            //TITLE
            HStack {
                Text("Choose your payment method")
                    .fontWeight(.bold)
                Button{
                    //action here API
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
            //LIST
            ForEach(Array(textImages6.keys), id: \.self) { key in
                if let value = textImages6[key] {
                    PaymentCardView(image: key, text: value)
                }
            }
            // extra
            HStack(spacing: 8){
                Image(systemName: "plus.app")
                    .foregroundColor(.green)
                    .padding(2)
                Text("Add new payment method")
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.leading, 20)
            
            // button
            // Botón de acción (icono)
            Button(action: {
                // new password action, call API
            }) {
                Text("Confirm New Password")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.darkBlue)
                    .cornerRadius(20)
            }
        }
        //ends vstack
    }
}

#Preview {
    PaymentView()
}
