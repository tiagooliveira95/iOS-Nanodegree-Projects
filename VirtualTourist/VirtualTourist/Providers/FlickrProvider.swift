//
//  FlickrProvider.swift
//  VirtualTourist
//
//  Created by Tiago Oliveira on 02/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import Foundation
import MapKit

class FlickrProvider{
    
    func getGeoUrl(coordinates: CLLocationCoordinate2D) -> URL{
        var geoUrl: URLComponents = FlickrConstants.getBaseURL()
        geoUrl.path = FlickrConstants.GEO_PATH
        
        geoUrl.queryItems = [URLQueryItem(name: "method", value: "flickr.photos.search"),
                             URLQueryItem(name: "api_key", value: FlickrAuth.API_KEY),
                             URLQueryItem(name: "lat", value: "\(coordinates.latitude)"),
                             URLQueryItem(name: "lon", value: "\(coordinates.longitude)"),
                             URLQueryItem(name: "format", value: "json"),
                             URLQueryItem(name: "per_page", value: "30"),
                             URLQueryItem(name: "safe_search", value: "1"),
                             URLQueryItem(name: "content_type", value: "1"),
                             URLQueryItem(name: "page", value: "1")]
        let builtUrl = geoUrl.url!        
        return builtUrl;
    }
}
