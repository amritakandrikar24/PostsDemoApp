//
//  PostServiceAndDataTests.swift
//  LeagueMobileChallengeTests
//
//  Created by Amrita Kumar on 8/24/22.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import XCTest
@testable import LeagueMobileChallenge

class PostServiceAndDataTests: XCTestCase {
    var count = 0
    let mockRouter = MockNetworkRouter<EndPointConfig>()
    let service = NetworkCoordinator()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        count = 0
    }

    func testUserData() {
        let expectation = XCTestExpectation(description: "User details")
        service.getAPIResponse(router: mockRouter, requestType: .User, parameter: nil, headers: nil, model: [User].self) { result in
            switch result {
                case .success(let users):
                self.count = users.count
            case .failure(_):
                self.count = 0
                    
                }
            expectation.fulfill()
            
        }
            let result = XCTWaiter.wait(for: [expectation], timeout: 2.0) // wait and store the result
            XCTAssertEqual(result, .completed)
            XCTAssertEqual(count, 10) // check the result is what you expected
    }
    
    func testPostsData() {
        let expectation = XCTestExpectation(description: "Post details")
        service.getAPIResponse(router: mockRouter, requestType: .Post, parameter: nil, headers: nil, model: [Post].self) { result in
            switch result {
                case .success(let users):
                self.count = users.count
            case .failure(_):
                self.count = 0
                    
                }
            expectation.fulfill()
            
        }
            let result = XCTWaiter.wait(for: [expectation], timeout: 2.0) // wait and store the result
            XCTAssertEqual(result, .completed)
            XCTAssertEqual(count, 100) // check the result is what you expected
    }
    
}
