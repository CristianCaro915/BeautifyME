//
//  Business.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 18/10/24.
//

import Foundation

struct Business: Hashable, Decodable{
    let name: String
    let category: String
    let description: String
    let images: [URL]
    let latitude: String
    let longitude: String
}
