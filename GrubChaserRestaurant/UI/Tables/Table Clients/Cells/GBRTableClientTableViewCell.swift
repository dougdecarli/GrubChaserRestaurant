//
//  GBRTableClientTableViewCell.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 11/10/22.
//

import UIKit

class GBRTableClientTableViewCell: UITableViewCell {
    @IBOutlet weak var clientNameLabel: UILabel!
    
    static let identifier = "GBRTableClientTableViewCell",
               nibName = "GBRTableClientTableViewCell"
    
    func bind(client: GBRUserModel) {
        clientNameLabel.text = client.name
    }
}
