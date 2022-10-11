//
//  GBRUserModel.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 10/10/22.
//

import Foundation
import Differentiator

struct GBRUserModel: Codable, Equatable, IdentifiableType {
    static func == (lhs: GBRUserModel, rhs: GBRUserModel) -> Bool {
        if lhs.uid == rhs.uid {
            return true
        }
        return false
    }
    
    var identity: UUID {
        return UUID()
    }
    typealias Identity = UUID
    
    let uid: String
    let name: String
}
