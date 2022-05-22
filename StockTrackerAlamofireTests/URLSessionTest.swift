//
//  StockTrackerAlamofireTests.swift
//  StockTrackerAlamofireTests
//
//  Created by Эрмек Жоробеков on 16.04.2022.
//

import XCTest
@testable import StockTrackerAlamofire

class StockTrackerAlamofireTests: XCTestCase {
    
    var sut: URLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
    
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testValidApiCallGetsHTTPStatusCode200() {
        let urlString = "https://financialmodelingprep.com/api/v3/quote/AAPL?apikey=a15af8fcd7e5332f5022f0ccca771b00"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Status code: 200")
        var statusCode: Int?
        var responseError: Error?
        
        let dataTask = sut.dataTask(with: url) { _, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 10)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    

    func testPerformanceExample() {
        measure {
            
        }
    }

}
