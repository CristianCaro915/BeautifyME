//
//  UserTest.swift
//  BeautifyMeTests
//
//  Created by Cristian Caro on 21/10/24.
//

import XCTest

final class UserTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // User standart
    func testCreateUser_nullPhone() {
        // Given
        let viewModel = ViewModelUser()
        let user = User(id: 1, username: "JohnDoe", email: "john@example.com", phone: "", role: "admin", imageURL: "image.png")
        
        // When
        let result = viewModel.createUser(user)
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.error, .invalidPhone)
    }
    func testCreateUser_nullRole() {
        // Given
        let viewModel = ViewModelUser()
        let user = User(id: 1, username: "JohnDoe", email: "john@example.com", phone: "123456789", role: "", imageURL: "image.png")
        
        // When
        let result = viewModel.createUser(user)
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.error, .invalidRole)
    }
    func testCreateUser_nullUsername() {
        // Given
        let viewModel = ViewModelUser()
        let user = User(id: 1, username: "", email: "john@example.com", phone: "123456789", role: "admin", imageURL: "image.png")
        
        // When
        let result = viewModel.createUser(user)
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.error, .invalidUsername)
    }
    func testCreateUser_nonUniqueName() {
        // Given
        let viewModel = ViewModelUser()
        let user1 = User(id: 1, username: "JohnDoe", email: "john@example.com", phone: "123456789", role: "admin", imageURL: "image.png")
        let user2 = User(id: 2, username: "JohnDoe", email: "john.doe@example.com", phone: "987654321", role: "user", imageURL: "image2.png")
        viewModel.createUser(user1)
        
        // When
        let result = viewModel.createUser(user2)
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.error, .nonUniqueUsername)
    }
    func testGetUser_wrongId() {
        // Given
        let viewModel = ViewModelUsers()
        
        // When
        let result = viewModel.getUser(byId: 999) // Assuming 999 is non-existent
        
        // Then
        XCTAssertNil(result)
    }
    func testDeleteUser_wrongId() {
        // Given
        let viewModel = ViewModelUsers()
        
        // When
        let result = viewModel.deleteUser(byId: 999) // Assuming 999 is non-existent
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.error, .userNotFound)
    }
    func testCreateUserWithNonExistentRole() {
        // Given
        let viewModel = ViewModelService()
        let user = User(id: 1, username: "JohnDoe", email: "john@example.com", phone: "123456789", role: "nonExistentRole", imageURL: "image.png")
        let roleList = ["role1", "role2", "role3", "role4"]
        
        // When
        let result = viewModel.createUser(user: user)
        
        // Then
        XCTAssertFalse(result.isSuccess)
    }
    
    // User based on role
    /*
     // Given
     userLogsIn (role X)      ************************************************ existing??
     sessionManager has the user
     
     
     // When
     doing a query to a class: Prove permission errors and/or valid cases ************************************ ???
     
     // Then
     XCTAssertFalse(result.isSuccess)
     */

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
