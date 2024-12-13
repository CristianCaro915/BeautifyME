//
//  BusinessTest.swift
//  BeautifyMeTests
//
//  Created by Cristian Caro on 21/10/24.
//
/*
import XCTest

final class BusinessTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateBusinessWithWrongLatitude() {
        // Given
        let viewModel = ViewModelBusiness()
        let business = Business(id: 1, name: "Test", category: "testCategory", description: "testDescription", images: [], latitude: "invalidLatitude", longitude: "74.064977", gallery: [], logo: "logoURL")
        
        // When
        let result = viewModel.createBusiness(business: business)
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.errorMessage, "Invalid latitude")
    }
    
    func testCreateBusinessWithWrongLongitude() {
        // Given
        let viewModel = ViewModelBusiness()
        let business = Business(id: 1, name: "Test", category: "testCategory", description: "testDescription", images: [], latitude: "4.646363", longitude: "invalidLongitude", gallery: [], logo: "logoURL")
        
        // When
        let result = viewModel.createBusiness(business: business)
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.errorMessage, "Invalid longitude")
    }
    
    func testCreateBusinessWithNullLatitude() {
        // Given
        let viewModel = ViewModelBusiness()
        let business = Business(id: 1, name: "Test", category: "testCategory", description: "testDescription", images: [], latitude: "", longitude: "74.064977", gallery: [], logo: "logoURL")
        
        // When
        let result = viewModel.createBusiness(business: business)
        
        // Then
        XCTAssertFalse(result.isSuccess)
    }

    func testCreateBusinessWithNullLongitude() {
        // Given
        let viewModel = ViewModelBusiness()
        let business = Business(id: 1, name: "Test", category: "testCategory", description: "testDescription", images: [], latitude: "4.646363", longitude: "", gallery: [], logo: "logoURL")
        
        // When
        let result = viewModel.createBusiness(business: business)
        
        // Then
        XCTAssertFalse(result.isSuccess)
    }

    func testCreateBusinessWithNullName() {
        // Given
        let viewModel = ViewModelBusiness()
        let business = Business(id: 1, name: "", category: "testCategory", description: "testDescription", images: [], latitude: "4.646363", longitude: "74.064977", gallery: [], logo: "logoURL")
        
        // When
        let result = viewModel.createBusiness(business: business)
        
        // Then
        XCTAssertFalse(result.isSuccess)
    }

    func testCreateBusinessWithNullDescription() {
        // Given
        let viewModel = ViewModelBusiness()
        let business = Business(id: 1, name: "Test", category: "testCategory", description: "", images: [], latitude: "4.646363", longitude: "74.064977", gallery: [], logo: "logoURL")
        
        // When
        let result = viewModel.createBusiness(business: business)
        
        // Then
        XCTAssertFalse(result.isSuccess)
    }

    func testCreateBusinessWithNullCategory() {
        // Given
        let viewModel = ViewModelBusiness()
        let business = Business(id: 1, name: "Test", category: "", description: "testDescription", images: [], latitude: "4.646363", longitude: "74.064977", gallery: [], logo: "logoURL")
        
        // When
        let result = viewModel.createBusiness(business: business)
        
        // Then
        XCTAssertFalse(result.isSuccess)
    }
    
    func testGetBusinessWithNonExistentId() {
        // Given
        let viewModel = ViewModelBusinesses()
        let nonExistentId = 999
        
        // When
        let result = viewModel.getBusiness(by: nonExistentId)
        
        // Then
        XCTAssertNil(result)
    }
    
    func testDeleteBusinessWithWrongId() {
        // Given
        let viewModel = ViewModelBusiness()
        let wrongId = 999
        
        // When
        let result = viewModel.deleteBusiness(id: wrongId)
        
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
