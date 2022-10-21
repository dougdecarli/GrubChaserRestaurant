//
//  GBRService.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 04/10/22.
//

import FirebaseFirestore
import RxSwift
import RxCocoa
import RxFirebase
import FirebaseAuth

class GBRService: GBRServiceProtocol {
    private let dbFirestore: Firestore,
                disposeBag = DisposeBag()
    
    static var instance: GBRService = {
        return GBRService()
    }()
    
    private init(dbFirestore: Firestore = Firestore.firestore()) {
        self.dbFirestore = dbFirestore
    }
    
    func getRestaurant(with restaurantUid: String) -> Observable<GBRRestaurantModel> {
        dbFirestore
            .collection("restaurants")
            .whereField("uid", isEqualTo: restaurantUid)
            .rx
            .getFirstDocument()
            .decodeDocument(GBRRestaurantModel.self)
    }
    
    //MARK: - Orders
    func getRestaurantOrders(from status: GBROrderStatus) -> Observable<[GBROrderModel]> {
        dbFirestore
            .collection("restaurants")
            .document(UserDefaults.standard.getLoggedUser()?.id ?? "")
            .collection("orders")
            .order(by: "timestamp", descending: true)
            .whereField("status", isEqualTo: status.rawValue)
            .rx
            .getDocuments()
            .decode(GBROrderModel.self)
    }
    
    func listenToOrders() -> Observable<Void> {
        dbFirestore
            .collection("restaurants")
            .document(UserDefaults.standard.getLoggedUser()?.id ?? "")
            .collection("orders")
            .rx
            .listen()
            .map { _ in }
    }
    
    func putOrderStatus(_ orderId: String,
                        to status: GBROrderStatus) -> Observable<Void> {
        dbFirestore
            .collection("restaurants")
            .document(UserDefaults.standard.getLoggedUser()?.id ?? "")
            .collection("orders")
            .document(orderId)
            .rx
            .updateData(["status": status.rawValue])
    }
    
    func putOrderClosedStatus(from tableId: String,
                              and userId: String) -> Observable<Void> {
        dbFirestore
            .collection("restaurants")
            .document(UserDefaults.standard.getLoggedUser()?.id ?? "")
            .collection("orders")
            .whereField("tableId", isEqualTo: tableId)
            .whereField("userId", isEqualTo: userId)
            .rx
            .getDocuments()
            .flatMap { docs -> Observable<Void> in
                if docs.count > 0 {
                    docs.documents.forEach { documentChange in
                        documentChange.reference.updateData(["status": "FECHADO"])
                    }
                    return Observable.just(())
                } else {
                    return Observable.error(DecodableErrorType.decodedEmptyError)
                }
            }
    }
    
    func getClientOrders(from tableId: String,
                         and userId: String) -> Observable<[GBROrderModel]> {
        dbFirestore
            .collection("restaurants")
            .document(UserDefaults.standard.getLoggedUser()?.id ?? "")
            .collection("orders")
            .whereField("tableId", isEqualTo: tableId)
            .whereField("userId", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .rx
            .getDocuments()
            .decode(GBROrderModel.self)
    }
    
    //MARK: - Tables
    func getOccupiedTables() -> Observable<[GBRTableModel]> {
        dbFirestore
            .collection("restaurants")
            .document(UserDefaults.standard.getLoggedUser()?.id ?? "")
            .collection("tables")
            .order(by: "name", descending: false)
            .order(by: "clients", descending: false)
            .rx
            .getDocuments()
            .decode(GBRTableModel.self)
    }
    
    func getAllTables() -> Observable<[GBRTableModel]> {
        dbFirestore
            .collection("restaurants")
            .document(UserDefaults.standard.getLoggedUser()?.id ?? "")
            .collection("tables")
            .order(by: "name", descending: false)
            .rx
            .getDocuments()
            .decode(GBRTableModel.self)
    }
    
    func listenToTables() -> Observable<Void> {
        dbFirestore
            .collection("restaurants")
            .document(UserDefaults.standard.getLoggedUser()?.id ?? "")
            .collection("tables")
            .rx
            .listen()
            .map { _ in }
    }
    
    func checkoutUser(from tableId: String,
                      and client: GBRUserModel) -> Observable<Void> {
        dbFirestore
            .collection("restaurants")
            .document(UserDefaults.standard.getLoggedUser()?.id ?? "")
            .collection("tables")
            .document(tableId)
            .rx
            .updateData(["clients": FieldValue.arrayRemove([client.toDictionary!])])
    }
}
