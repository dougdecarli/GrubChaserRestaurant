//
//  GBRTablesRouter.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 10/10/22.
//

import UIKit

class GBRTablesRouter: GBRTablesRouterProtocol {
    private let navigationController: UINavigationController,
                ordersStoryboard = UIStoryboard(name: "Tables",
                                                bundle: nil)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func presentTableVc(order: GBRTableModel) {
        
    }
}
