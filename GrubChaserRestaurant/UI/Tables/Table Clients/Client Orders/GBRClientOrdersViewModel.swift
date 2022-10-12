//
//  GBRClientOrdersViewModel.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 11/10/22.
//

import UIKit
import RxSwift
import RxCocoa

class GBRClientOrdersViewModel: GrubChaserBaseViewModel<GBRTablesRouterProtocol> {
    var clientOrdersCells: Observable<[GBRProductBag]> {
        orderProductsBag.asObservable()
    }
    
    var showAlert = PublishSubject<ShowAlertModel>(),
        isLoaderShowing = PublishSubject<Bool>()
    
    let client: GBRUserModel,
        table: GBRTableModel,
        orderProductsBag = PublishRelay<[GBRProductBag]>(),
        onViewWillAppear = PublishRelay<Void>()
    
    init(table: GBRTableModel,
         client: GBRUserModel,
         router: GBRTablesRouterProtocol,
         viewControllerRef: UIViewController) {
        self.client = client
        self.table = table
        super.init(router: router,
                   viewControllerRef: viewControllerRef)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnViewWillAppear()
    }
    
    //MARK: - Inputs
    private func setupOnViewWillAppear() {
        onViewWillAppear
            .do(onNext: startLoader)
            .subscribe(onNext: getClientOrders)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Service
    private func getClientOrders() {
        func handleSuccess(orders: [GBROrderModel]) {
            stopLoader()
            var productsBag: [GBRProductBag] = []
            orders.forEach { order in
                order.products.forEach { products in
                    productsBag.append(products)
                }
            }
            orderProductsBag.accept(productsBag)
        }
        
        func handleError(_: Error) {
            stopLoader()
            showAlert.onNext(getAlertConfirmOrderErrorModel())
        }
        
        service.getClientOrders(from: table.id, and: client.uid)
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Helper methods
    private func getAlertConfirmOrderErrorModel() -> ShowAlertModel {
        .init(title: "Não foi possível apresentar os pedidos",
              message: "Tente novamente",
              viewControllerRef: viewControllerRef)
    }
}

extension GBRClientOrdersViewModel: GrubChaserLoadableViewModel {}
extension GBRClientOrdersViewModel: GrubChaserAlertableViewModel {}
