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
    var clientOrdersCells: Observable<[ClientsOrderSectionModel]> {
        orderProductsBag.asObservable()
    }
    
    var showAlert = PublishSubject<ShowAlertModel>(),
        isLoaderShowing = PublishSubject<Bool>(),
        totalPrice = BehaviorRelay<Double>(value: 0)
    
    let client: GBRUserModel,
        table: GBRTableModel,
        orderProductsBag = BehaviorRelay<[ClientsOrderSectionModel]>(value: []),
        onViewWillAppear = PublishRelay<Void>(),
        onFinishOrdersButton = PublishRelay<Void>()
    
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
        setupOnFinishOrdersButton()
    }
    
    //MARK: - Inputs
    private func setupOnViewWillAppear() {
        onViewWillAppear
            .do(onNext: startLoader)
            .subscribe(onNext: getClientOrders)
            .disposed(by: disposeBag)
    }
    
    private func setupOnFinishOrdersButton() {
        onFinishOrdersButton
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    //MARK: - Service
    private func getClientOrders() {
        func handleSuccess(orders: [GBROrderModel]) {
            stopLoader()
            orderProductsBag.accept([])
            totalPrice.accept(0)
            orders.forEach { order in
                orderProductsBag.accept(orderProductsBag.value +
                                         [.init(model: "\(Date.getDateFormatter(timestamp: order.timestamp)) - \(order.status.rawValue)",
                                                items: order.products)])
                var price: Double = 0
                order.products.forEach { productBag in
                    price += productBag.product.price * Double(productBag.quantity)
                }
                totalPrice.accept(totalPrice.value + price)
            }
        }
        
        func handleError(error: Error) {
            stopLoader()
            if error is DecodableErrorType {
                showAlert.onNext(getAlertEmptyErrorModel())
                return
            }
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
    
    private func getAlertEmptyErrorModel() -> ShowAlertModel {
        .init(title: "\(client.name) ainda não realizou nenhum pedido!",
              message: "",
              viewControllerRef: viewControllerRef)
    }
}

extension GBRClientOrdersViewModel: GrubChaserLoadableViewModel {}
extension GBRClientOrdersViewModel: GrubChaserAlertableViewModel {}
