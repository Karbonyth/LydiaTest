//
//  UserListViewModelTests.swift
//  LydiaExerciceTests
//
//  Created by Stephen Sement on 28/03/2023.
//

import XCTest
import CoreData

final class UserListViewModelTests: XCTestCase {
    
    private var viewModel: UserListViewModel?

    override func setUpWithError() throws {
        viewModel = UserListViewModel(remoteRepository: TestingUserRemoteRepository(),
                                      localRepository: TestingUserLocalRepository())
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testInitialFetch() throws {
        let expectation = expectation(description: "Initial Fetch")
        let delegate = TestingDelegate(expectation)
        viewModel?.delegate = delegate
        
        XCTAssertEqual(viewModel?.getUserCount(), 0)
        viewModel?.fetchUsers(fetchType: .initial)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel?.getUserCount(), 1)
    }
    
    func testFetchingUsers() throws {
        let expectation = expectation(description: "Remote Fetch")
        let delegate = TestingDelegate(expectation)
        viewModel?.delegate = delegate
        
        XCTAssertEqual(viewModel?.getUserCount(), 0)
        viewModel?.fetchUsers(fetchType: .fetch(newBatch: true))
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel?.getUserCount(), 3)
    }
    
    func testFetchingUsersDifferentBatch() throws {
        let initialFetchExpectation = expectation(description: "Initial Remote Fetch")
        let delegate1 = TestingDelegate(initialFetchExpectation)
        viewModel?.delegate = delegate1

        XCTAssertEqual(viewModel?.getUserCount(), 0)
        viewModel?.fetchUsers(fetchType: .fetch(newBatch: true))
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel?.getUserCount(), 3)

        let secondFetchExpectation = expectation(description: "Second Remote Fetch")
        let delegate2 = TestingDelegate(secondFetchExpectation)
        viewModel?.delegate = delegate2

        viewModel?.fetchUsers(fetchType: .fetch(newBatch: true))
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel?.getUserCount(), 3)
    }
    
    func testFetchingUsersSameBatch() throws {
        let initialFetchExpectation = expectation(description: "Initial Remote Fetch")
        let delegate1 = TestingDelegate(initialFetchExpectation)
        viewModel?.delegate = delegate1

        XCTAssertEqual(viewModel?.getUserCount(), 0)
        viewModel?.addUser(user: UserListViewModelTests.mockedUser)
        XCTAssertEqual(viewModel?.getUserCount(), 1)
        viewModel?.fetchUsers(fetchType: .fetch(newBatch: true))
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel?.getUserCount(), 3)

        let secondFetchExpectation = expectation(description: "Second Remote Fetch")
        let delegate2 = TestingDelegate(secondFetchExpectation)
        viewModel?.delegate = delegate2

        viewModel?.fetchUsers(fetchType: .fetch(newBatch: false))
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel?.getUserCount(), 6)
    }
    
    func testPurgingUsers() throws {
        let expectation = expectation(description: "Purging Users")
        let delegate = TestingDelegate(expectation)
        viewModel?.delegate = delegate

        XCTAssertEqual(viewModel?.getUserCount(), 0)
        viewModel?.addUser(user: UserListViewModelTests.mockedUser)
        XCTAssertEqual(viewModel?.getUserCount(), 1)
        viewModel?.purgeData()
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel?.getUserCount(), 0)
    }
    
    func testGettingFilteredUsers() throws {
        viewModel?.addUser(user: UserListViewModelTests.mockedUser)
        let unfilteredUsers = viewModel?.getUsers()
        XCTAssertEqual(unfilteredUsers?.count, 1)
        let filteredUsers = viewModel?.getUsers(filteredBy: "qwerty")
        XCTAssertEqual(filteredUsers?.count, 0)
    }
    
    func testFetchingUsersWithFailure() async throws {
        let remoteRepository = TestingUserRemoteFailureRepository()
        let localRepository = TestingUserLocalRepository()
        let expectation = expectation(description: "Remote Fetch Fail")
        let delegate = TestingDelegate(expectation)
        let viewModel = UserListViewModel(delegate: delegate, remoteRepository: remoteRepository, localRepository: localRepository)

        do {
            viewModel.fetchUsers(fetchType: .fetch(newBatch: true))
            await waitForExpectations(timeout: 5, handler: nil)
            let _ = try await remoteRepository.fetchUsers(page: 0, seed: "")
            XCTFail("Should have been an error here")
        } catch let error as RequestError {
            XCTAssertEqual(error.localizedDescription, RequestError.noResponse.localizedDescription)
        }
    }
    
    // MARK: Mocks
    
    class TestingDelegate: UserListDelegate {
        
        let expectation: XCTestExpectation
        
        init(_ expectation: XCTestExpectation) {
            self.expectation = expectation
        }

        func willStartFetchingUsers() {}
        func didFailFetchingUsers(with error: Error) {
            expectation.fulfill()
        }
        func didFetchUsers(updateType: UserListUpdateType) {
            expectation.fulfill()
        }
        func didPurgeUsers() {
            expectation.fulfill()
        }
    }
    
    class TestingUserLocalRepository: UserLocalRepository {
        override func saveUsersToPersistence(newUsers: [User]) {}
        override func loadUsersFromPersistence() -> [User] {
            [UserListViewModelTests.mockedUser]
        }
        override func purgeUsersFromPersistence() {}
        override func saveSeedToPersistence(seed: String) {}
        override func loadSeedFromPersistence() -> String? { return nil }
        override func purgeSeedFromPersistence() {}
    }
    
    class TestingUserRemoteRepository: UserRemoteRepository {
        override func fetchUsers(page: Int, seed: String) async throws -> [User] {
            UserListViewModelTests.mockedUsers
        }
    }
    
    class TestingUserRemoteFailureRepository: UserRemoteRepository {
        override func fetchUsers(page: Int, seed: String) async throws -> [User] {
            throw RequestError.noResponse
        }
    }
    
    static var mockedUser = User(name: User.UserName(first: "Jack",
                                                     last: "Black",
                                                     title: "Mister"),
                                 gender: .male,
                                 picture: User.UserPicture(url: ""),
                                 birthInfo: User.BirthInfo(date: "",
                                                           age: 32),
                                 contactInfo: User.ContactInfo(homePhone: "666",
                                                               mobilePhone: "777"))
    
    static var mockedUsers = [
        User(name: User.UserName(first: "Jack",
                                 last: "Black",
                                 title: "Mister"),
             gender: .male,
             picture: User.UserPicture(url: ""),
             birthInfo: User.BirthInfo(date: "",
                                       age: 32),
             contactInfo: User.ContactInfo(homePhone: "666",
                                           mobilePhone: "777")),
        User(name: User.UserName(first: "Jack",
                                 last: "Black",
                                 title: "Mister"),
             gender: .male,
             picture: User.UserPicture(url: ""),
             birthInfo: User.BirthInfo(date: "",
                                       age: 32),
             contactInfo: User.ContactInfo(homePhone: "666",
                                           mobilePhone: "777")),
        User(name: User.UserName(first: "Jack",
                                 last: "Black",
                                 title: "Mister"),
             gender: .male,
             picture: User.UserPicture(url: ""),
             birthInfo: User.BirthInfo(date: "",
                                       age: 32),
             contactInfo: User.ContactInfo(homePhone: "666",
                                           mobilePhone: "777"))
    ]
    
}
