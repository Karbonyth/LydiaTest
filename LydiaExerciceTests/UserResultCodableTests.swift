//
//  UserResultCodableTests.swift
//  LydiaExerciceTests
//
//  Created by Stephen Sement on 29/03/2023.
//

import XCTest

final class UserResultCodableTests: XCTestCase {

    func testLocationDecoding() throws {
        guard let url = Bundle(for: type(of: self)).url(forResource: "TestData", withExtension: "json") else {
            fatalError("TestData.json not found")
        }

        let jsonData = try Data(contentsOf: url)
        let result = try JSONDecoder().decode(UsersRequestCodable.self, from: jsonData)
        let user = result.results[0]
        
        XCTAssertEqual(user.gender, "male")
        XCTAssertEqual(user.name.title, "Mr")
        XCTAssertEqual(user.name.first, "John")
        XCTAssertEqual(user.name.last, "Doe")
        XCTAssertEqual(user.email, "john.doe@example.com")
        
        XCTAssertEqual(user.login.uuid, "1234567890")
        XCTAssertEqual(user.login.username, "johndoe")
        XCTAssertEqual(user.login.password, "password")
        XCTAssertEqual(user.login.salt, "salt")
        XCTAssertEqual(user.login.md5, "md5hash")
        XCTAssertEqual(user.login.sha1, "sha1hash")
        XCTAssertEqual(user.login.sha256, "sha256hash")
        
        XCTAssertEqual(user.location.street.number, 123)
        XCTAssertEqual(user.location.street.name, "Main St")
        XCTAssertEqual(user.location.city, "New York")
        XCTAssertEqual(user.location.state, "NY")
        XCTAssertEqual(user.location.country, "United States")
        XCTAssertEqual(user.location.postcode, "10001")
        XCTAssertEqual(user.location.coordinates.latitude, "40.7128")
        XCTAssertEqual(user.location.coordinates.longitude, "74.0060")
        XCTAssertEqual(user.location.timezone.offset, "-5:00")
        XCTAssertEqual(user.location.timezone.description, "Eastern Time")
        
        XCTAssertEqual(user.dob.date, "1990-01-01T00:00:00Z")
        XCTAssertEqual(user.dob.age, 33)
        
        XCTAssertEqual(user.registered.date, "2020-01-01T00:00:00Z")
        XCTAssertEqual(user.registered.age, 3)
        
        XCTAssertEqual(user.phone, "555-555-5555")
        XCTAssertEqual(user.cell, "555-555-5555")
        
        XCTAssertEqual(user.id.name, "SSN")
        XCTAssertEqual(user.id.value, "123-45-6789")
        
        XCTAssertEqual(user.picture.large, "https://large.example.com")
        XCTAssertEqual(user.picture.medium, "https://medium.example.com")
        XCTAssertEqual(user.picture.thumbnail, "https://thumbnail.example.com")
        
        XCTAssertEqual(user.nat, "US")
    }
    
}
