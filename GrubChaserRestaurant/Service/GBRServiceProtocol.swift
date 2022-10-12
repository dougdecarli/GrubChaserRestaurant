//
//  GBRServiceProtocol.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 04/10/22.
//

import RxSwift

protocol GBRServiceProtocol {
    func getRestaurant(with restaurantUid: String) -> Observable<GBRRestaurantModel>
    func getNewOrders() -> Observable<[GBROrderModel]>
    func postOrderConfirmed(orderId: String) -> Observable<Void>
    func listenToNewOrders() -> Observable<Void>
    func getTables() -> Observable<[GBRTableModel]>
    func getClientOrders(from tableId: String,
                         and userId: String) -> Observable<[GBROrderModel]>
}
