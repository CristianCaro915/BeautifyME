//
//  EmployeeTest.swift
//  BeautifyMeTests
//
//  Created by Cristian Caro on 21/10/24.
//

import XCTest
import Combine
@testable import BeautifyMe

final class EmployeeTest: XCTestCase {
    var dataViewModel: DataViewModel!
    var viewModel: EmployeeViewModel!
    var sessionManager: SessionManager!
    var signInViewModel: SignInViewModel!
    var businessViewModel: BusinessViewModel!
    
    private var cancellables = Set<AnyCancellable>()
    
    let adminEmail = "admin@test.com"
    let testPassword = "Qwerty12"
    let testEmployeeID = 9999
    let testEmployeeName = "Test-Employee"
    var adminUserID: Int?
    var createdBusinessID: Int?
    var createdEmployeeID: Int?
    
    override func setUpWithError() throws {
        dataViewModel = DataViewModel.shared
        sessionManager = SessionManager.shared
        signInViewModel = SignInViewModel(sessionManager: sessionManager)
        viewModel = EmployeeViewModel(sessionManager: sessionManager)
        businessViewModel = BusinessViewModel(sessionManager: sessionManager)
        
        let userExpectation = expectation(description: "Create admin user")
        let fetchExpectation = expectation(description: "Create business and updated businesses")
        
        // 1. Llama a la función para crear el usuario
        createUser(email: adminEmail, isAdmin: true) { [weak self] result in
            switch result {
            case .success(let userID):
                self?.adminUserID = userID
                print("Admin created with ID: \(userID)")
                userExpectation.fulfill()
            case .failure(let error):
                XCTFail("Failed to create admin: \(error)")
                userExpectation.fulfill()
            }
        }
        // 2. Esperar 10 segundos para asegurar la creación del usuario
        wait(for: [userExpectation], timeout: 10.0)
        
        
        // 2. Crear el negocio
        createBusiness { [weak self] result in
            switch result {
            case .success(let businessID):
                self?.createdBusinessID = businessID
                print("Business created with ID: \(businessID)")
                
                // Llamar a fetchBusinesses y esperar hasta que el nuevo negocio esté en la lista
                self?.dataViewModel.fetchBusinesses()
                self?.dataViewModel.waitForBusinessWithID(businessID: businessID) { success in
                    if success {
                        print("Business \(businessID) found in list.")
                    } else {
                        XCTFail("Business \(businessID) did not appear in the list in time.")
                    }
                    fetchExpectation.fulfill()
                }
                
            case .failure(let error):
                XCTFail("Failed to create business: \(error)")
                fetchExpectation.fulfill()
            }
        }
        wait(for: [fetchExpectation], timeout: 10.0)
    }
    
    override func tearDownWithError() throws {
        
        let deleteGroup = DispatchGroup()
        
        // 1. Eliminar empleado si fue creado
        if let employeeID = createdEmployeeID {
            deleteGroup.enter()
            viewModel.deleteEmployee(employeeID: employeeID) { result in
                switch result {
                case .success:
                    print("Employee deleted successfully.")
                case .failure(let error):
                    print("Failed to delete employee: \(error)")
                }
                deleteGroup.leave()
            }
        }
        
        // 2. Eliminar negocio creado
        if let businessID = createdBusinessID {
            deleteGroup.enter()
            businessViewModel.deleteBusiness(businessID: businessID) { result in
                switch result {
                case .success:
                    print("Business deleted successfully.")
                case .failure(let error):
                    print("Failed to delete business: \(error)")
                }
                deleteGroup.leave()
            }
        }
        
        // 3. Eliminar usuario admin
        if let adminUserID = adminUserID {
            deleteGroup.enter()
            signInViewModel.deleteUserByEmail(email: adminEmail) { result in
                switch result {
                case .success:
                    print("Admin user deleted successfully.")
                case .failure(let error):
                    print("Failed to delete admin user: \(error)")
                }
                deleteGroup.leave()
            }
        }
        
        let result = deleteGroup.wait(timeout: .now() + 10)
        if result == .timedOut {
            print("Teardown timed out, some deletions might not have completed.")
        }
        
        // Reset
        viewModel = nil
        signInViewModel = nil
        sessionManager = nil
        businessViewModel = nil
    }
    
