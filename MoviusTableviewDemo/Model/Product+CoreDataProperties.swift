//
//  Product+CoreDataProperties.swift
//  MoviusTableviewDemo
//
//  Created by Uma on 04/09/22.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var detail: String?
    @NSManaged public var name: String?

}

extension Product : Identifiable {

}
