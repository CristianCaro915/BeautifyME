//
//  InvoiceTest.swift
//  BeautifyMeTests
//
//  Created by Cristian Caro on 21/10/24.
//

import XCTest

final class InvoiceTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateInvoiceWithNonExistentReservationId() {
        // Given
        let viewModel = ViewModelInvoice()
        let invoice = Invoice(reservationId: 999, paymentDate: Date(), totalValue: 1000)
        
        // When
        let result = viewModel.createInvoice(invoice: invoice)
        
        // Then
        XCTAssertFalse(result.isSuccess)
    }
    func testCreateInvoiceWithNullTotalValue() {
        // Given
        let viewModel = ViewModelInvoice()
        let invoice = Invoice(reservationId: 1, paymentDate: Date(), totalValue: 0)
        
        // When
        let result = viewModel.createInvoice(invoice: invoice)
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.errorMessage, "Total value must be greater than zero")
    }
    func testGetInvoiceByNonExistentId() {
        // Given
        let viewModel = ViewModelInvoices()
        let nonExistentId = 999
        
        // When
        let result = viewModel.getInvoice(by: nonExistentId)
        
        // Then
        XCTAssertNil(result)
    }
    func testDeleteInvoiceWithWrongId() {
        // Given
        let viewModel = ViewModelInvoice()
        let nonExistentId = 999
        
        // When
        let result = viewModel.deleteInvoice(id: nonExistentId)
        
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
