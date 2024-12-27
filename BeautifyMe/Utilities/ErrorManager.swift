//
//  ErrorManager.swift
//  BeautifyMe
//
//  Created by Cristian Caro on 18/10/24.
//

import Foundation
enum ErrorManager: Error{
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidJWT
    case jwtNotFound
    
    case serializationError
    case serverError
    case responseParsingError
    case unknown
    // User
    case usernameAlreadyExists
    case invalidUsername
    case invalidEmail
    case invalidPassword
    case invalidPhone
    case invalidUserId
    case updateError
    // log in
    case emptyEmail
    case emptyPassword
    case invalidCredentials
    // business
    case invalidDescription
    case invalidBusinessId
    // employee
    case invalidEarnings
    case invalidGender
    // service
    case invalidServiceId
}
