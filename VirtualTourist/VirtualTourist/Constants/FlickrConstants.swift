//
//  FlickrConstants.swift
//  VirtualTourist
//
//  Created by Tiago Oliveira on 02/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//


import Foundation

class FlickrConstants{
    
    static func getBaseURL() -> URLComponents {
          var baseUrl = URLComponents()
          baseUrl.scheme = "https"
          baseUrl.host = "api.flickr.com"
        return baseUrl;
    }
    
    static let GEO_PATH = "/services/rest"
}
