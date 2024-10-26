//
//  Comment.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 18/10/24.
//

import Foundation
struct Comment: Hashable, Decodable, Identifiable{
    let id: Int
    let description: String
    let rating: Int
    let commenterName: String
    let commenterImage: String
}
