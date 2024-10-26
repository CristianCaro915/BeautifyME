//
//  OpeningHoursView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 25/10/24.
//

import SwiftUI

struct OpeningHoursView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Opening Hours")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
            
            HStack {
                Circle()
                    .fill(AppColors.darkBlue)
                    .frame(width: 8, height: 8)
                VStack {
                    Text("Monday - Friday")
                        .fontWeight(.semibold)
                    Text("08:00am - 03:00pm")
                }
                Circle()
                    .fill(AppColors.darkBlue)
                    .frame(width: 8, height: 8)
                VStack {
                    Text("Saturday - Sunday")
                        .fontWeight(.semibold)
                    Text("09:00am - 02:00pm")
                }
            }
        }
    }
}

#Preview {
    OpeningHoursView()
}
