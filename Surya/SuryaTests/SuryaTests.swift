//
//  SuryaTests.swift
//  SuryaTests
//
//  Created by Abdul on 21/02/19.
//  Copyright © 2019 VirtualEmployee. All rights reserved.
//

import XCTest
@testable import Surya

class SuryaTests: XCTestCase {

    var urlSession: URLSession!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        urlSession = URLSession.shared
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        urlSession.invalidateAndCancel()
    }

    func testFetchList() {
        var parameter = [String : Any]()
        parameter["emailId"] = "abdul@gmail.com"
        
        let promise = expectation(description: "Status Code: 200")

        let Url = Constants.API.baseURL + Constants.API.getList
        guard let serviceUrl = URL(string: Url) else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        urlSession.dataTask(with: request) { (data, response, error) in
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if statusCode == 200 && error == nil {
                promise.fulfill()
            }
            

            XCTAssertNil(error)
            
            }.resume()
        
        waitForExpectations(timeout: 5, handler: nil)

    }

}
