//
//  ProductDetailViewModel+Event.swift
//  MoviusTableviewDemo
//
//  Created by Uma on 05/09/22.
//

import Foundation
import CoreData

extension ProductDetailViewModel {

    enum Event {
        case viewLoad(contex: NSManagedObjectContext)
        case getProductDetails
        case addNewProductAction
        case saveProduct(name: String, description: String)
    }
}
