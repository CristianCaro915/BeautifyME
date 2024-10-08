//
//  Review.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 8/10/24.
//

import SwiftUI

struct Review: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let rating: Int
    let timeAgo: String
    let comment: String
}
