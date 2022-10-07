//
//  GBROrdersTableViewCell.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 06/10/22.
//

import UIKit

class GBROrdersTableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var productsQuantityLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    static let identifier = "GBROrdersTableViewCell",
               nibName = "GBROrdersTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(order: GBROrderModel) {
        userNameLabel.text = order.userName
        tableNameLabel.text = order.tableName
        timeLabel.text = Date.getDateFormatter(timestamp: order.timestamp)
        productsQuantityLabel.text = "\(getNumberOfProducts(order.products)) produtos"
    }
    
    private func getNumberOfProducts(_ products: [GBRProductBag]) -> Int {
        var quantity = 0
        products.forEach { product in
            quantity += product.quantity
        }
        return quantity
    }
}
