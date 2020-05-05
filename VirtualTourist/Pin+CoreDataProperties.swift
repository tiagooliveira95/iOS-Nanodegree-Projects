//
//  Pin+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Tiago Oliveira on 04/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var hasPhotos: Bool
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var lastPageSaved: Int16
    @NSManaged public var photos: NSSet?
    @NSManaged public var maxPages: Int16

}

// MARK: Generated accessors for photos
extension Pin {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: PhotoCD)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: PhotoCD)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
