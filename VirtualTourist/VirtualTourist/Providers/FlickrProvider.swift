//
//  FlickrProvider.swift
//  VirtualTourist
//
//  Created by Tiago Oliveira on 02/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//

import Foundation
import MapKit

struct FlickrResponse: Codable{
    var photos: GeoPhotosData
    var stat: String
}

struct Photo: Codable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var isPublic: Int?
    var isFriend: Int?
    var isFamily: Int?
    var imageData: Data?
}

struct GeoPhotosData:Codable {
    var photo:[Photo]
    var pages:Int
    var perpage: Int
    var total:String
}

class FlickrProvider{
    
    func getGeoUrl(coordinates: CLLocationCoordinate2D, page: String? = "1") -> URL{
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
                             URLQueryItem(name: "page", value: page)]
        let builtUrl = geoUrl.url!        
        return builtUrl;
    }
    
    func getGeolocationData(coordinates: CLLocationCoordinate2D, page: String? = nil, completionHandler: @escaping (_ bool: Bool, GeoPhotosData?, _ error: Error?)->()) {
        
        let url: URL = getGeoUrl(coordinates: coordinates, page: page)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(false,nil,nil)
                return
            }
            
            let dataRange = data!.subdata(in: 14..<data!.count-1)
            let decoder = JSONDecoder.init()
            
            do {
                let flickrResponse = try decoder.decode(FlickrResponse.self, from: dataRange)
                if flickrResponse.stat == "ok"{
                    completionHandler(true,flickrResponse.photos, nil)
                }else{
                    completionHandler(false, nil, nil)
                }
            } catch {
                completionHandler(false, nil, error)
                print(error)
            }
        }
        task.resume()
    }
    
    func getPhotoDownloadURL(photo: Photo)-> URL {
        var photoUrl = URLComponents()
        photoUrl.scheme = "https"
        photoUrl.host = "farm\(photo.farm).staticflickr.com"
        photoUrl.path = "/\(photo.server)/\(photo.id)_\(photo.secret)_q.jpg"
        let url: URL? = photoUrl.url
        print("Phoyo URL: \(url?.absoluteString ?? "nil") ") // Debug
        return url!
    }
}
