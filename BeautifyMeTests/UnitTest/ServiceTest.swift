//
//  ServiceTest.swift
//  BeautifyMeTests
//
//  Created by Cristian Caro on 21/10/24.
//
/*
import XCTest

final class ServiceTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateServiceWithNegativePrice() {
        // Given
        let viewModel = ViewModelService()
        let service = Service(id: 1, name: "Spa", description: "Relaxing spa service", price: -100, category: "category1", icon: "spa_icon.png")
        
        // When
        let result = viewModel.createService(service: service)
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.errorMessage, "Price must be a positive value")
    }
    
    func testCreateServiceWithNullName() {
        // Given
        let viewModel = ViewModelService()
        let service = Service(id: 1, name: "", description: "Relaxing spa service", price: 100, category: "category1", icon: "spa_icon.png")
        
        // When
        let result = viewModel.createService(service: service)
        
        // Then
        XCTAssertFalse(result.isSuccess)
    }

    func testCreateServiceWithNullCategory() {
        // Given
        let viewModel = ViewModelService()
        let service = Service(id: 1, name: "Spa", description: "Relaxing spa service", price: 100, category: "", icon: "spa_icon.png")
        
        // When
        let result = viewModel.createService(service: service)
        
        // Then
        XCTAssertFalse(result.isSuccess)
    }

    func testCreateServiceWithNullPrice() {
        // Given
        let viewModel = ViewModelService()
        let service = Service(id: 1, name: "Spa", description: "Relaxing spa service", price: 0, category: "category1", icon: "spa_icon.png")
        
        // When
        let result = viewModel.createService(service: service)
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.errorMessage, "Price must be greater than 0")
    }

    func testCreateServiceWithNullDescription() {
        // Given
        let viewModel = ViewModelService()
        let service = Service(id: 1, name: "Spa", description: "", price: 100, category: "category1", icon: "spa_icon.png")
        
        // When
        let result = viewModel.createService(service: service)
        
        // Then
        XCTAssertFalse(result.isSuccess)
    }
    
    func testCreateServiceWithNonExistentCategory() {
        // Given
        let viewModel = ViewModelService()
        let service = Service(id: 1, name: "Spa", description: "Relaxing spa service", price: 100, category: "nonExistentCategory", icon: "spa_icon.png")
        let categoriesList = ["category1", "category2", "category3", "category4"]
        
        // When
        let result = viewModel.createService(service: service)
        
        // Then
        XCTAssertFalse(result.isSuccess)
    }
    func testCreateServiceWithUniqueName() {
        // Given
        let viewModel = ViewModelService()
        let existingServices = [
            Service(id: 1, name: "Spa", description: "Relaxing spa service", price: 100, category: "category1", icon: "spa_icon.png")
        ]
        let service = Service(id: 2, name: "Spa", description: "New spa service", price: 120, category: "category2", icon: "spa_icon2.png")
        
        // When
        let result = viewModel.createService(service: service, existingServices: existingServices)
        
        // Then
        XCTAssertFalse(result.isSuccess)
    }


    


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
*/
