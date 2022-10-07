//
//  GBROrderModel.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 06/10/22.
//

import Foundation

struct GBROrderModel: Codable {
    let userId: String
    let userName: String
    let tableId: String
    let tableName: String
    let products: [GBRProductBag]
    let status: GBROrderStatus
    let timestamp: Double
}

enum GBROrderStatus: String, Codable {
    case waitingConfirmation = "AGUARDANDO CONFIRMAÇÃO"
    case confirmed = "CONFIRMADO"
    case finished = "FINALIZADO"
}
