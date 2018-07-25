//
//  ObjectMapperTests.swift
//  ObjectMapperTests
//
//  Created by Matteo Sassano on 24.07.18.
//  Copyright © 2018 Matteo Sassano. All rights reserved.
//

import XCTest
import ObjectMapper

class ObjectMapperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMappingSimpleClass() {
        let jsonString = """
            {
                "a": 99
            }
            """
        if let data: Data = jsonString.data(using: .utf8) {
            if let object = ObjectMapper<TestClassA>().map(data: data) {
                XCTAssertEqual(object.a, 99, "testMappingSimpleClass failed")
            }
        }
    }
    
    func testMappingSimpleClassWithRemap() {
        let jsonString = """
            {
                "b": 99
            }
            """
        var renaming = [String: String]()
        renaming["b"] = "a"
        if let data: Data = jsonString.data(using: .utf8) {
            if let object = ObjectMapper<TestClassA>().map(data: data, renaming: renaming) {
                XCTAssertEqual(object.a, 99, "testMappingSimpleClassWithRemap failed")
            }
        }
    }
    
    func testComplexClass() {
        let jsonString = """
            {
                "a": 99,
                "instance": {
                    "a": 100
                }
            }
            """
        if let data: Data = jsonString.data(using: .utf8) {
            if let object = ObjectMapper<TestClassB>().map(data: data) {
                XCTAssertEqual(object.a, 99, "testComplexClass failed")
                XCTAssertEqual(object.instanceC.a, 100, "testComplexClass failed")
            }
        }
    }
    
}

class TestClassA: Codable {

    var a: Int = 0

}

class TestClassB: Codable {
    
    var a: Int = 0
    var instanceC: TestClassC = TestClassC()
    
}

class TestClassC: Codable {
    
    var a: Int = 0
    
}
