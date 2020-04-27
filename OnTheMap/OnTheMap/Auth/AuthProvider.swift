//
//  AuthProvider.swift
//  OnTheMap
//
//  Created by Tiago Oliveira on 26/04/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import Foundation

struct Session: Codable {
    var id: String!
    var exporation: Date!
}

struct Account: Codable {
    var registered: Bool!
    var key: String!
}

struct LoginData: Codable {
    var account: Account!
    var session: Session!
}


class AuthProvider {
    
    static var loginData: LoginData!
    
    static func login(email: String, password: String,completionHandler: @escaping (Bool, Error?) -> ()){
        var request = URLRequest(url: URL(string: ServerConstants.BASE_URL + ServerConstants.PATH_SESSION)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
            completionHandler(false, error)
            return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range)
          /* subset response data! */
          
          let loginData: LoginData = try! JSONDecoder().decode(LoginData.self, from: newData!)
          self.loginData = loginData
          guard (loginData.session?.id) != nil else {
               completionHandler(false, nil)
               return
          }
            
          print(String(data: newData!, encoding: .utf8)!)
          completionHandler(true, nil)
        }
        task.resume()
    }
    
    static func logout(completionHandler: @escaping (Bool, Error?) -> ()){
        var request = URLRequest(url: URL(string: ServerConstants.BASE_URL + ServerConstants.PATH_SESSION)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
            completionHandler(false, error)
            return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
          self.loginData = nil
          completionHandler(true, nil)
        }
        task.resume()
    }
}

// response example
//{"account":{
//    "registered":true,
//    "key":"0000"
//    },
//    "session": {
//        "id":"0000",
//        "expiration":"2020-04-27T22:28:37.280064Z"
//    }
//}
