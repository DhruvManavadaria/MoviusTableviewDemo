//
//  ProductDetailViewModel.swift
//  MoviusTableviewDemo
//
//  Created by Uma on 04/09/22.
//

import CoreData

protocol ProductDetailDelegate: AnyObject {
    func onReceivedState(_ state: ProductDetailViewModel.State)
}

final class ProductDetailViewModel: NSObject {

    weak var delegate: ProductDetailDelegate?
    var context: NSManagedObjectContext?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Product> = {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.fetchLimit = 10
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context!, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()


    private func getProductDetails() {

        do {
            try fetchedResultsController.performFetch()
            delegate?.onReceivedState(
                .reloadData(fetchedResultsController: fetchedResultsController)
            )
        } catch {
            fatalError("Core Data fetch error")
        }
    }

    private func addNewProduct() {

        guard let section = fetchedResultsController.sections?.first?.numberOfObjects,
              section < 10 else {
            return
        }
        delegate?.onReceivedState(.addNewProductAlert)
    }

    private func saveProductDetail(
        name: String,
        description: String
    ) {
        let newProduct = Product(context: context!)
        newProduct.name = name
        newProduct.detail = description
        
        do {
            try context?.save()
        } catch {
            fatalError("Core Data Save error")
        }
    }
}

extension ProductDetailViewModel {

    func onReceiveEvent(_ event: Event) {

        switch event {
        case .viewLoad(let context):
            self.context = context

        case .getProductDetails:
            getProductDetails()

        case .addNewProductAction:
            addNewProduct()

        case let .saveProduct(name, description):
            saveProductDetail(name: name, description: description)
        }
    }
}

extension ProductDetailViewModel: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.onReceivedState(.beginUpdate)
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            delegate?.onReceivedState(
                .inserRow(indexPath: newIndexPath)
            )

        default: return
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.onReceivedState(.endUpdate)
    }
}
