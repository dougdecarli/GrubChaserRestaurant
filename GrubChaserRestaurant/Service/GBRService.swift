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
    
    func getNewOrders() -> Observable<[GBROrderModel]> {
        dbFirestore
            .collection("restaurants")
            .document(UserDefaults.standard.getLoggedUser()?.id ?? "")
            .collection("orders")
            .order(by: "timestamp", descending: true)
            .rx
            .getDocuments()
            .decode(GBROrderModel.self)
    }
    
    func listenToNewOrders() -> Observable<Void> {
        dbFirestore
            .collection("restaurants")
            .document(UserDefaults.standard.getLoggedUser()?.id ?? "")
            .collection("orders")
            .rx
            .listen()
            .map { _ in }
    }
}
