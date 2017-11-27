//
//  FreeLunchTests.swift
//  FreeLunchTests
//
//  Created by Johns Gresham on 11/25/17.
//  Copyright © 2017 Johns Gresham. All rights reserved.
//

import XCTest
@testable import FreeLunch

class FreeLunchTests: XCTestCase {
    
    //MARK: Account Class Tests
    // Confirm that the Account initializer returns an Account object when passed valid parameters.
    func testAccountInitializationSucceeds() {
        // No token
        let accountNameAndPass = Account.init(username: "jsgresham", password: "Gorilla99%", token: nil)
        XCTAssertNotNil(accountNameAndPass)
        // Token
        let accountFull = Account.init(username: "jsgresham", password: "Gorilla99%", token: "ABCD")
        XCTAssertNotNil(accountFull)
    }
    // Confirm that the Account initialier returns nil when passed a an empty username or password.
    func testMealInitializationFails() {
        // No username
        let emptyUsername = Account.init(username: "", password: "Gorilla99%", token: nil)
        XCTAssertNil(emptyUsername)
        // No password
        let emptyPassword = Account.init(username: "jsgresham", password: "", token: nil)
        XCTAssertNil(emptyPassword)
    }
}
