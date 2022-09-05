//
//  ProductDetailCell.swift
//  MoviusTableviewDemo
//
//  Created by Uma on 04/09/22.
//

import UIKit

final class ProductDetailCell: UITableViewCell {

    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func showProductDetail(product: Product?) {
        nameLabel.text = product?.name ?? ""
        detailLabel.text = product?.detail ?? ""
    }
}
