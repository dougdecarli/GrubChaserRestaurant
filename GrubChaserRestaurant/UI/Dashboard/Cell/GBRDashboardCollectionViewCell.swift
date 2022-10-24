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
        titleLabel.text = ""
        valueLabel.text = ""
        containerView.backgroundColor = nil
    }

    func bind(dashboardModel: GBRDashboardModel) {
        titleLabel.text = dashboardModel.title
        valueLabel.text = dashboardModel.value
        setCellDesign(type: dashboardModel.type)
    }
    
    private func setCellDesign(type: GBRDashboardModel.GBRDashboardType) {
        switch type {
        case .realtime:
            containerView.backgroundColor = ColorPallete.defaultRed.withAlphaComponent(0.8)
        case .orders:
            containerView.backgroundColor = ColorPallete.defaultRed.withAlphaComponent(0.6)
        case .revenue:
            containerView.backgroundColor = ColorPallete.defaultRed.withAlphaComponent(0.4)
        }
    }
}
