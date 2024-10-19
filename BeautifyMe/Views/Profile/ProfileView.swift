//
//  ProfileView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Primera Sección: Información del usuario
            HStack{
                Image("juanita_profile")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 90)
                    .cornerRadius(30)
                    .padding(.leading)
                VStack{
                    HStack{
                        Text("Juanita Carrascal")
                            .font(.title2)
                            .bold()
                        Spacer()
                        Button(action: {
                            // Acción para día siguiente
                        }) {
                            Text("Edit")
                                .foregroundColor(AppColors.darkBlue)
                            Image(systemName: "chevron.right")
                                .foregroundColor(AppColors.darkBlue)
                        }
                        Spacer()
                    }
                    
                    HStack{
                        Text("+1 234 567 890")
                            .font(.footnote)
                        Spacer()
                    }
                    HStack{
                        Text("j.carrasca@gmail.com")
                            .font(.footnote)
                        Spacer()
                    }
                }
            }
            // Segunda Sección: Listado de Cards
            VStack(spacing: 16) {
                ProfileCardView(iconName: "heart.fill", title: "Favorites", subtitle: "Your favorite salons and services")
                ProfileCardView(iconName: "creditcard.fill", title: "Payments", subtitle: "Manage your saved payment methods")
                ProfileCardView(iconName: "calendar", title: "Bookings", subtitle: "Check your upcoming appointments")
                ProfileCardView(iconName: "gearshape.fill", title: "Settings", subtitle: "Update your preferences and account details")
                ProfileCardView(iconName: "door.left.hand.open", title: "LogOut", subtitle: "")
                    .foregroundColor(.red)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(AppColors.white)
        .padding(.top, 40)
    }
}


#Preview {
    ProfileView()
}
