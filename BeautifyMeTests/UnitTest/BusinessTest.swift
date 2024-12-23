//
//  BusinessTest.swift
//  BeautifyMeTests
//
//  Created by Cristian Caro on 21/10/24.
//

import XCTest
import Combine
@testable import BeautifyMe

final class BusinessTest: XCTestCase {
    
    var viewModel: BusinessViewModel!
    var sessionManager: SessionManager!
    var signInViewModel: SignInViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    let adminEmail = "admin@test.com"
    let testPassword = "Qwerty12"
    
    var adminUserID: Int?
    var createdBusinessID: Int?
    
    override func setUpWithError() throws {
        sessionManager = SessionManager.shared
            signInViewModel = SignInViewModel(sessionManager: sessionManager)
            viewModel = BusinessViewModel(sessionManager: sessionManager)
            
            let expectation = expectation(description: "Create admin user")
            
            // 1. Llama a la función para crear el usuario
            createUser(email: adminEmail, isAdmin: true) { [weak self] result in
                switch result {
                case .success(let userID):
                    self?.adminUserID = userID
                    print("Admin created with ID: \(userID)")
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Failed to create admin: \(error)")
                    expectation.fulfill()
                }
            }
            
            // 2. Esperar 10 segundos para asegurar la creación del usuario
            wait(for: [expectation], timeout: 20.0)
    }

    
    override func tearDownWithError() throws {
        let deleteGroup = DispatchGroup()

        // 1. Eliminar el negocio creado si existe
        if let businessID = createdBusinessID {
            deleteGroup.enter()
            viewModel.deleteBusiness(businessID: businessID) { result in
                switch result {
                case .success:
                    print("Test business deleted successfully.")
                case .failure(let error):
                    print("Failed to delete test business: \(error)")
                }
                deleteGroup.leave()
            }
        }
        
        // 2. Eliminar el usuario admin si existe
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
        
        // 3. Esperar hasta que todas las tareas de eliminación terminen
        let result = deleteGroup.wait(timeout: .now() + 10)  // Esperar hasta 10 segundos
        
        // Si el tiempo se agota, imprime un mensaje
        if result == .timedOut {
            print("Teardown timed out, some deletions might not have completed.")
        }
        
        // 4. Limpiar instancias después de finalizar todas las operaciones
        viewModel = nil
        signInViewModel = nil
        sessionManager = nil
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


    
    func testCreateBusinessWithWrongLatitude() {
        let expectation = expectation(description: "Business should not be created with wrong latitude")
        
        viewModel.createBusiness(id: 1, name: "Test Business", category: "Spa", description: "Description", latitude: "200", longitude: "40") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .invalidData)
                expectation.fulfill()
            case .success:
                XCTFail("Business should not be created with invalid latitude.")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCreateBusinessWithWrongLongitude() {
        let expectation = expectation(description: "Business should not be created with wrong longitude")
        
        viewModel.createBusiness(id: 1, name: "Test Business", category: "Spa", description: "Description", latitude: "40", longitude: "200") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .invalidData)
                expectation.fulfill()
            case .success:
                XCTFail("Business should not be created with invalid longitude.")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCreateBusinessWithNullLatitude() {
        let expectation = expectation(description: "Business should not be created with null latitude")
        
        viewModel.createBusiness(id: 3, name: "Test Hair Salon", category: "Beauty", description: "Hair cut", latitude: nil, longitude: "40") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .invalidData)
                expectation.fulfill()
            case .success:
                XCTFail("Business should not be created with null latitude.")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCreateBusinessWithNullLongitude() {
        let expectation = expectation(description: "Business should not be created with null longitude")
        
        viewModel.createBusiness(id: 4, name: "Test Nail Salon", category: "Beauty", description: "Manicure", latitude: "30", longitude: nil) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .invalidData)
                expectation.fulfill()
            case .success:
                XCTFail("Business should not be created with null longitude.")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCreateBusinessWithNullName() {
        let expectation = expectation(description: "Business should not be created with null name")
        
        viewModel.createBusiness(id: 1, name: nil, category: "Spa", description: "Description", latitude: "40", longitude: "40") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .invalidUsername)
                expectation.fulfill()
            case .success:
                XCTFail("Business should not be created with null name.")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCreateBusinessCorrectly() {
        let expectation = expectation(description: "Business should be created correctly")
        
        viewModel.createBusiness(id: 6, name: "Healthy Spa", category: "Wellness", description: "Therapy", latitude: "40", longitude: "40") { result in
            switch result {
            case .failure:
                XCTFail("Business should be created successfully.")
            case .success:
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetBusinessWithNonExistentId() {
        let result = viewModel.getBusiness(by: 999)
        
        switch result {
        case .failure(let error):
            XCTAssertEqual(error, .invalidUserId)
        case .success:
            XCTFail("Business should not exist.")
        }
    }
    
    func testDeleteBusinessWithWrongId() {
        let expectation = expectation(description: "Business deletion should fail")
        
        viewModel.deleteBusiness(businessID: 999) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .invalidUserId)
                expectation.fulfill()
            case .success:
                XCTFail("Business should not be deleted.")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
