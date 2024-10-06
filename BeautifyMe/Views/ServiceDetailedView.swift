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
    
    
    var body: some View {
            VStack(spacing: 20) {
                // Primera sección: Lista de iconos (Especialistas)
                VStack(alignment: .leading) {
                    Text("Specialist")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            // professional 1
                            VStack{
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 40))
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                Text("New password")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            // professional 2
                            VStack{
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 40))
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                Text("New password")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            // professional 3
                            VStack{
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 40))
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                Text("New password")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            // professional 4
                            VStack{
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 40))
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                Text("New password")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
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
                            .foregroundColor(.green)
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
                            .background(Color.blue)
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
                .foregroundColor(isSelected ? .white : .gray)
            Text(day)
                .font(.headline)
                .foregroundColor(isSelected ? .white : .black)
        }
        .padding()
        .frame(width: 60, height: 60)
        .background(isSelected ? Color.blue : Color(UIColor.systemGray6))
        .clipShape(Circle())
    }
}

struct TimePickerView: View {
    var time: String
    var isSelected: Bool
    
    var body: some View {
        Text(time)
            .font(.subheadline)
            .foregroundColor(isSelected ? .white : .black)
            .padding()
            .background(isSelected ? Color.blue : Color(UIColor.systemGray6))
            .cornerRadius(10)
    }
}


#Preview {
    ServiceDetailedView()
}
