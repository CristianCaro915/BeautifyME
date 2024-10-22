//
//  CommentTest.swift
//  BeautifyMeTests
//
//  Created by Cristian Caro on 21/10/24.
//

import XCTest

final class CommentTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateCommentWithNonExistentUser() {
        // Given
        let viewModel = ViewModelComment()
        let nonExistentUserId = 999
        let comment = Comment(id: 1, description: "Great service!", rating: 5, commenterName: "Unknown User", commenterImage: "unknown.png")
        
        // When
        let result = viewModel.createComment(comment: comment, userId: nonExistentUserId)
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.errorMessage, "User not found")
    }
    func testCreateCommentWithNullDescription() {
        // Given
        let viewModel = ViewModelComment()
        let comment = Comment(id: 1, description: "", rating: 5, commenterName: "John Doe", commenterImage: "john.png")
        
        // When
        let result = viewModel.createComment(comment: comment, userId: 1)
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.errorMessage, "Description is required")
    }

    func testCreateCommentWithNullRanking() {
        // Given
        let viewModel = ViewModelComment()
        let comment = Comment(id: 1, description: "Good service", rating: 0, commenterName: "John Doe", commenterImage: "john.png")
        
        // When
        let result = viewModel.createComment(comment: comment, userId: 1)
        
        // Then
        XCTAssertFalse(result.isSuccess)
        XCTAssertEqual(result.errorMessage, "Ranking must be between 1 and 5")
    }
    func testGetCommentWithNonExistentId() {
        // Given
        let viewModel = ViewModelComments()
        let nonExistentCommentId = 999
        
        // When
        let result = viewModel.getComment(by: nonExistentCommentId)
        
        // Then
        XCTAssertNil(result)
    }
    func testDeleteCommentWithWrongId() {
        // Given
        let viewModel = ViewModelComment()
        let wrongCommentId = 999
        
        // When
        let result = viewModel.deleteComment(id: wrongCommentId)
        
        // Then
        XCTAssertFalse(result.isSuccess)
    }
    func testDeleteCommentWithWrongId() {
        // Given
        let viewModel = ViewModelComment()
        let wrongCommentId = 999
        
        // When
        let result = viewModel.deleteComment(id: wrongCommentId)
        
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
