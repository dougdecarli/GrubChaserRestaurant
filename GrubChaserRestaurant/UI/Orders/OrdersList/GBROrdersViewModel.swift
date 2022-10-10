//
//  GBROrdersViewModel.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 06/10/22.
//

import RxSwift
import RxCocoa

class GBROrdersViewModel: GrubChaserBaseViewModel<GBROrdersRouterProtocol> {
    var newOrdersCells: Observable<[GBROrderModel]> {
        newOrders.asObservable()
    }
    
    var showAlert = PublishSubject<ShowAlertModel>(),
        isLoaderShowing = PublishSubject<Bool>()
    
    private let newOrders = BehaviorRelay<[GBROrderModel]>(value: [])
    
    let onViewWillAppear = PublishRelay<Void>(),
        onConfirmButtonTouched = PublishRelay<GBROrderModel>(),
        onOrderTouched = PublishRelay<GBROrderModel>()
    
    override func setupBindings() {
        super.setupBindings()
        setupOnViewWillAppear()
        setupOnConfirmButtonTouched()
        setupOnOrderTouched()
        observeNewOrdersAddition()
    }
    
    //MARK: Inputs
    private func setupOnViewWillAppear() {
        onViewWillAppear
            .do(onNext: startLoading(_:))
            .subscribe(onNext: getRestaurantNewOrders)
            .disposed(by: disposeBag)
    }
    
    private func setupOnConfirmButtonTouched() {
        onConfirmButtonTouched
            .do(onNext: startLoading)
            .subscribe(onNext: postOrderConfirmed)
            .disposed(by: disposeBag)
    }
    
    private func setupOnOrderTouched() {
        onOrderTouched
            .subscribe(onNext: router.presentOrderVc)
            .disposed(by: disposeBag)
    }
    
    //MARK: Service
    private func getRestaurantNewOrders() {
        func handleSuccess(_ orders: [GBROrderModel]) {
            stopLoading()
            newOrders.accept(orders)
        }
        
        func handleError(error: Error) {
            stopLoading()
            if error is DecodableErrorType {
                newOrders.accept([])
                return
            }
            showAlert.onNext(getAlertErrorModel())
        }
        
        service.getNewOrders()
            .subscribe(onNext: handleSuccess(_:),
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    private func postOrderConfirmed(order: GBROrderModel) {
        func handleSuccess() {
            stopLoading()
        }
        
        func handleError(_: Error) {
            stopLoading()
            showAlert.onNext(getAlertConfirmOrderErrorModel())
        }
        
        service.postOrderConfirmed(orderId: order.orderId)
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    private func observeNewOrdersAddition() {
        service.listenToNewOrders()
            .subscribe(onNext: getRestaurantNewOrders)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Helper methods
    private func getAlertErrorModel() -> ShowAlertModel {
        .init(title: "Não foi possível buscar pedidos",
              message: "Tente novamente",
              viewControllerRef: viewControllerRef)
    }
    
    private func getAlertConfirmOrderErrorModel() -> ShowAlertModel {
        .init(title: "Não foi confirmar o pedido",
              message: "Tente novamente",
              viewControllerRef: viewControllerRef)
    }
    
    private func getAlertEmptyOrdersErrorModel() -> ShowAlertModel {
        .init(title: "Nenhum pedido novo para confirmar!",
              message: "",
              viewControllerRef: viewControllerRef)
    }
    
    private func startLoading(_: Any? = nil) {
        isLoaderShowing.onNext(true)
    }
    
    private func stopLoading(_: Any? = nil) {
        isLoaderShowing.onNext(false)
    }
}

extension GBROrdersViewModel: GrubChaserLoadableViewModel {}
extension GBROrdersViewModel: GrubChaserAlertableViewModel {}
