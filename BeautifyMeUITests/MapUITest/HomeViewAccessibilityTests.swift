//
//  HomeViewAccessibilityTests.swift
//  BeautifyMeUITests
//
//  Created by Cristian Caro on 5/11/24.
//
/*
import XCTest
@testable import BeautifyMe

final class HomeViewAccessibilityTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_Header_Accessibility() {
        let usernameLabel = app.staticTexts["Username"]
        XCTAssertTrue(usernameLabel.exists, "El label del nombre de usuario no existe.")
        XCTAssertEqual(usernameLabel.label, "Username", "El accessibilityLabel del nombre de usuario no es correcto.")
        XCTAssertEqual(usernameLabel.value as? String, sessionManager.user?.username ?? "User", "El accessibilityValue del nombre de usuario no es correcto.")
        
        let userDescriptionLabel = app.staticTexts["User description"]
        XCTAssertTrue(userDescriptionLabel.exists, "El label de descripción del usuario no existe.")
        XCTAssertEqual(userDescriptionLabel.label, "User description", "El accessibilityLabel de descripción del usuario no es correcto.")
        XCTAssertEqual(userDescriptionLabel.value as? String, "Find the service you want, and treat yourself", "El accessibilityValue de descripción del usuario no es correcto.")
        
        let searchButton = app.images["Search"]
        XCTAssertTrue(searchButton.exists, "El botón de búsqueda no existe.")
        XCTAssertEqual(searchButton.label, "Search", "El accessibilityLabel del botón de búsqueda no es correcto.")
        XCTAssertEqual(searchButton.value as? String, "Tap to search for services", "El accessibilityValue del botón de búsqueda no es correcto.")
    }
    
    func test_WhatDoYouWantToDo_Accessibility() {
        let whatToDoLabel = app.staticTexts["What do you want to do section"]
        XCTAssertTrue(whatToDoLabel.exists, "La sección 'What do you want to do?' no existe.")
        
        for service in dataViewModel.services {
            let serviceLabel = app.staticTexts[service.name]
            XCTAssertTrue(serviceLabel.exists, "El label del servicio '\(service.name)' no existe.")
            XCTAssertEqual(serviceLabel.label, service.name, "El accessibilityLabel del servicio '\(service.name)' no es correcto.")
            XCTAssertEqual(serviceLabel.value as? String, "Service available", "El accessibilityValue del servicio '\(service.name)' no es correcto.")
        }
    }
    
    func test_BusinessesYouFollow_Accessibility() {
        let businessesFollowedLabel = app.staticTexts["Businesses you follow section"]
        XCTAssertTrue(businessesFollowedLabel.exists, "La sección 'Businesses you follow' no existe.")
        
        for business in dataViewModel.businesses {
            let businessLabel = app.staticTexts[business.name]
            XCTAssertTrue(businessLabel.exists, "El label del negocio '\(business.name)' no existe.")
            XCTAssertEqual(businessLabel.label, business.name, "El accessibilityLabel del negocio '\(business.name)' no es correcto.")
            XCTAssertEqual(businessLabel.value as? String, "Followed business", "El accessibilityValue del negocio '\(business.name)' no es correcto.")
        }
    }
    
    func test_FeaturedSalons_Accessibility() {
        let featuredSalonsLabel = app.staticTexts["Featured Salons section"]
        XCTAssertTrue(featuredSalonsLabel.exists, "La sección 'Featured Salons' no existe.")
        
        for business in dataViewModel.businesses {
            let businessLabel = app.staticTexts[business.name]
            XCTAssertTrue(businessLabel.exists, "El label del salón destacado '\(business.name)' no existe.")
            XCTAssertEqual(businessLabel.label, business.name, "El accessibilityLabel del salón destacado '\(business.name)' no es correcto.")
            XCTAssertEqual(businessLabel.value as? String, "Featured business", "El accessibilityValue del salón destacado '\(business.name)' no es correcto.")
        }
    }
    
    func test_MostSearchedInterests_Accessibility() {
        let mostSearchedInterestsLabel = app.staticTexts["Most searched interests section"]
        XCTAssertTrue(mostSearchedInterestsLabel.exists, "La sección 'Most searched interests' no existe.")
        
        for service in dataViewModel.services {
            let serviceLabel = app.staticTexts[service.name]
            XCTAssertTrue(serviceLabel.exists, "El label del interés más buscado '\(service.name)' no existe.")
            XCTAssertEqual(serviceLabel.label, service.name, "El accessibilityLabel del interés más buscado '\(service.name)' no es correcto.")
            XCTAssertEqual(serviceLabel.value as? String, "Service available", "El accessibilityValue del interés más buscado '\(service.name)' no es correcto.")
        }
    }
    
    func test_NearbyOffers_Accessibility() {
        let nearbyOffersLabel = app.staticTexts["Nearby Offers section"]
        XCTAssertTrue(nearbyOffersLabel.exists, "La sección 'Nearby Offers' no existe.")
        
        for business in dataViewModel.businesses {
            let businessLabel = app.staticTexts[business.name]
            XCTAssertTrue(businessLabel.exists, "El label de la oferta cercana '\(business.name)' no existe.")
            XCTAssertEqual(businessLabel.label, business.name, "El accessibilityLabel de la oferta cercana '\(business.name)' no es correcto.")
            XCTAssertEqual(businessLabel.value as? String, "Nearby offer", "El accessibilityValue de la oferta cercana '\(business.name)' no es correcto.")
        }
    }
    
    
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
*/
