//
//  GBRDashboardModel.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 21/10/22.
//

import Differentiator

struct GBRDashboardModel: Equatable, IdentifiableType {
    static func == (lhs: GBRDashboardModel, rhs: GBRDashboardModel) -> Bool {
        if lhs.identity == rhs.identity {
            return true
        }
        return false
    }
    
    var identity: UUID {
        return UUID()
    }
    typealias Identity = UUID
    
    let title: String
    let value: String
    let type: GBRDashboardType
    
    enum GBRDashboardType {
        case realtime
        case orders
        case revenue
    }
}


