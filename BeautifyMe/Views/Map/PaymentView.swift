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
    
    let textImages6: [String: String] = [
        "apple_pay_icon": "Apple pay",
        "cash_icon": "Cash",
        "debit:credit_icon": "Debit/Credit card"
    ]
    
    private let paymentOptions = [
        "PayPal",
        "DaviPlata",
        "PSE",
        "Bold"
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            //TITLE
            HStack {
                Text("Payment Methods")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(20)
                    .accessibilityLabel("Payment Methods")
                    .accessibilityValue("List of available payment methods")
                Spacer()
            }
            //LIST
            ForEach(Array(textImages6.keys), id: \.self) { key in
                if let value = textImages6[key] {
                    PaymentCardView(image: key, text: value)
                        .accessibilityLabel(value) // Label for the payment method
                        .accessibilityValue("Available payment method") // Value for the payment method
                }
            }
            // Extra
            HStack(spacing: 8) {
                Spacer()
                Image(systemName: "plus.app")
                    .foregroundColor(.green)
                    .padding(2)
                    .accessibilityLabel("Add new payment method")
                    .accessibilityValue("Tap to add a new payment method")
                Text("Add new payment method")
                    .foregroundColor(.black)
                    .padding()
                    .accessibilityLabel("Add new payment method")
                    .accessibilityValue("Tap to add a new payment method")
                Spacer()
            }
            .padding(.leading, 20)
            
            Spacer()
            
            // Button
            Button(action: {
                // New password action, call API
            }) {
                Text("Confirm New Password")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.darkBlue)
                    .cornerRadius(20)
            }
            .padding()
            .accessibilityLabel("Confirm New Password")
            .accessibilityValue("Tap to confirm the new password")
        }
        .background(Color(.white).ignoresSafeArea())
        //ends vstack
    }
}

#Preview {
    PaymentView()
}
