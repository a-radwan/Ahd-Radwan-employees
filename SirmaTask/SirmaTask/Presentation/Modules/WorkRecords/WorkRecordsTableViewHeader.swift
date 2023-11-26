//
//  WorkRecordsTableViewHeader.swift
//  SirmaTask
//
//  Created by Ahd on 11/25/23.
//

import UIKit

class WorkRecordsTableViewHeader: UITableViewHeaderFooterView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray4.cgColor
    }

}
