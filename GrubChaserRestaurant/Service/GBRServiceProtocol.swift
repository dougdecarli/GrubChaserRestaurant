//
//  GBRServiceProtocol.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 04/10/22.
//

import RxSwift

protocol GBRServiceProtocol {
    func getAllRestaurantOrders() -> Observable<[GBROrderModel]>
    func getRestaurant(with restaurantUid: String) -> Observable<GBRRestaurantModel>
    func getRestaurantOrders(from status: GBROrderStatus) -> Observable<[GBROrderModel]>
    func putOrderStatus(_ orderId: String,
                        to status: GBROrderStatus) -> Observable<Void>
    func listenToOrders() -> Observable<Void>
    func getOccupiedTables() -> Observable<[GBRTableModel]>
    func getAllTables() -> Observable<[GBRTableModel]>
    func listenToTables() -> Observable<Void>
    func checkoutUser(from tableId: String,
                      and client: GBRUserModel) -> Observable<Void>
    func getClientOrders(from tableId: String,
                         and userId: String) -> Observable<[GBROrderModel]>
    func getTodaysRevenue() -> Observable<(Double, Double, Double)>
    func getNumberOfActiveClients() -> Observable<Int>
    func getNumberOfOrdersByTodayWeeklyAndMonthly() -> Observable<(Int, Int, Int)>
}
