//
//  GBRTablesCollectionViewCell.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 10/10/22.
//

import UIKit

class GBRTablesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var clientsNumberLabel: UILabel!
    @IBOutlet weak var clientsImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableNameLabel: UILabel!
    
    static let identifier = "GBRTablesCollectionViewCell",
               nibName = "GBRTablesCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clientsNumberLabel.isHidden = true
        clientsImage.isHidden = true
        containerView.backgroundColor = nil
    }

    func bind(table: GBRTableModel) {
        tableNameLabel.text = table.name
        if let users = table.clients,
           users.count > 0 {
            containerView.backgroundColor = ColorPallete.defaultRed
            clientsNumberLabel.isHidden = false
            clientsImage.isHidden = false
            clientsNumberLabel.text = String(users.count)
        } else {
            clientsNumberLabel.isHidden = true
            clientsImage.isHidden = true
            containerView.backgroundColor = .systemGray2
        }
    }
}
