//
//  GBROrderProductsTableViewCell.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 09/10/22.
//

import UIKit

class GBROrderProductsTableViewCell: UITableViewCell {
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    static let identifier = "GBROrderProductsTableViewCell",
               nibName = "GBROrderProductsTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(order: GBRProductBag) {
        productImageView.loadImage(imageURL: order.product.image,
                                   genericImage: R.image.genericFood()!)
        productQuantity.text = String(order.quantity)
        productNameLabel.text = order.product.name
        productPriceLabel.text = "\(String(order.product.price * Double(order.quantity)).currencyFormatting())"
    }
}
