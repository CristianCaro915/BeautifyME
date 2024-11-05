//
//  BusinessDetailedViewAccessibilityTests.swift
//  BeautifyMeUITests
//
//  Created by Cristian Caro on 5/11/24.
//

import XCTest
@testable import BeautifyMe

final class BusinessDetailedViewAccessibilityTests: XCTestCase {
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
    
    func test_AccessibilityLabels_And_Values() {
        // Verifica la imagen del negocio
        let businessImage = app.images["Business image"]
        XCTAssertTrue(businessImage.exists, "La imagen del negocio no tiene el accessibilityLabel correcto.")
        XCTAssertEqual(businessImage.label, "Business image", "El accessibilityLabel de la imagen del negocio no es correcto.")
        
        // Información del negocio
        let businessInfo = app.staticTexts["Business Information"]
        XCTAssertTrue(businessInfo.exists, "La información del negocio no tiene el accessibilityLabel correcto.")
        XCTAssertEqual(businessInfo.value as? String, "Business Name, Address: 122 Riverside Rd. Eacho City, NY 34856, Rating: 4 stars", "El accessibilityValue de la información del negocio no es correcto.")
        
        // Horario de apertura
        let openingHours = app.staticTexts["Opening hours"]
        XCTAssertTrue(openingHours.exists, "El horario de apertura no tiene el accessibilityLabel correcto.")
        
        // Lista de servicios
        let servicesList = app.staticTexts["Services offered by the business"]
        XCTAssertTrue(servicesList.exists, "La lista de servicios no tiene el accessibilityLabel correcto.")
        
        // Galería
        let gallery = app.staticTexts["Business gallery"]
        XCTAssertTrue(gallery.exists, "La galería del negocio no tiene el accessibilityLabel correcto.")
        
        // Especialistas
        let specialists = app.staticTexts["Business specialists"]
        XCTAssertTrue(specialists.exists, "La sección de especialistas no tiene el accessibilityLabel correcto.")
        
        // Reseñas del negocio
        let reviews = app.staticTexts["Customer reviews"]
        XCTAssertTrue(reviews.exists, "La sección de reseñas del negocio no tiene el accessibilityLabel correcto.")
    }
    
    func test_AccessibilityLabels_And_Values_InBusinessDetailView() {
        // Verifica el nombre del negocio
        let businessName = app.staticTexts["Business Name"]
        XCTAssertTrue(businessName.exists, "El nombre del negocio no tiene el accessibilityLabel correcto.")
        XCTAssertEqual(businessName.value as? String, "Business Name", "El accessibilityLabel del nombre del negocio no es correcto.")
        
        // Verifica la dirección del negocio
        let businessAddress = app.staticTexts["Business Address"]
        XCTAssertTrue(businessAddress.exists, "La dirección del negocio no tiene el accessibilityLabel correcto.")
        XCTAssertEqual(businessAddress.value as? String, "Business Address", "El accessibilityValue de la dirección del negocio no es correcto.")
        
        // Verifica el estado de apertura del negocio
        let businessStatus = app.staticTexts["Business Status"]
        XCTAssertTrue(businessStatus.exists, "El estado de apertura del negocio no tiene el accessibilityLabel correcto.")
        XCTAssertEqual(businessStatus.value as? String, isOpen ? "Open Today" : "Closed", "El accessibilityValue del estado de apertura del negocio no es correcto.")
        
        // Verifica el descuento y disponibilidad
        let discountAvailability = app.staticTexts["Discount and Availability"]
        XCTAssertTrue(discountAvailability.exists, "El descuento y disponibilidad no tiene el accessibilityLabel correcto.")
        XCTAssertEqual(discountAvailability.value as? String, "-58% discount, 6 places available", "El accessibilityValue del descuento y disponibilidad no es correcto.")
        
        // Verifica la calificación
        let rating = app.staticTexts["Rating"]
        XCTAssertTrue(rating.exists, "La calificación no tiene el accessibilityLabel correcto.")
        XCTAssertEqual(rating.value as? String, "\(rating, specifier: "%.1f") stars, \(reviewsCount) thousand reviews", "El accessibilityValue de la calificación no es correcto.")
        
        // Verifica las vistas
        let views = app.staticTexts["Views"]
        XCTAssertTrue(views.exists, "Las vistas no tienen el accessibilityLabel correcto.")
        XCTAssertEqual(views.value as? String, "\(viewsCount) thousand views", "El accessibilityValue de las vistas no es correcto.")
    }
    
