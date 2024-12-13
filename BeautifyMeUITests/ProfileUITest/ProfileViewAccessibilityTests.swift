//
//  ProfileViewAccessibilityTests.swift
//  BeautifyMeUITests
//
//  Created by Cristian Caro on 5/11/24.
//
/*
import XCTest
@testable import BeautifyMe

final class ProfileViewAccessibilityTests: XCTestCase {
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
    
    func test_Username_AccessibilityLabel() {
        let usernameLabel = app.staticTexts["Username"]
        XCTAssertTrue(usernameLabel.exists, "El `accessibilityLabel` del nombre de usuario no se encuentra.")
        
        let usernameValue = usernameLabel.value as? String
        XCTAssertEqual(usernameValue, "ExpectedUsername", "El `accessibilityValue` del nombre de usuario no coincide con el esperado.")
    }
    
    func test_EditProfileButton_AccessibilityLabel() {
        let app = XCUIApplication()
        app.launch()
        
        let editButton = app.buttons["Edit Profile"]
        XCTAssertTrue(editButton.exists, "El `accessibilityLabel` para el botón de editar perfil no se encuentra.")
        
        let editHint = editButton.label
        XCTAssertEqual(editHint, "Edit Profile", "El `accessibilityHint` para el botón de editar perfil no coincide con el esperado.")
    }
    
    func test_ProfileCards_AccessibilityLabels_And_Values() {
        let app = XCUIApplication()
        app.launch()
        
        let favoritesCard = app.staticTexts["Favorites"]
        XCTAssertTrue(favoritesCard.exists, "El `accessibilityLabel` de la card de favoritos no se encuentra.")
        XCTAssertEqual(favoritesCard.value as? String, "Your favorite salons and services", "El `accessibilityValue` de la card de favoritos no coincide con el esperado.")
        
        let paymentsCard = app.staticTexts["Payments"]
        XCTAssertTrue(paymentsCard.exists, "El `accessibilityLabel` de la card de pagos no se encuentra.")
        XCTAssertEqual(paymentsCard.value as? String, "Manage your saved payment methods", "El `accessibilityValue` de la card de pagos no coincide con el esperado.")
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