    private func createUser(email: String, isAdmin: Bool, completion: @escaping (Result<Int, ErrorManager>) -> Void) {
        signInViewModel.email = email
        signInViewModel.password = testPassword
        signInViewModel.name = "Admin-User"
        signInViewModel.phone = "123456789"
        
        // 1. Crear el usuario
        signInViewModel.createUser { [weak self] result in
            switch result {
            case .success:
                // 2. Pausa el hilo principal por 3 segundos para esperar a que se actualice el userID
                Thread.sleep(forTimeInterval: 3)
                
                guard let userID = self?.signInViewModel.userId else {
                    completion(.failure(.invalidUserId))
                    return
                }
                
                print("User created successfully. Updating role...")
                
                // 3. Actualizar el rol a admin
                self?.signInViewModel.updateUserRole(
                    currentUserId: userID,
                    jwtToken: self?.sessionManager.jwtToken ?? "",
                    isAdmin: isAdmin
                ) { roleResult in
                    switch roleResult {
                    case .success:
                        completion(.success(userID))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func createBusiness(completion: @escaping (Result<Int, ErrorManager>) -> Void) {
        let businessId = Int.random(in: 1000...9999)  // ID aleatorio para el negocio de prueba
        let businessName = "Test Business"
        let category = "Spa"
        let description = "Test business description"
        let latitude = "45.0"
        let longitude = "-75.0"
        
        // 1. Llamar a createBusiness del ViewModel
        businessViewModel.createBusiness(
            id: businessId,
            name: businessName,
            category: category,
            description: description,
            latitude: latitude,
            longitude: longitude
        ) { result in
            switch result {
            case .success:
                // 2. Esperar 3 segundos para asegurar que la API termine de procesar
                Thread.sleep(forTimeInterval: 3)
                
                let id: Int = self.businessViewModel.businessId!
                print("Business created successfully: \(id)")
                completion(.success(id))
                
            case .failure(let error):
                print("Failed to create business: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    
    
    func testCreateEmployeeNegativeEarnings() {
        let expectation = expectation(description: "Create employee with negative earnings")
        
        viewModel.createEmployee(id: 101, name: testEmployeeName, gender: "Male", mail: "employee@test.com", phone: "123456789", earnings: -500, photoURL: "photo.jpg", businessId: createdBusinessID!, serviceId: 1) { result in
            switch result {
            case .success:
                XCTFail("Employee with negative earnings should not be created.")
            case .failure(let error):
                XCTAssertEqual(error, .invalidEarnings)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    func testCreateEmployeeNullName() {
        let expectation = expectation(description: "Create employee with null name")
        
        viewModel.createEmployee(id: 102, name: nil, gender: "Female", mail: "employee2@test.com", phone: "123456789", earnings: 300, photoURL: "photo.jpg", businessId: createdBusinessID!, serviceId: 1) { result in
            switch result {
            case .success:
                XCTFail("Employee with null name should not be created.")
            case .failure(let error):
                XCTAssertEqual(error, .invalidUsername)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    func testCreateEmployeeCorrectly() {
        let expectation = expectation(description: "Create valid employee")
        
        viewModel.createEmployee(id: 105, name: "Valid Employee", gender: "Male", mail: "employee@test.com", phone: "123456789", earnings: 700, photoURL: "url", businessId: createdBusinessID!, serviceId: 1) { result in
            switch result {
            case .success:
                self.createdEmployeeID = self.viewModel.employeeId
                print("Employee created successfully.")
            case .failure(let error):
                XCTFail("Valid employee creation failed: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCreateEmployeeNullGender() {
        let expectation = expectation(description: "Create employee with null gender")
        
        viewModel.createEmployee(id: 107,name: "Employee No Gender",gender: nil,mail: "nogender@test.com",phone: "123456789",earnings: 700,photoURL: "url",businessId: createdBusinessID!,serviceId: 1) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .invalidGender)
            case .success:
                XCTFail("Employee without gender created.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCreateEmployeeNullMail() {
        let expectation = expectation(description: "Create employee with null email")
        
        viewModel.createEmployee(id: 108,name: "Employee No Email",gender: "Male",mail: nil,phone: "123456789",earnings: 700,photoURL: "url",businessId: createdBusinessID!,serviceId: 1) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .invalidEmail)
            case .success:
                XCTFail("Employee without email created.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCreateEmployeeNullPhone() {
        let expectation = expectation(description: "Create employee with null phone")
        
        viewModel.createEmployee(id: 109,name: "Employee No Phone",gender: "Male",mail: "nophone@test.com",phone: nil,earnings: 700,photoURL: "url",businessId: createdBusinessID!,serviceId: 1) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .invalidPhone)
            case .success:
                XCTFail("Employee without phone created.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testEditEmployeeNegativeEarnings() {
        let expectation = expectation(description: "Edit employee with negative earnings")
        
        viewModel.editEmployee(
            employeeId: testEmployeeID,
            newEarnings: -500
        ) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .invalidEarnings)
            case .success:
                XCTFail("Employee edited with negative earnings.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetEmployeeWrongId() {
        let employee = viewModel.getEmployee(id: 9999)  // Un ID que no existe
        
        XCTAssertEqual(employee.id, 99)  // El ID por defecto del empleado vacío
        XCTAssertEqual(employee.name, "")
        XCTAssertEqual(employee.gender, "")
        XCTAssertEqual(employee.mail, "")
        XCTAssertEqual(employee.phone, "")
        XCTAssertEqual(employee.earnings, 2)
        XCTAssertEqual(employee.photo, "")
        
        print("Employee not found. Default returned.")
    }
    
}