    func test_AccessibilityLabels_And_Values_InReviewsSection() {
        // Verifica el título de la sección de reseñas
        let reviewsTitle = app.staticTexts["Section Title"]
        XCTAssertTrue(reviewsTitle.exists, "El título de la sección de reseñas no tiene el accessibilityLabel correcto.")
        XCTAssertEqual(reviewsTitle.value as? String, "Reviews", "El accessibilityValue del título de la sección de reseñas no es correcto.")
        
        // Verifica el botón "View all"
        let viewAllButton = app.buttons["View all reviews"]
        XCTAssertTrue(viewAllButton.exists, "El botón 'View all' no tiene el accessibilityLabel correcto.")
        
        // Verifica las tarjetas de reseñas individuales
        for review in reviews {
            let reviewElement = app.staticTexts["Review by \(review.commenterName)"]
            XCTAssertTrue(reviewElement.exists, "La tarjeta de reseña de \(review.commenterName) no tiene el accessibilityLabel correcto.")
            XCTAssertEqual(reviewElement.value as? String, "Rating: \(review.rating, specifier: "%.1f") stars. Comment: \(review.description)", "El accessibilityValue de la tarjeta de reseña de \(review.commenterName) no es correcto.")
        }
    }
    
    func test_AccessibilityLabels_And_ValuesInServicesSection() {
        // Verifica el título de la sección "Our Services"
        let servicesTitle = app.staticTexts["Section Title"]
        XCTAssertTrue(servicesTitle.exists, "El título de la sección 'Our Services' no tiene el accessibilityLabel correcto.")
        XCTAssertEqual(servicesTitle.value as? String, "Our Services", "El accessibilityValue del título de la sección 'Our Services' no es correcto.")
        
        // Verifica las tarjetas de servicio individuales
        for service in services {
            let serviceElement = app.staticTexts["Service: \(service.name)"]
            XCTAssertTrue(serviceElement.exists, "La tarjeta de servicio '\(service.name)' no tiene el accessibilityLabel correcto.")
            XCTAssertEqual(serviceElement.value as? String, "Price: \(service.price), Duration: 2 hours, Discount: -20%. Description: \(service.description)", "El accessibilityValue de la tarjeta de servicio '\(service.name)' no es correcto.")
        }
    }
    
    
    func test_AccessibilityLabels_And_ValuesInGallerySection() {
        // Verifica el título de la sección "Gallery"
        let galleryTitle = app.staticTexts["Section Title"]
        XCTAssertTrue(galleryTitle.exists, "El título de la sección 'Gallery' no tiene el accessibilityLabel correcto.")
        XCTAssertEqual(galleryTitle.value as? String, "Gallery", "El accessibilityValue del título de la sección 'Gallery' no es correcto.")
        
        // Verifica las imágenes individuales en la galería
        for (index, image) in images.enumerated() {
            let imageElement = app.images["Gallery Image"]
            XCTAssertTrue(imageElement.exists, "La imagen en la posición \(index + 1) en la galería no tiene el accessibilityLabel correcto.")
            XCTAssertEqual(imageElement.value as? String, "Image \(index + 1) of \(images.count)", "El accessibilityValue de la imagen en la posición \(index + 1) en la galería no es correcto.")
        }
    }
    
