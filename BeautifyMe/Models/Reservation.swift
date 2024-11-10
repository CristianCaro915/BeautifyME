//
//  Reservation.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 18/10/24.
//

import Foundation
struct Reservation: Decodable, Identifiable, Hashable{
    let id: Int
    let title: String
    let observation: String
    let startDate: Date
    let endDate: Date
    let isActive: Bool
}
