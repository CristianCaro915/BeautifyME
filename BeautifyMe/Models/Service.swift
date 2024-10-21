//
//  Service.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 18/10/24.
//

import Foundation
struct Service: Decodable, Identifiable, Hashable{
    let id: Int
    let name: String
    let description: String
    let price: Int
    let category: String
    let icon: String
}
