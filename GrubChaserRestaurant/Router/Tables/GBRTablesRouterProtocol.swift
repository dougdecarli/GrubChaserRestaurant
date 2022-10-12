//
//  GBRTablesRouterProtocol.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 10/10/22.
//

import Foundation

protocol GBRTablesRouterProtocol {
    func presentTableClients(table: GBRTableModel)
    func goToClientOrders(table: GBRTableModel,
                             client: GBRUserModel)
}
