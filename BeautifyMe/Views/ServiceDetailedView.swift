//
//  ServiceDetailedView.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 5/10/24.
//

import SwiftUI

struct ServiceDetailedView: View {
    @State private var selectedDate = "10"
    @State private var selectedTime = "10:00 AM"
    @State private var notes = ""
    let textImages6: [String:String] =
    ["lock":"password","pencil":"password","rectangle":"password","pencil.tip":"password","lasso":"helloword","trash":"trashy"]
    
    var body: some View{
            VStack(spacing: 20) {
                // Primera sección: Lista de iconos (Especialistas)
                VStack(alignment: .leading) {
                    Text("Specialist")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            // professionals
                            ForEach(Array(textImages6.keys), id: \.self) { key in
                                if let value = textImages6[key] {
                                    IconTextView(image: key, title: value)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Segunda sección: Day Picker y Hour Picker
                VStack(alignment: .leading) {
                    Text("Date")
                        .font(.headline)
                    
                    HStack {
                        Button(action: {
                            // Acción para día anterior
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(AppColors.darkBlue)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(["9", "10", "11", "12", "13"], id: \.self) { day in
                                    DayPickerView(day: day, isSelected: day == selectedDate)
                                        .onTapGesture {
                                            selectedDate = day
                                        }
                                }
                            }
                        }
                        
                        Button(action: {
                            // Acción para día siguiente
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(AppColors.darkBlue)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Hour Picker
                    Text("Time")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(["08:00 AM", "10:00 AM", "11:00 AM", "01:00 PM"], id: \.self) { time in
                                TimePickerView(time: time, isSelected: time == selectedTime)
                                    .onTapGesture {
                                        selectedTime = time
                                    }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Tercera sección: Notas (TextField)
                VStack(alignment: .leading) {
                    Text("Notes")
                        .font(.headline)
                    
                    TextField("Type your notes here", text: $notes)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                // Cuarta sección: Card con total y botón Book Now
                VStack(spacing: 16) {
                    Divider()
                    
                    HStack {
                        Text("Total (1 Service)")
                            .font(.headline)
                        Spacer()
                        Text("$40 $10")
                            .font(.headline)
                            .foregroundColor(AppColors.darkBlue)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        // Acción para "Book Now"
                    }) {
                        Text("Book Now")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppColors.darkBlue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .padding(.top, 20)
            .background(Color(UIColor.systemBackground))
        }
}

struct DayPickerView: View {
    var day: String
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Text("Thu")
                .font(.caption)
                .foregroundColor(isSelected ? AppColors.white : AppColors.darkGrey)
            Text(day)
                .font(.headline)
                .foregroundColor(isSelected ? AppColors.white : AppColors.black)
        }
        .padding()
        .frame(width: 60, height: 60)
        .background(isSelected ? AppColors.darkBlue : AppColors.lightGrey)
        .clipShape(Circle())
    }
}

struct TimePickerView: View {
    var time: String
    var isSelected: Bool
    
    var body: some View {
        Text(time)
            .font(.subheadline)
            .foregroundColor(isSelected ? AppColors.white : AppColors.black)
            .padding()
            .background(isSelected ? AppColors.darkBlue : AppColors.lightGrey)
            .cornerRadius(10)
    }
}


#Preview {
    ServiceDetailedView()
}
