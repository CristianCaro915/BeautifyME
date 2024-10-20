//
//  Business.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 18/10/24.
//

import Foundation

struct Business: Hashable, Decodable, Identifiable{
    let id: Int
    let name: String
    let category: String
    let description: String
    let images: [String]
    let latitude: String
    let longitude: String
}
