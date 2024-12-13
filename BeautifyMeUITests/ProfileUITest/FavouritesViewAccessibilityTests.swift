//
//  FavouritesViewAccessibilityTests.swift
//  BeautifyMeUITests
//
//  Created by Cristian Caro on 5/11/24.
//
/*
import XCTest
@testable import BeautifyMe

final class FavouritesViewAccessibilityTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app =  XCUIApplication()
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFavouritesViewAccessibilityLabel() {
        let app = XCUIApplication()
        app.launch()
        
        let favouritesViewLabel = app.navigationBars["Favorite Businesses"]
        XCTAssertTrue(favouritesViewLabel.exists, "El `accessibilityLabel` de la vista de favoritos no se encuentra.")
    }
    
    func testBusinessNameAndLocationAccessibilityLabels() {
        let app = XCUIApplication()
        app.launch()
        
        let businessNameLabel = app.staticTexts["Business Name"]
        XCTAssertTrue(businessNameLabel.exists, "El `accessibilityLabel` del nombre del negocio no se encuentra.")
        XCTAssertEqual(businessNameLabel.value as? String, "Business Name Placeholder", "El `accessibilityValue` del nombre del negocio no coincide con el esperado.")
        
        let locationLabel = app.staticTexts["Location"]
        XCTAssertTrue(locationLabel.exists, "El `accessibilityLabel` de la ubicación no se encuentra.")
        XCTAssertEqual(locationLabel.value as? String, "Location Placeholder", "El `accessibilityValue` de la ubicación no coincide con el esperado.")
    }
    
    func testReorderBookingButtonAccessibilityLabel() {
        let app = XCUIApplication()
        app.launch()
        
        let reorderButton = app.buttons["Reorder Booking Button"]
        XCTAssertTrue(reorderButton.exists, "El `accessibilityLabel` para el botón de reordenar reservas no se encuentra.")
        let reorderHint = reorderButton.label
        XCTAssertEqual(reorderHint, "Reorder Booking Button", "El `accessibilityHint` para el botón de reordenar reservas no coincide con el esperado.")
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
