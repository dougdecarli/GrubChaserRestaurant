//
//  GBROrderModel.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 06/10/22.
//

import Foundation
import Differentiator

struct GBROrderModel: Codable, IdentifiableType, Equatable {
    static func == (lhs: GBROrderModel, rhs: GBROrderModel) -> Bool {
        if lhs.orderId == rhs.orderId {
            return true
        }
        return false
    }
    
    var identity: UUID {
        return UUID()
    }
    typealias Identity = UUID
    
    let orderId: String
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

extension GBROrderStatus {
    init(_ segmentedSelected: Int) {
        switch segmentedSelected {
        case 0:
            self = .waitingConfirmation
        case 1:
            self = .confirmed
        case 2:
            self = .finished
        default:
            self = .waitingConfirmation
        }
    }
}
