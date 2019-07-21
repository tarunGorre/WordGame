//
//  JsonParserTests.swift
//  WordGameTests
//
//  Created by Tarun Gorre on 19.07.19.
//  Copyright © 2019 Tarun Gorre. All rights reserved.
//

import XCTest
@testable import WordGame

class JsonParserTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testJsonDecoding() {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "words", withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return
        }
        
        guard let results = try? JSONDecoder().decode([WordModel].self, from: data) else {
            return
        }
        
        XCTAssertEqual(results.count, 297)
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
