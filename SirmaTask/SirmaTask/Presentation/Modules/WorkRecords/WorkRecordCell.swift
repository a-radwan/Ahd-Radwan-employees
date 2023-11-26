//
//  WorkRecordCell.swift
//  SirmaTask
//
//  Created by Ahd on 11/25/23.
//

import UIKit

class WorkRecordCell: UITableViewCell {

    @IBOutlet weak var secondEmployeeIDLabel: UILabel!
    @IBOutlet weak var firstEmployeeIDLabel: UILabel!
    @IBOutlet weak var projectIDLabel: UILabel!
    @IBOutlet weak var numberOfDaysWorkedLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.selectionStyle = .none
    }
    
    func configureCell(pair: EmployeePair, highlighted: Bool) {
        
        firstEmployeeIDLabel.text = pair.empID1
        secondEmployeeIDLabel.text = pair.empID2
        projectIDLabel.text = pair.commonProjectID
        numberOfDaysWorkedLabel.text = "\(pair.totalDurationInDays)"
        
        contentView.backgroundColor = highlighted ? UIColor(named: "SRRose") : .white 

    }

}
