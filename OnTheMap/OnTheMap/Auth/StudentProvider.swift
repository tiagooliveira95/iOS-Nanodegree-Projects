//
//  StudentProvider.swift
//  OnTheMap
//
//  Created by Tiago Oliveira on 27/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import Foundation

class StudentProvider {
    
    static var students: [Student]!

    
    static func getStudents(order: Bool? = false, completionHandler: @escaping (_ students: [Student],_ error: Error?) -> ()) {
        var urlString = ServerConstants.BASE_URL + ServerConstants.PATH_STUDENT
        if order! {
            urlString += "&order=-updatedAt"
        }
        let request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandler([Student](), error)
                return
            }
            do {
                let data = try JSONDecoder().decode(StudentData.self, from: data!)
                students = data.results
                completionHandler(data.results, nil)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
