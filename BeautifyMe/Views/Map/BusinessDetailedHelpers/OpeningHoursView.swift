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
                .accessibilityLabel(Text("Opening Hours"))
                .accessibilityValue(Text("Hours of operation for the business"))

            HStack {
                Circle()
                    .fill(AppColors.darkBlue)
                    .frame(width: 8, height: 8)
                VStack {
                    Text("Monday - Friday")
                        .fontWeight(.semibold)
                        .accessibilityLabel(Text("Monday to Friday"))
                        .accessibilityValue(Text("Open from 08:00 AM to 03:00 PM"))
                    Text("08:00am - 03:00pm")
                        .accessibilityLabel(Text("Opening time: 08:00 AM, Closing time: 03:00 PM"))
                }
                Circle()
                    .fill(AppColors.darkBlue)
                    .frame(width: 8, height: 8)
                VStack {
                    Text("Saturday - Sunday")
                        .fontWeight(.semibold)
                        .accessibilityLabel(Text("Saturday to Sunday"))
                        .accessibilityValue(Text("Open from 09:00 AM to 02:00 PM"))
                    Text("09:00am - 02:00pm")
                        .accessibilityLabel(Text("Opening time: 09:00 AM, Closing time: 02:00 PM"))
                }
            }
        }

    }
}

#Preview {
    OpeningHoursView()
}
