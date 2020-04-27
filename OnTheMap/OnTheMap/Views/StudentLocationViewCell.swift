//
//  StudentLocationViewCell.swift
//  OnTheMap
//
//  Created by Tiago Oliveira on 27/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import UIKit

class StudentLocationViewCell: UITableViewCell{
    
    @IBOutlet weak var locationCellLabel: UILabel!
    
    func setStudent(student: Student){
        locationCellLabel.text = "\(student.firstName) \(student.lastName)"
    }
}
