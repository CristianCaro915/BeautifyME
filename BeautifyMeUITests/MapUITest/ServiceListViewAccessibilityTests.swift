//
//  ServiceListViewAccessibilityTests.swift
//  BeautifyMeUITests
//
//  Created by Cristian Caro on 5/11/24.
//
/*
import XCTest
@testable import BeautifyMe

final class ServiceListViewAccessibilityTests: XCTestCase {
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
    
    func testServiceIconsAccessibility() {
        for service in dataViewModel.services {
            let iconLabel = app.images[service.icon] // Asumiendo que el icono se carga como una imagen
            XCTAssertTrue(iconLabel.exists, "El ícono de servicio '\(service.name)' no existe.")
            XCTAssertEqual(iconLabel.label, service.name, "El accessibilityLabel del ícono '\(service.name)' no es correcto.")
            XCTAssertEqual(iconLabel.value as? String, "Service icon", "El accessibilityValue del ícono '\(service.name)' no es correcto.")
        }
    }
    
    func testServiceCardsAccessibility() {
        for service in dataViewModel.services {
            let serviceCardLabel = app.staticTexts[service.name] // Cambia esto según cómo se muestre la tarjeta
            XCTAssertTrue(serviceCardLabel.exists, "La tarjeta del servicio '\(service.name)' no existe.")
            XCTAssertEqual(serviceCardLabel.label, "\(service.name) - \(service.price)", "El accessibilityLabel de la tarjeta del servicio '\(service.name)' no es correcto.")
            XCTAssertEqual(serviceCardLabel.value as? String, "Duration: 2 hours, Discount: -20%", "El accessibilityValue de la tarjeta del servicio '\(service.name)' no es correcto.")
        }
    }
    
    func testTotalPriceAccessibility() {
        let totalLabel = app.staticTexts["Total (1 Service)"]
        XCTAssertTrue(totalLabel.exists, "El label 'Total (1 Service)' no existe.")
        XCTAssertEqual(totalLabel.label, "Total (1 Service)", "El accessibilityLabel del total no es correcto.")
        XCTAssertEqual(totalLabel.value as? String, "Total for selected service", "El accessibilityValue del total no es correcto.")
        
        let currentPriceLabel = app.staticTexts["$40"]
        XCTAssertTrue(currentPriceLabel.exists, "El label del precio actual no existe.")
        XCTAssertEqual(currentPriceLabel.label, "$40", "El accessibilityLabel del precio actual no es correcto.")
        XCTAssertEqual(currentPriceLabel.value as? String, "Total price", "El accessibilityValue del precio actual no es correcto.")
        
        let originalPriceLabel = app.staticTexts["$50"]
        XCTAssertTrue(originalPriceLabel.exists, "El label del precio original no existe.")
        XCTAssertEqual(originalPriceLabel.label, "$50", "El accessibilityLabel del precio original no es correcto.")
        XCTAssertEqual(originalPriceLabel.value as? String, "Original price", "El accessibilityValue del precio original no es correcto.")
    }
    
    func testBookNowButtonAccessibility() {
        let bookNowButton = app.buttons["Book Now"]
        XCTAssertTrue(bookNowButton.exists, "El botón 'Book Now' no existe.")
        XCTAssertEqual(bookNowButton.label, "Book Now", "El accessibilityLabel del botón 'Book Now' no es correcto.")
        XCTAssertEqual(bookNowButton.value as? String, "Tap to book the service", "El accessibilityValue del botón 'Book Now' no es correcto.")
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
