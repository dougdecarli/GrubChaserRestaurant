//
//  GBRTablesRouter.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 10/10/22.
//

import UIKit

class GBRTablesRouter: GBRTablesRouterProtocol {
    private let navigationController: UINavigationController,
                tablesStoryboard = UIStoryboard(name: "Tables",
                                                bundle: nil)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func presentTableClients(table: GBRTableModel) {
        let vc = tablesStoryboard.instantiateViewController(withIdentifier: "clientsTableVC") as! GBRTableClientsViewController
        vc.viewModel = GBRTableClientsViewModel(table: table,
                                                router: self,
                                                viewControllerRef: vc)
        navigationController.present(vc, animated: true)
    }
    
    func goToClientOrders(table: GBRTableModel,
                             client: GBRUserModel) {
        let vc = tablesStoryboard.instantiateViewController(withIdentifier: "clientsOrderVC") as! GBRClientOrdersViewController
        vc.viewModel = GBRClientOrdersViewModel(table: table,
                                                client: client,
                                                router: self,
                                                viewControllerRef: vc)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pop() {
        navigationController.popToRootViewController(animated: true)
    }
}
