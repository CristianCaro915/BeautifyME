//
//  AppState.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 6/10/24.
//

import Foundation

enum AppState{
    case noInput // map has not a location or category to search for
    case categorySelected // there is a category selected
    case locationSelected // there is an specific location selected
    case polylineaddded // when a location is clicked
    case businessDetailed // a specific business is selected
    case booking // a reservation is being created
    case payment // the service was paid
    case addedToCalendar // service was added to calendar
}
