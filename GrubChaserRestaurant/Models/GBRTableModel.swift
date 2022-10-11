//
//  GBRTableModel.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 10/10/22.
//

import Foundation
import Differentiator

struct GBRTableModel: Codable, Equatable, IdentifiableType {
    static func == (lhs: GBRTableModel, rhs: GBRTableModel) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
    
    var identity: UUID {
        return UUID()
    }
    typealias Identity = UUID
    
    let id: String
    let name: String
    let code: String
    let clients: [GBRUserModel]?
}
