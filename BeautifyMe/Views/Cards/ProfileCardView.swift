//
//  ProfileCardView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 6/10/24.
//

import SwiftUI

struct ProfileCardView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    var iconName: String
    var title: String
    var subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.system(size: 30))
                .frame(width: 60, height: 60)
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(AppColors.mediumGrey)
            }
            .padding(.leading, 0)
            
            Spacer()
            
            Button(action: {
                //Change for enum with case values for every opening
                if title == "LogOut"{
                    //print(sessionManager.isAuthenticated)
                    //print("MUST LOG OUT")
                    sessionManager.isAuthenticated = false
                    //print(sessionManager.isAuthenticated)
                }
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(AppColors.darkBlue)
            }
        }
        .padding()
        .cornerRadius(10)
    }
}

#Preview {
    ProfileCardView(iconName: "calendar", title: "Bookings", subtitle: "Check your upcoming appointments")
}
