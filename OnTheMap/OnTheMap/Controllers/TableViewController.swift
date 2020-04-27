//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Tiago Oliveira on 27/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    var students: [Student] = [Student]()
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }

    func loadData() {
        //TODO show loaidng pins message
        StudentProvider.getStudents(order: true) { (students, error) in
            if error != nil {
                //TODO show error
                return
            }
            self.students = students
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.LocationCellIdentifier, for: indexPath) as! StudentLocationViewCell
        cell.setStudent(student: students[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: students[indexPath.row].mediaURL)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            //TODO show message
        }
    }
}
