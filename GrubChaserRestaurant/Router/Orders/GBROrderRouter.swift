//
//  GBROrderRouter.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 06/10/22.
//

import UIKit

class GBROrderRouter: GBROrdersRouterProtocol {
    private let navigationController: UINavigationController,
                ordersStoryboard = UIStoryboard(name: "Orders",
                                               bundle: nil)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
}
