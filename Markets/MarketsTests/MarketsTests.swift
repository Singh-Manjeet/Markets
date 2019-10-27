//
//  MarketsTests.swift
//  MarketsTests
//
//  Created by Manjeet Singh on 23/10/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import XCTest
@testable import Markets

class MarketTests: XCTestCase {
    
    func testIfDataManagerReturnsAppropriateData() {
        // 1. Setup the expectation
        let expectation = XCTestExpectation(description: "DataManager fetches data and returns appropriate data")
        
        // 2. Exercise and verify the behaviour as usual
        DataManager.shared.getBitcoinPrices(onCompletion: { result in
            
            switch result {
            case .success(let price):
                XCTAssertTrue(price.detail != nil)
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        })
    }
    
    func testIfOrderViewModelReturnsAppropriateDataState() {
        // 1. Setup the expectation
        let expectation = XCTestExpectation(description: "Order View Model fetches data and returns appropriate data")
        
        // 2. Exercise and verify the behaviour as usual
        
        OrderViewModel.fetch { state in
            
            switch state {
            case .loaded(let price):
                XCTAssertTrue(price != nil)
                expectation.fulfill()
            case .loading, .error:
                XCTFail()
            }
        }
    }
}
