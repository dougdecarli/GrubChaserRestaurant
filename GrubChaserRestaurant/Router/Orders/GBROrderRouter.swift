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
    
    func presentOrderVc(order: GBROrderModel) {
        let vc = ordersStoryboard.instantiateViewController(withIdentifier: "orderDetailVC") as! GBROrderDetailViewController
        vc.viewModel = GBROrderDetailViewModel(router: self,
                                               viewControllerRef: vc,
                                               order: order)
        navigationController.present(vc, animated: true)
    }
}
