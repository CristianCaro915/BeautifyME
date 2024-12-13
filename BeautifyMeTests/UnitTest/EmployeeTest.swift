//
//  EmployeeTest.swift
//  BeautifyMeTests
//
//  Created by Cristian Caro on 21/10/24.
//
/*
import XCTest

final class EmployeeTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateEmployeeNegativeEarnings() {
        // Given
        let viewModel = ViewModelEmployee()
        let employee = Employee(id: 1, name: "John Doe", gender: "Male", mail: "john@example.com", phone: "123456789", earnings: -1000, photo: "photo.png")

        // When
        let result = viewModel.createEmployee(employee)

        // Then
        XCTAssertFalse(result.success)
        XCTAssertEqual(result.error, "Earnings cannot be negative")
    }
    func testCreateEmployeeNullName() {
        // Given
        let viewModel = ViewModelEmployee()
        let employee = Employee(id: 1, name: "", gender: "Male", mail: "john@example.com", phone: "3002345677", earnings: 0, photo: "photo.png")

        // When
        let result = viewModel.createEmployee(employee)

        // Then
        XCTAssertFalse(result.success)
    }
    func testCreateEmployeeNullGender() {
        // Given
        let viewModel = ViewModelEmployee()
        let employee = Employee(id: 1, name: "Hector Kaka", gender: "", mail: "hector@example.com", phone: "3002345677", earnings: 0, photo: "photo.png")

        // When
        let result = viewModel.createEmployee(employee)

        // Then
        XCTAssertFalse(result.success)
    }
    func testCreateEmployeeNullPhone() {
        // Given
        let viewModel = ViewModelEmployee()
        let employee = Employee(id: 1, name: "Hector Kaka", gender: "Male", mail: "hector@example.com", phone: "", earnings: 0, photo: "photo.png")

        // When
        let result = viewModel.createEmployee(employee)

        // Then
        XCTAssertFalse(result.success)
    }
    func testEditEmployeeNegativeEarnings() {
        // Given
        let viewModel = ViewModelEmployee()
        let employee = Employee(id: 1, name: "John Doe", gender: "Male", mail: "john@example.com", phone: "123456789", earnings: 1000, photo: "photo.png")
        viewModel.createEmployee(employee) // Create employee first

        // When
        employee.earnings = -500
        let result = viewModel.updateEmployee(employee)

        // Then
        XCTAssertFalse(result.success)
        XCTAssertEqual(result.error, "Earnings cannot be negative")
    }
    func testGetEmployeeWrongId() {
        // Given
        let viewModel = ViewModelEmployees()
        let wrongId = 9999

        // When
        let result = viewModel.getEmployee(by: wrongId)

        // Then
        XCTAssertNil(result)
    }
    func testDeleteEmployeeWrongId() {
        // Given
        let viewModel = ViewModelEmployee()
        let wrongId = 9999

        // When
        let result = viewModel.deleteEmployee(by: wrongId)

        // Then
        XCTAssertFalse(result.success)
        XCTAssertEqual(result.error, "Employee does not exist")
    }



    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
 */
