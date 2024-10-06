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
            
            // payment 1
            HStack(spacing: 8){
                Image(systemName: "lock.fill")
                    .padding(2)
                    .foregroundColor(.black)
                Text("payment")
                    .foregroundColor(.black)
            }
            //payment 2
            HStack(spacing: 8){
                Image(systemName: "lock.fill")
                    .padding(2)
                    .foregroundColor(.black)
                Text("payment")
                    .foregroundColor(.black)
            }
            // extra
            HStack(spacing: 8){
                Image(systemName: "plus.app")
                    .foregroundColor(.green)
                    .padding(2)
                Text("Add new payment method")
                    .foregroundColor(.black)
            }
            
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
