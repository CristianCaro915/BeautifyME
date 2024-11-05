//
//  PaymentViewAccessibilityTests.swift
//  BeautifyMeUITests
//
//  Created by Cristian Caro on 5/11/24.
//

import XCTest
@testable import BeautifyMe

final class PaymentViewAccessibilityTests: XCTestCase {
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
    
    func test_Title_Accessibility() {
        let titleLabel = app.staticTexts["Payment Methods"]
        XCTAssertTrue(titleLabel.exists, "El título 'Payment Methods' no existe.")
        XCTAssertEqual(titleLabel.label, "Payment Methods", "El accessibilityLabel del título no es correcto.")
        XCTAssertEqual(titleLabel.value as? String, "List of available payment methods", "El accessibilityValue del título no es correcto.")
    }
    
    func test_PaymentOptions_Accessibility() {
        for (key, value) in textImages6 {
            let paymentMethodLabel = app.staticTexts[value]
            XCTAssertTrue(paymentMethodLabel.exists, "El label del método de pago '\(value)' no existe.")
            XCTAssertEqual(paymentMethodLabel.label, value, "El accessibilityLabel del método de pago '\(value)' no es correcto.")
            XCTAssertEqual(paymentMethodLabel.value as? String, "Available payment method", "El accessibilityValue del método de pago '\(value)' no es correcto.")
        }
    }
    
    func test_AddNewPaymentMethod_Accessibility() {
        let addPaymentLabel = app.staticTexts["Add new payment method"]
        XCTAssertTrue(addPaymentLabel.exists, "El label 'Add new payment method' no existe.")
        XCTAssertEqual(addPaymentLabel.label, "Add new payment method", "El accessibilityLabel de 'Add new payment method' no es correcto.")
        XCTAssertEqual(addPaymentLabel.value as? String, "Tap to add a new payment method", "El accessibilityValue de 'Add new payment method' no es correcto.")
        
        let addPaymentImage = app.images["plus.app"]
        XCTAssertTrue(addPaymentImage.exists, "El ícono de añadir nuevo método de pago no existe.")
        XCTAssertEqual(addPaymentImage.label, "Add new payment method", "El accessibilityLabel del ícono de añadir no es correcto.")
        XCTAssertEqual(addPaymentImage.value as? String, "Tap to add a new payment method", "El accessibilityValue del ícono de añadir no es correcto.")
    }
    
    func test_ConfirmNewPasswordButton_Accessibility() {
        let confirmButton = app.buttons["Confirm New Password"]
        XCTAssertTrue(confirmButton.exists, "El botón 'Confirm New Password' no existe.")
        XCTAssertEqual(confirmButton.label, "Confirm New Password", "El accessibilityLabel del botón no es correcto.")
        XCTAssertEqual(confirmButton.value as? String, "Tap to confirm the new password", "El accessibilityValue del botón no es correcto.")
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
