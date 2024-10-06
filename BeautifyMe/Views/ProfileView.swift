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
                VStack(spacing: 16) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 100))
                        .padding()
                    
                    Text("Samantha Smith")
                        .font(.title)
                        .bold()
                    
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("+1 234 567 890")
                            .font(.subheadline)
                    }
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("samantha.smith@email.com")
                            .font(.subheadline)
                    }
                }
                .padding(.top, 20)
                
                // Segunda Sección: Listado de Cards
                VStack(spacing: 16) {
                    CardView(iconName: "calendar", title: "Bookings", subtitle: "Check your upcoming appointments")
                    CardView(iconName: "heart.fill", title: "Favorites", subtitle: "Your favorite salons and services")
                    CardView(iconName: "creditcard.fill", title: "Payments", subtitle: "Manage your saved payment methods")
                    CardView(iconName: "gearshape.fill", title: "Settings", subtitle: "Update your preferences and account details")
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(Color(UIColor.systemBackground))
            .padding(.top, 40)
        }
}

struct CardView: View {
    var iconName: String
    var title: String
    var subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.system(size: 40))
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
    }
}


#Preview {
    ProfileView()
}
