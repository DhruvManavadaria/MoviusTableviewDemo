//
//  ViewController.swift
//  MoviusTableviewDemo
//
//  Created by Uma on 04/09/22.
//

import UIKit
import CoreData

final class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let viewModel = ProductDetailViewModel()
    private var fetchedResultsController: NSFetchedResultsController<Product>?

    let reuseIdetifier = "ProductDetailCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        loadContext()
        configureViews()
        configureTableView()
        getProductDetails()
    }

    private func configureViews() {

        self.title = "Product Detail"
        let add = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(adNewProductAction)
        )
        self.navigationItem.rightBarButtonItem = add
    }

    private func configureTableView() {

        tableView.register(
            UINib(nibName: "ProductDetailCell", bundle: nil),
            forCellReuseIdentifier: reuseIdetifier
        )
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func loadContext() {

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else {
            return
        }
        viewModel.onReceiveEvent(.viewLoad(contex: context))
    }

    private func getProductDetails() {
        viewModel.onReceiveEvent(.getProductDetails)
    }

    @objc private func adNewProductAction() {
        viewModel.onReceiveEvent(.addNewProductAction)
    }

    private func showAlertForAddNewProduct() {

        let alertController = UIAlertController(
            title: "New Product",
            message: "add new product",
            preferredStyle: .alert
        )

        alertController.addTextField(
            configurationHandler: {(_ textField: UITextField) -> Void in
            textField.placeholder = "Name"
        })

        alertController.addTextField(
            configurationHandler: {(_ textField: UITextField) -> Void in
            textField.placeholder = "Description"

        })

        let confirmAction = UIAlertAction(
            title: "Save",
            style: .default,
            handler: { [weak self] (_ action: UIAlertAction) -> Void in

                let name = alertController.textFields?[0].text ?? ""
                let description = alertController.textFields?[1].text ?? ""

                guard !name.isEmpty,
                      !description.isEmpty else {
                    return
                }

                self?.viewModel.onReceiveEvent(
                    .saveProduct(name: name, description: description)
                )
            })
        alertController.addAction(confirmAction)

        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: {(_ action: UIAlertAction) -> Void in
            print("Canelled")
        })
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: ProductDetailDelegate {

    func onReceivedState(_ state: ProductDetailViewModel.State) {

        switch state {
        case .reloadData(let fetchedResultsController):
            self.fetchedResultsController = fetchedResultsController
            tableView.reloadData()

        case .beginUpdate:
            tableView.beginUpdates()

        case .endUpdate:
            tableView.endUpdates()

        case .inserRow(let newIndexPath):
            tableView.insertRows(at: [newIndexPath], with: .fade)

        case .addNewProductAlert:
            showAlertForAddNewProduct()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {

        guard let sectionInfo = fetchedResultsController?.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdetifier, for: indexPath) as? ProductDetailCell else {
            fatalError()
        }

        let product = fetchedResultsController?.object(at: indexPath)
        cell.showProductDetail(product: product)

        return cell
    }
}

