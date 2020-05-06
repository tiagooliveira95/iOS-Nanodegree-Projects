//
//  ShoppingItem+CoreDataProperties.swift
//  
//
//  Created by Tiago Oliveira on 06/05/2020.
//
//

import Foundation
import CoreData


extension ShoppingItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingItem> {
        return NSFetchRequest<ShoppingItem>(entityName: "ShoppingItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: Int16

}
