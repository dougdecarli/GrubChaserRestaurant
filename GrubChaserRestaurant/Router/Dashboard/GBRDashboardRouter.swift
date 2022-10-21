//
//  GBRDashboardRouter.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 21/10/22.
//

import UIKit

class GBRDashboardRouter: GBRDashboardRouterProtocol {
    private let navigationController: UINavigationController,
                tablesStoryboard = UIStoryboard(name: "Dashboard",
                                                bundle: nil)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
