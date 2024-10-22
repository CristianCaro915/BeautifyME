//
//  Reservation.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 18/10/24.
//

import Foundation
struct Reservation{
    let title: String
    let observation: String
    let startDate: Date
    let endDate: Date
    let userId: Int //extra for easy fetch
    let serviceId: Int //extra for easy fetch
    let invoiceId: Int //extra for easy fetch
    let businessId: Int //extra for easy fetch
}
