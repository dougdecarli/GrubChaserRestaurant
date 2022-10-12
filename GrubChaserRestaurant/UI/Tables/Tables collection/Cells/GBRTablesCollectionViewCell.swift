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
    @IBOutlet weak var tableNameLabel: UILabel!
    
    static let identifier = "GBRTablesCollectionViewCell",
               nibName = "GBRTablesCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(table: GBRTableModel) {
        tableNameLabel.text = table.name
        guard let users = table.clients else {
            clientsNumberLabel.isHidden = true
            clientsImage.isHidden = true
            return
        }
        clientsNumberLabel.text = String(users.count)
    }
}
