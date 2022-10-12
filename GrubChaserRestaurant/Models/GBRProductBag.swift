//
//  GBRProductBag.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 06/10/22.
//

import Foundation
import Differentiator

struct GBRProductBag: Codable, Equatable, IdentifiableType {
    var identity: UUID {
        return UUID()
    }
    typealias Identity = UUID
    
    let product: GrubChaserProduct
    let quantity: Int
}
