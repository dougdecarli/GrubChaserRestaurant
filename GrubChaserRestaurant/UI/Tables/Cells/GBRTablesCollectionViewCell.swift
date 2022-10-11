//
//  GBRTablesCollectionViewCell.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 10/10/22.
//

import UIKit

class GBRTablesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tableNameLabel: UILabel!
    @IBOutlet weak var clientsStackView: UIStackView!
    
    static let identifier = "GBRTablesCollectionViewCell",
               nibName = "GBRTablesCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(table: GBRTableModel) {
        clientsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        tableNameLabel.text = table.name
        guard let users = table.clients else { return }
        users.forEach({ user in
            let userIcon = UIImageView(image: R.image.check()!)
            userIcon.contentMode = .scaleAspectFit
            userIcon.tintColor = .white
            clientsStackView.addArranged(userIcon)
        })
    }
}
