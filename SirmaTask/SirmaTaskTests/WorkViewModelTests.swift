//
//  WorkViewModelTests.swift
//  SirmaTaskTests
//
//  Created by Ahd on 11/27/23.
//

import XCTest

@testable import SirmaTask

class WorkViewModelTests: XCTestCase {

    func testLoadEmployeeFileData() {
        // Arrange
        let viewModel = WorkViewModel()
        let bundle = Bundle(for: type(of: self))
        guard let filePath = bundle.url(forResource: "EmployeesTest", withExtension: "csv") else {
            XCTFail("Test file not found")
            return
        }

        viewModel.loadEmployeeFileData(filePath: filePath)

        XCTAssertNotNil(viewModel.workRecords, "Work records should be loaded")
        XCTAssertNil(viewModel.error, "No error should be present")
    }

    func testLoadEmployeeFileDataWithError() {

        let viewModel = WorkViewModel()
        let invalidFilePath = URL(fileURLWithPath: "/invalid/file/path")

        viewModel.loadEmployeeFileData(filePath: invalidFilePath)

        XCTAssertNil(viewModel.workRecords, "Work records should be nil")
        XCTAssertEqual(viewModel.error, .failedToReadFile, "Error should be set to .failedToReadFile")
    }

    func testCalculateWorkPalsWorkDuration() {

        let viewModel = WorkViewModel()
        let records = [
            WorkRecord(empID: "143", projectID: "12", dateFrom: Date.createDate(year: 2013, month: 11, day: 1), dateTo: Date.createDate(year: 2014, month: 1, day: 5)),
            WorkRecord(empID: "218", projectID: "10", dateFrom: Date.createDate(year: 2012, month: 5, day: 16), dateTo: nil),
            WorkRecord(empID: "143", projectID: "10", dateFrom: Date.createDate(year: 2009, month: 1, day: 1), dateTo: Date.createDate(year: 2012, month: 6, day: 16)),
        ]

        let pairs = viewModel.calculateWorkPalsWorkDuration(records: records)

        XCTAssertNotNil(pairs, "Pairs should not be nil")
        XCTAssertEqual(pairs?.count, 1, "Expected 1 pair")
        XCTAssertEqual(pairs?[0].empID1, "143", "EmpID1 should match")
        XCTAssertEqual(pairs?[0].empID2, "218", "EmpID2 should match")
        XCTAssertEqual(pairs?[0].commonProjectID, "10", "CommonProjectID should match")
        XCTAssertEqual(pairs?[0].totalDurationInDays, 31, "TotalDurationInDays should match")
    }
}
