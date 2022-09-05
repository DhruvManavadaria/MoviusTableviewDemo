//
//  ProductDetailViewModel+State.swift
//  MoviusTableviewDemo
//
//  Created by Uma on 05/09/22.
//

import CoreData

extension ProductDetailViewModel {

    enum State {
        case reloadData(fetchedResultsController: NSFetchedResultsController<Product>)
        case inserRow(indexPath: IndexPath)
        case beginUpdate
        case endUpdate
        case addNewProductAlert
    }
}
