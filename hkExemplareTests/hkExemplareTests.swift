//
//  hkExemplareTests.swift
//  hkExemplareTests
//
//  Created by Anderson Santos Gusmao on 26/09/17.
//  Copyright © 2017 Heuristisk. All rights reserved.
//

import XCTest
@testable import hkExemplare

class hkExemplareTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        
        let expectationResult = expectation(description: "Connect to server...")
        
        Api.getMovies { (response) in
            switch response {
            case .sucess(let source):
                if source.value.count > 0 {
                    expectationResult.fulfill()
                } else {
                    XCTFail("No results found.")
                }
                break
            case .error(let reason):
                 XCTFail("No results found. \(reason)")
                break
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testPerformanceExample() {
        self.measure {
            self.testExample()
        }
    }
    
}
