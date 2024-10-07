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
                Image(systemName: "person.circle")
                    .font(.system(size: 60))
                    .padding()
                VStack{
                    HStack{
                        Text("Samantha Smith")
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
                        Text("samantha.smith@email.com")
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
        .background(Color(UIColor.systemBackground))
        .padding(.top, 40)
    }
}


#Preview {
    ProfileView()
}
