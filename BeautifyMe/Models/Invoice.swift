//
//  Invoice.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 18/10/24.
//

import Foundation
struct Invoice: Decodable, Identifiable, Hashable{
    let id: Int
    let reservationId: Int // extra attribute to fetch easier
    let paymentDate: Date
    let totalValue: Int
}
