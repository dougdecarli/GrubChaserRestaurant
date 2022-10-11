//
//  GBRRestaurantModel.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 04/10/22.
//

import Foundation
import CodableFirebase
import FirebaseFirestore
import Differentiator

struct GBRRestaurantModel: Codable {
    let id: String
    let uid: String
    let name: String
    let logo: String
    let categoryName: String
    var location: GrubChaserRestaurantLocationModel
    let products: [GrubChaserProduct]
    var category: GrubChaserRestaurantCategory?
}

struct GrubChaserRestaurantLocationModel: Codable {
    let latitude: Double
    let longitude: Double
    let address: String
}

struct GrubChaserRestaurantCategory: Codable {
    let name: String
}

struct GrubChaserProduct: Codable, Hashable, IdentifiableType, Equatable {
    let id: String
    let name: String
    let price: Double
    let image: String
    let description: String
    
    var identity: UUID {
        return UUID()
    }
    typealias Identity = UUID
}

struct GrubChaserProductCategory: Codable {
    let name: String
    let image: String
}


