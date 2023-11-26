//
//  WorkRecordMapperTests.swift
//  SirmaTaskTests
//
//  Created by Ahd on 11/27/23.
//

import XCTest
@testable import SirmaTask

final class WorkRecordMapperTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMapToModel() {

        let csvRows = [
            ["143", "12", "2013-11-01", "2014-01-05"],
            ["218", "10", "2012-05-16", nil],
            ["143", "10", "2009-01-01", "2012-06-16"],
            ["122", "10", "2012-05-01", "2012-05-17"]
        ]
        
        let workRecords = WorkRecordMapper.mapToModel(csvRows: csvRows)
        
        // Assertions
        XCTAssertEqual(workRecords.count, 4, "Expected 4 WorkRecord instances")
        XCTAssertEqual(workRecords[0].empID, "143", "EmpID should match")
        XCTAssertEqual(workRecords[1].projectID, "10", "ProjectID should match")
        XCTAssertNotNil(workRecords[2].dateTo, "DateTo should not be nil")
    }
    
    func testParseDate() {

        let dateString = "2023-11-24"
        let dateFormats = ["yyyy-MM-dd"]
        
        let parsedDate = WorkRecordMapper.parseDate(dateString: dateString, dateFormats: dateFormats)
        
        XCTAssertNotNil(parsedDate, "Date should be parsed successfully")
        
        let expectedDate = Date.createDate(year: 2023, month: 11, day: 24)
        XCTAssertEqual(parsedDate, expectedDate, "Parsed date should match the expected date")
    }
    

    
}
