//
//  ProfileView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    
    var body: some View {
        VStack(spacing: 20) {
            // Primera Sección: Información del usuario
            HStack {
                if let iconURL = URL(string: "http://localhost:1337" + sessionManager.user!.imageURL) {
                    AsyncImage(url: iconURL) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 90)
                            .cornerRadius(30)
                            .padding(.leading)
                            .accessibilityLabel("User Profile Image")
                            .accessibilityValue("Profile picture of \(sessionManager.user?.username ?? "User")")
                    } placeholder: {
                        ProgressView()
                            .accessibilityLabel("Loading Profile Image")
                    }
                }
                
                VStack {
                    HStack {
                        Text(sessionManager.user?.username ?? "User")
                            .font(.title2)
                            .bold()
                            .accessibilityLabel("Username")
                            .accessibilityValue(sessionManager.user?.username ?? "User")
                        
                        Spacer()
                        
                        Button(action: {
                            // Acción para editar perfil
                        }) {
                            Text("Edit")
                                .foregroundColor(AppColors.darkBlue)
                            Image(systemName: "chevron.right")
                                .foregroundColor(AppColors.darkBlue)
                        }
                        .accessibilityLabel("Edit Profile")
                        .accessibilityHint("Tap to edit profile information")
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("+1 234 567 890")
                            .font(.footnote)
                            .accessibilityLabel("Phone Number")
                            .accessibilityValue("+1 234 567 890")
                        Spacer()
                    }
                    
                    HStack {
                        Text(sessionManager.user?.email ?? "none@none.com")
                            .font(.footnote)
                            .accessibilityLabel("Email")
                            .accessibilityValue(sessionManager.user?.email ?? "none@none.com")
                        Spacer()
                    }
                }
            }
            
            // Segunda Sección: Listado de Cards
            VStack(spacing: 16) {
                ProfileCardView(iconName: "heart.fill", title: "Favorites", subtitle: "Your favorite salons and services")
                    .accessibilityElement()
                    .accessibilityLabel("Favorites")
                    .accessibilityValue("Your favorite salons and services")
                
                ProfileCardView(iconName: "creditcard.fill", title: "Payments", subtitle: "Manage your saved payment methods")
                    .accessibilityElement()
                    .accessibilityLabel("Payments")
                    .accessibilityValue("Manage your saved payment methods")
                
                ProfileCardView(iconName: "calendar", title: "Bookings", subtitle: "Check your upcoming appointments")
                    .accessibilityElement()
                    .accessibilityLabel("Bookings")
                    .accessibilityValue("Check your upcoming appointments")
                
                ProfileCardView(iconName: "gearshape.fill", title: "Settings", subtitle: "Update your preferences and account details")
                    .accessibilityElement()
                    .accessibilityLabel("Settings")
                    .accessibilityValue("Update your preferences and account details")
                
                ProfileCardView(iconName: "door.left.hand.open", title: "LogOut", subtitle: "")
                    .foregroundColor(.red)
                    .accessibilityElement()
                    .accessibilityLabel("Log Out")
                    .accessibilityHint("Tap to log out")
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(.white).ignoresSafeArea())
        .padding(.top, 40)
    }
}


#Preview {
    ProfileView()
}