    func test_AccessibilityLabels_And_Values_InMainImage() {
        // Verificar que la imagen principal tenga los valores correctos de accesibilidad
        let businessImage = app.images["Business Image"]
        
        if businessImage.exists {
            XCTAssertEqual(businessImage.label, "Business Image", "El accessibilityLabel de la imagen principal de negocio no es correcto.")
            XCTAssertEqual(businessImage.value as? String, "Main business image", "El accessibilityValue de la imagen principal de negocio no es correcto.")
        } else {
            // Verificar que el ProgressView tenga los valores correctos de accesibilidad si la imagen está cargando
            let loadingImage = app.otherElements["Loading Image"]
            XCTAssertTrue(loadingImage.exists, "La vista de carga para la imagen principal de negocio no existe.")
            XCTAssertEqual(loadingImage.label, "Loading Image", "El accessibilityLabel de la vista de carga no es correcto.")
            XCTAssertEqual(loadingImage.value as? String, "Loading business image", "El accessibilityValue de la vista de carga no es correcto.")
        }
    }
    
    func test_AccessibilityLabels_And_Values_InOpeningHours() {
        // Verificar que la sección de Opening Hours tenga los valores correctos de accesibilidad
        let openingHoursLabel = app.staticTexts["Opening Hours"]
        XCTAssertTrue(openingHoursLabel.exists, "El label de 'Opening Hours' no existe.")
        XCTAssertEqual(openingHoursLabel.label, "Opening Hours", "El accessibilityLabel de 'Opening Hours' no es correcto.")
        XCTAssertEqual(openingHoursLabel.value as? String, "Hours of operation for the business", "El accessibilityValue de 'Opening Hours' no es correcto.")
        
        // Verificar horarios de lunes a viernes
        let weekdayLabel = app.staticTexts["Monday to Friday"]
        XCTAssertTrue(weekdayLabel.exists, "El label de 'Monday to Friday' no existe.")
        XCTAssertEqual(weekdayLabel.label, "Monday to Friday", "El accessibilityLabel de 'Monday to Friday' no es correcto.")
        XCTAssertEqual(weekdayLabel.value as? String, "Open from 08:00 AM to 03:00 PM", "El accessibilityValue de 'Monday to Friday' no es correcto.")
        
        // Verificar horarios de sábado a domingo
        let weekendLabel = app.staticTexts["Saturday to Sunday"]
        XCTAssertTrue(weekendLabel.exists, "El label de 'Saturday to Sunday' no existe.")
        XCTAssertEqual(weekendLabel.label, "Saturday to Sunday", "El accessibilityLabel de 'Saturday to Sunday' no es correcto.")
        XCTAssertEqual(weekendLabel.value as? String, "Open from 09:00 AM to 02:00 PM", "El accessibilityValue de 'Saturday to Sunday' no es correcto.")
    }
    
    func test_AccessibilityLabels_And_Values_InOurSpecialists() {
        // Verificar que la sección de Our Specialists tenga los valores correctos de accesibilidad
        let specialistsLabel = app.staticTexts["Our Specialists"]
        XCTAssertTrue(specialistsLabel.exists, "El label de 'Our Specialists' no existe.")
        XCTAssertEqual(specialistsLabel.label, "Our Specialists", "El accessibilityLabel de 'Our Specialists' no es correcto.")
        XCTAssertEqual(specialistsLabel.value as? String, "List of specialists available at the business", "El accessibilityValue de 'Our Specialists' no es correcto.")
        
        // Verificar los especialistas en la lista
        for specialist in specialists {
            let specialistLabel = app.staticTexts[specialist.name]
            XCTAssertTrue(specialistLabel.exists, "El label de '\(specialist.name)' no existe.")
            XCTAssertEqual(specialistLabel.label, specialist.name, "El accessibilityLabel de '\(specialist.name)' no es correcto.")
            XCTAssertEqual(specialistLabel.value as? String, "Specialist available", "El accessibilityValue de '\(specialist.name)' no es correcto.")
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
