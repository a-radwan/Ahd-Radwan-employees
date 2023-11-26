//
//  WorkViewModel.swift
//  SirmaTask
//
//  Created by Ahd on 11/24/23.
//

import Foundation
import Combine

enum WorkRecordError: Error {
    case failedToReadFile
    case noDataToDisplay
    
}

class WorkViewModel {
    
    var error: WorkRecordError?
    var workRecords: [WorkRecord]?
    
    var filePath: URL? {
        didSet {
            if let filePath = filePath {
                self.loadEmployeeFileData(filePath: filePath)
            }
        }
    }
    
    @Published var longestPairWorkProjects: [EmployeePair]?
    
    
    var emptyDataMessage: String? {
        
        if longestPairWorkProjects?.count ?? 0 == 0 {
            
            if error != nil {
                switch error {
                case .failedToReadFile:
                    return "Failed to read the CSV file,\n please try again"
                    
                default:
                    return "Somthing went wrong, please try again"
                }
            } else {
                return "No data to display"
            }
        } else {
            return nil
        }
    }
    
    func loadEmployeeFileData(filePath: URL) {
       
        if let csvString = FileUtils.readFile(filePath: filePath) {
            let rows = FileUtils.rowsFrom(csvString: csvString)
            
            self.workRecords = WorkRecordMapper.mapToModel(csvRows: rows);
            self.longestPairWorkProjects =  self.calculateWorkPalsWorkDuration(records: self.workRecords!)
        } else {
            self.longestPairWorkProjects = nil
            self.error = .failedToReadFile
        }
        
    }
    
    func calculateWorkPalsWorkDuration(records: [WorkRecord]) -> [EmployeePair]? {
        var employeePairsMap: [String: [EmployeePair]] = [:]
        
        for i in 0..<records.count {
            let record1 = records[i]
            
            for j in (i+1)..<records.count {
                let record2 = records[j]
                
                if record1.projectID != record2.projectID {
                    //ignore records with different ids
                    continue
                }
                
                // Check if there is an overlap in project durations
                let commonFrom = max(record1.dateFrom, record2.dateFrom)
                let commonTo = min(record1.dateTo ?? Date(), record2.dateTo ?? Date())
                if commonFrom < commonTo {
                    
                    // Calculate the common duration in days
                    let commonDurationInDays = Calendar.current.dateComponents([.day], from: commonFrom, to: commonTo).day ?? 0
                    
                    
                    //To keep pairLKeys identical (first_second)
                    let employeeIds = [record1.empID, record2.empID].sorted(by: <)
                    let firstEmp = employeeIds.first!, secondEmp = employeeIds.last!
                    let pairKey = "\(firstEmp)_\(secondEmp)"
                    
                    if employeePairsMap[pairKey] == nil {
                        employeePairsMap[pairKey] = [EmployeePair(empID1: firstEmp, empID2: secondEmp, commonProjectID: record1.projectID, totalDurationInDays: commonDurationInDays)]
                    } else {
                        if let index = employeePairsMap[pairKey]?.firstIndex(where: { $0.commonProjectID == record1.projectID }) {
                            employeePairsMap[pairKey]?[index].totalDurationInDays += commonDurationInDays
                        } else {
                            let newPair = EmployeePair(empID1: firstEmp, empID2: secondEmp, commonProjectID: record1.projectID, totalDurationInDays: commonDurationInDays)
                            employeePairsMap[pairKey]?.append(newPair)
                        }
                    }
                }
            }
        }
        
        // Find the pair with the largest total duration
        let maxPairs = employeePairsMap.max {
            let totalDuration1 = $0.value.compactMap { $0.totalDurationInDays }.reduce(0, +)
            let totalDuration2 = $1.value.compactMap { $0.totalDurationInDays }.reduce(0, +)
            return totalDuration1 < totalDuration2
        }
        
        return maxPairs?.value
    }
    
    
}

