//
//  WorkRecordMapper.swift
//  SirmaTask
//
//  Created by Ahd on 11/26/23.
//

import Foundation

struct WorkRecordMapper {
    static let dateFormats = ["yyyy-MM-dd",
                              "MM/dd/yyyy",
                              "dd-MM-yyyy",
                              "yyyy-MM-dd HH:mm:ss",
                              "MMM d, yyyy"]
    
    static func mapToModel(csvRows: [[String?]]) -> [WorkRecord] {
        var models: [WorkRecord] = []
        
        for row in csvRows {
            if row.count >= 3,
               let empID = row[0],
               let projectID = row[1],
               let dateStringFrom = row[2],
               let dateFrom = parseDate(dateString: dateStringFrom, dateFormats: dateFormats) {
                
                let dateTo: Date?
                if row.count > 3, let dateStringTo = row[3] {
                    dateTo = parseDate(dateString: dateStringTo, dateFormats: dateFormats)
                } else {
                    dateTo = nil
                }
                let model = WorkRecord(empID: empID, projectID: projectID, dateFrom: dateFrom, dateTo: dateTo)
                models.append(model)
            }
        }
        
        return models
    }
    
    static func parseDate(dateString: String, dateFormats: [String]) -> Date? {
        let dateFormatter = DateFormatter()
        
        for format in dateFormats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }
        
        return nil
    }
    
}
