//
//  Employee.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 18/10/24.
//

import Foundation

struct Employee: Hashable, Identifiable, Decodable{
    let id: Int
    let name: String
    let gender: String
    let mail: String
    let phone: String
    let earnings: Int
    let photo: String
}
