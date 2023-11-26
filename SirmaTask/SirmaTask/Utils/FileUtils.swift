//
//  FileUtils.swift
//  SirmaTask
//
//  Created by Ahd on 11/25/23.
//

import Foundation

class FileUtils {
    static func readFile(filePath: URL) -> String? {
        do {
            let contents = try String(contentsOf: filePath)
            return contents
        } catch {
            print("Error reading CSV file: \(error)")
            return nil
        }
    }
    
   static func rowsFrom(csvString: String) -> [[String?]] {
        
        var rows: [[String?]] = []
        
        let lines = csvString.components(separatedBy: "\r\n")
        
        for line in lines {
            let fields = line.components(separatedBy: ",")
            rows.append(fields)
        }
        
        return rows
    }
}
