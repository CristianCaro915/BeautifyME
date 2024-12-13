//
//  UserTest.swift
//  BeautifyMeTests
//
//  Created by Cristian Caro on 21/10/24.
//

import XCTest
@testable import BeautifyMe

final class UserTest: XCTestCase {
    
    var viewModel: SignInViewModel!
    let testEmail = "testuser@example.com"
    let testPassword = "Qwerty12"
    let testName = "TestUser"
    let testPhoneNumber = "1234567890"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        viewModel = SignInViewModel()
        
    }
    
    override func tearDownWithError() throws {
        // Teardown para eliminar el usuario de prueba
        let expectation = self.expectation(description: "Delete test user")
        
        viewModel.deleteUserByEmail(email: testEmail) { result in
            switch result {
            case .success:
                print("Test user deleted successfully.")
            case .failure(let error):
                switch error {
                case .invalidEmail:
                    print("No user found with the test email. Nothing to delete.")
                default:
                    print("Failed to delete test user: \(error)")
                }
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        super.tearDown()
    }


    // User standart
    func testCreateUserNullPhone() {
        viewModel.name = testName
        viewModel.email = testEmail
        viewModel.password = testPassword
        viewModel.phone = "" // Caso nulo

        let expectation = XCTestExpectation(description: "Create user should fail due to null phone")

        viewModel.createUser { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, ErrorManager.invalidPhone, "Error esperado: invalidPhone")
                expectation.fulfill()
            case .success:
                XCTFail("La creación del usuario no debería tener éxito")
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testCreateUserNullUsername() {
        viewModel.name = "" // Caso nulo
        viewModel.email = testEmail
        viewModel.password = testPassword
        viewModel.phone = testPhoneNumber

        let expectation = XCTestExpectation(description: "Create user should fail due to null username")

        viewModel.createUser { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, ErrorManager.invalidUsername, "Error esperado: invalidUsername")
                expectation.fulfill()
            case .success:
                XCTFail("La creación del usuario no debería tener éxito")
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testCreateUserWithDuplicateEmail() {
        let expectation1 = self.expectation(description: "Create first user")
        let expectation2 = self.expectation(description: "Fail to create second user with duplicate email")

        // Primer usuario
        viewModel.email = testEmail
        viewModel.name = testName
        viewModel.password = testPassword
        viewModel.phone = testPhoneNumber
        viewModel.createUser { result in
            switch result {
            case .success:
                expectation1.fulfill()
            case .failure(let error):
                XCTFail("La creación del primer usuario falló: \(error)")
            }
        }

        wait(for: [expectation1], timeout: 10.0)

        // Segundo usuario con el mismo email
        viewModel.name = "anotherName"
        viewModel.createUser { result in
            switch result {
            case .success:
                XCTFail("La creación del segundo usuario debería fallar debido a un email duplicado")
            case .failure:
                expectation2.fulfill()
            }
        }

        wait(for: [expectation2], timeout: 10.0)
    }
    
    func testCreateUserWithDuplicateName() {
        let expectation1 = self.expectation(description: "Create first user with unique name")
        let expectation2 = self.expectation(description: "Fail to create second user with duplicate name")

        // Primer usuario
        viewModel.email = testEmail
        viewModel.name = testName
        viewModel.password = testPassword
        viewModel.phone = testPhoneNumber
        viewModel.createUser { result in
            switch result {
            case .success:
                expectation1.fulfill()
            case .failure(let error):
                XCTFail("La creación del primer usuario falló: \(error)")
            }
        }

        wait(for: [expectation1], timeout: 5.0)

        // Segundo usuario con el mismo nombre
        viewModel.email = "second@example.com" // diferente para que no falle por eso
        viewModel.createUser { result in
            switch result {
            case .success:
                XCTFail("La creación del segundo usuario debería fallar debido a un nombre duplicado")
            case .failure:
                expectation2.fulfill()
            }
        }

        wait(for: [expectation2], timeout: 5.0)
    }



    func testCreateUserWithNonExistentRole() {
        viewModel.name = testName
        viewModel.email = testEmail
        viewModel.password = testPassword
        viewModel.phone = testPhoneNumber
        
        let expectation = XCTestExpectation(description: "Update user role should fail due to non-existent role")
        // Simulación: Usar un rol no existente (actualiza en función de tu servidor)
        viewModel.updateUserRole(currentUserId: 999, jwtToken: "validToken", isAdmin: false) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, ErrorManager.serverError, "Error esperado: serverError por rol no existente")
                expectation.fulfill()
            case .success:
                XCTFail("La actualización del rol no debería tener éxito")
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func testCreateUserSuccess() {
        let expectation = self.expectation(description: "Create user successfully")

        viewModel.email = testEmail
        viewModel.name = testName
        viewModel.password = testPassword
        viewModel.phone = testPhoneNumber
        viewModel.createUser{ result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("La creación del usuario falló: \(error)")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

}
