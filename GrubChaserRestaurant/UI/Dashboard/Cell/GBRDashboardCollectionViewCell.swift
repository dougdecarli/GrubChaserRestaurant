//
//  GBRDashboardCollectionViewCell.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 21/10/22.
//

import UIKit
import Differentiator

class GBRDashboardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let identifier = "GBRDashboardCollectionViewCell",
               nibName = "GBRDashboardCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(dashboardModel: GBRDashboardModel) {
        titleLabel.text = dashboardModel.title
        valueLabel.text = dashboardModel.value
    }
}
