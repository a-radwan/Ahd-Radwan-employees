//
//  FileUtilsTests.swift
//  SirmaTaskTests
//
//  Created by Ahd on 11/27/23.
//

import XCTest
@testable import SirmaTask

final class FileUtilsTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testReadFile() {

        let bundle = Bundle(for: type(of: self))
        guard let filePath = bundle.url(forResource: "TestFile", withExtension: "txt") else {
            XCTFail("Test file not found")
            return
        }
        
        let fileContents = FileUtils.readFile(filePath: filePath)
        
        XCTAssertNotNil(fileContents, "File contents should not be nil")
        XCTAssertTrue(fileContents!.contains("Hello,World"), "File contents should contain 'Hello,World'")
    }
    
    func testRowsFromCSVString() {

        let csvString = "143,12,2013-11-01,2014-01-05\r\n218,10,2012-05-16,\r\n122,15,2021-08-16,"
        
        let rows = FileUtils.rowsFrom(csvString: csvString)
        
        XCTAssertEqual(rows.count, 3, "Expected 3 rows")
        XCTAssertEqual(rows[0], ["143", "12", "2013-11-01", "2014-01-05"], "First row should match")
        XCTAssertEqual(rows[1], ["218", "10", "2012-05-16", ""], "Second row should match")
        XCTAssertEqual(rows[2], ["122", "15", "2021-08-16", ""], "Third row should match")
    }
    
    
}
