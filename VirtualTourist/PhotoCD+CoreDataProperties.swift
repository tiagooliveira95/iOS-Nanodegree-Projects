//
//  PhotoCD+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Tiago Oliveira on 04/05/2020.
//  Copyright © 2020 Tiago Oliveira. All rights reserved.
//
//

import Foundation
import CoreData


extension PhotoCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoCD> {
        return NSFetchRequest<PhotoCD>(entityName: "PhotoCD")
    }

    @NSManaged public var farm: Int16
    @NSManaged public var id: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var owner: String?
    @NSManaged public var secret: String?
    @NSManaged public var server: String?
    @NSManaged public var title: String?
    @NSManaged public var pin: Pin?

}
