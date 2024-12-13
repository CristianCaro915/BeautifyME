//
//  ReservationTest.swift
//  BeautifyMeTests
//
//  Created by Cristian Caro on 21/10/24.
//
/*
import XCTest

final class ReservationTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateReservationNullFields() {
        // Given
        let viewModel = ViewModelReservation()
        let reservation = Reservation(title: "", observation: "Test", startDate: nil, endDate: nil, userId: 1, serviceId: 1, invoiceId: 1, businessId: 1)

        // When
        let result = viewModel.createReservation(reservation)

        // Then
        XCTAssertFalse(result.success)
        XCTAssertEqual(result.error, "Title, startDate, and endDate cannot be null")
    }
    func testCreateReservationNonExistentEmployee() {
        // Given
        let viewModel = ViewModelReservation()
        let reservation = Reservation(title: "Spa", observation: "Test", startDate: Date(), endDate: Date(), userId: 1, serviceId: 1, invoiceId: 1, businessId: 9999) // Business with non-existent employee

        // When
        let result = viewModel.createReservation(reservation)

        // Then
        XCTAssertFalse(result.success)
    }
    func testCreateReservationNonExistentService() {
        // Given
        let viewModel = ViewModelReservation()
        let reservation = Reservation(title: "Spa", observation: "Test", startDate: Date(), endDate: Date(), userId: 1, serviceId: 9999, invoiceId: 1, businessId: 1) // Non-existent service

        // When
        let result = viewModel.createReservation(reservation)

        // Then
        XCTAssertFalse(result.success)
    }
    func testCreateReservationNonExistentUser() {
        // Given
        let viewModel = ViewModelReservation()
        let reservation = Reservation(title: "Spa", observation: "Test", startDate: Date(), endDate: Date(), userId: 9999, serviceId: 1, invoiceId: 1, businessId: 1) // Non-existent user

        // When
        let result = viewModel.createReservation(reservation)

        // Then
        XCTAssertFalse(result.success)
    }

    func testEditReservationNonExistentInvoice() {
        // Given
        let viewModel = ViewModelReservation()
        var reservation = Reservation(title: "Spa", observation: "Test", startDate: Date(), endDate: Date(), userId: 1, serviceId: 1, invoiceId: 1, businessId: 1)
        reservation.invoiceId = 9999 // Non-existent invoice

        // When
        let result = viewModel.updateReservation(reservation)

        // Then
        XCTAssertFalse(result.success)
    }
    func testEditReservationNonExistentEmployee() {
        // Given
        let viewModel = ViewModelReservation()
        var reservation = Reservation(title: "Spa", observation: "Test", startDate: Date(), endDate: Date(), userId: 1, serviceId: 1, invoiceId: 1, businessId: 1)
        reservation.businessId = 9999 // Non-existent employee

        // When
        let result = viewModel.updateReservation(reservation)

        // Then
        XCTAssertFalse(result.success)
    }
    func testEditReservationNonExistentService() {
        // Given
        let viewModel = ViewModelReservation()
        var reservation = Reservation(title: "Spa", observation: "Test", startDate: Date(), endDate: Date(), userId: 1, serviceId: 1, invoiceId: 1, businessId: 1)
        reservation.serviceId = 9999 // Non-existent service

        // When
        let result = viewModel.updateReservation(reservation)

        // Then
        XCTAssertFalse(result.success)
    }
    func testEditReservationNonExistentUser() {
        // Given
        let viewModel = ViewModelReservation()
        var reservation = Reservation(title: "Spa", observation: "Test", startDate: Date(), endDate: Date(), userId: 1, serviceId: 1, invoiceId: 1, businessId: 1)
        reservation.userId = 9999 // Non-existent user

        // When
        let result = viewModel.updateReservation(reservation)

        // Then
        XCTAssertFalse(result.success)
    }
    func testGetReservationNonExistentId() {
        // Given
        let viewModel = ViewModelReservations()
        let nonExistentId = 9999

        // When
        let result = viewModel.getReservation(by: nonExistentId)

        // Then
        XCTAssertNil(result)
    }
    func testDeleteReservationNonExistent() {
        // Given
        let viewModel = ViewModelReservation()
        let nonExistentId = 9999

        // When
        let result = viewModel.deleteReservation(by: nonExistentId)

        // Then
        XCTAssertFalse(result.success)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
 */
