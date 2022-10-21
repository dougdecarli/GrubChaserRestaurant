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
        confirmButton.isHidden = true
        productsQuantityLabel.text = ""
        userNameLabel.text = order.userName
        tableNameLabel.text = order.tableName
        timeLabel.text = Date.getDateFormatter(timestamp: order.timestamp)
        productsQuantityLabel.text = "\(getNumberOfProducts(order.products)) \(getNumberOfProducts(order.products) > 1 ? "produtos" : "produto")"
        setupButtonLayout(orderStatus: order.status)
    }
    
    private func setupButtonLayout(orderStatus: GBROrderStatus) {
        switch orderStatus {
        case .waitingConfirmation:
            confirmButton.isHidden = false
            confirmButton.setTitle("Confirmar", for: .normal)
        case .confirmed:
            confirmButton.isHidden = false
            confirmButton.setTitle("Finalizar", for: .normal)
        case .finished:
            confirmButton.isHidden = true
        case .closed:
            break
        }
    }
    
    private func getNumberOfProducts(_ products: [GBRProductBag]) -> Int {
        var quantity = 0
        products.forEach { product in
            quantity += product.quantity
        }
        return quantity
    }
}
