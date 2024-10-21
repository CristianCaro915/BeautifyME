//
//  User.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 19/10/24.
//

import Foundation
struct User: Decodable {
    let id: Int
    let username: String
    let email: String
    let phone: String
    let role: String
    let imageURL: String
}
