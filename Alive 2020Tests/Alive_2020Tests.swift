//
//  Alive_2020Tests.swift
//  Alive 2020Tests
//
//  Created by Mark Stultz on 4/20/17.
//  Copyright © 2017 Summer League. All rights reserved.
//

import XCTest
@testable import Alive_2020

class Alive_2020Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
   
//    func testCreate() {
//        let create = expectation(description: "create")
//        
//        let service = Service()
//        service.create(
//            username: "username",
//            email: "email",
//            password: "password" { user in
//                print("Success: \(user)")
//                create.fulfill()
//        }
//        
//        waitForExpectations(timeout: 10.0, handler: nil)
//    }
    
    func testLogin() {
        let login = expectation(description: "login")
        
        let service = Service()
        service.login(username: "mstultz", password: "al1v3-2020") { user in
            login.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testPrimaryStory() {
        let primaryStory = expectation(description: "primaryStory")
        
        let service = Service()
        service.primaryStory(userId: 1) { story in
            guard story != nil else { return XCTFail() }
            primaryStory.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
