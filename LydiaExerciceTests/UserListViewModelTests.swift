//
//  UserListViewModelTests.swift
//  LydiaExerciceTests
//
//  Created by Karbonyth on 28/03/2023.
//

import XCTest
import CoreData

final class UserListViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchingUsers() throws {
        let expectation = expectation(description: "Fetching Users")
        let delegate = TestingDelegate(expectation)
        let test = UserListViewModel(delegate: delegate,
                                     dataSource: TestingUserRemoteDataSource())
        
        test.fetchUsers()
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(test.users.count, 1)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    class TestingDelegate: UserListDelegate {
        
        let expectation: XCTestExpectation
        
        init(_ expectation: XCTestExpectation) {
            self.expectation = expectation
        }

        func willStartFetchingUsers() {}
        func didFailFetchingUsers(with error: Error) {}
        func didFinishFetchingUsers() {
            expectation.fulfill()
        }
    }
    
    class TestingUserRemoteDataSource: UserRemoteDataSource {
        
        override func fetchUsers(page: Int, seed: String) async throws -> [User] {
            UserListViewModelTests.mockedUsers
        }
        
    }
    
    static var mockedUsers = [
        User(name: User.UserName(first: "Jack",
                                 last: "Black",
                                 title: "Mister"),
             picture: User.UserPicture(url: ""),
             birthInfo: User.BirthInfo(date: "",
                                       age: 32))
    ]
    
}

// MARK: Mock UserRepository Implementation
extension UserRepository {
    func saveUsers(newUsers: [User]) { }
    func loadUsers() -> [User] { [] }
}
