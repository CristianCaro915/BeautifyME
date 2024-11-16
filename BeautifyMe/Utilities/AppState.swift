//
//  AppState.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 6/10/24.
//

import Foundation

enum AppState{
    case noInput // map has not a location or category to search for
    case searchingForLocation // the user is searching the place to go
    case categorySelected // there is a category selected
    case locationSelected // there is an specific location selected
    case polylineaddded // when a location is clicked
    case businessDetailed // a specific business is selected
    case commentList // list of all comments and user can create one comment
    case serviceList // list of all services
    case booking // a reservation is being created
    case payment // the service was paid
}
