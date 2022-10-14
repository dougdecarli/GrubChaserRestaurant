//
//  GBROrderDetailViewModel.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 09/10/22.
//

import Foundation
import RxSwift
import RxCocoa

class GBROrderDetailViewModel: GrubChaserBaseViewModel<GBROrdersRouterProtocol> {
    var orderProductsCells: Observable<[GBRProductBag]> {
        .just(order.products)
    }
    
    var totalPriceDriver: Driver<String> {
        Observable.of(order.products)
            .map { productsOrder -> String in
                var totalPrice: Double = 0
                productsOrder.forEach { order in
                    totalPrice += (order.product.price * Double(order.quantity))
                }
                return String(totalPrice).currencyFormatting()
            }
            .asDriver(onErrorJustReturn: "")
    }
    
    let order: GBROrderModel,
        onConfirmOrderButtonTouched = PublishRelay<Void>(),
        onOrderConfirmedSuccess = PublishRelay<Void>()
    
    internal var showAlert = PublishSubject<ShowAlertModel>(),
                 isLoaderShowing = PublishSubject<Bool>()
    
    init(router: GBROrdersRouterProtocol,
         viewControllerRef: UIViewController,
         order: GBROrderModel) {
        self.order = order
        super.init(router: router, viewControllerRef: viewControllerRef)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnConfirmOrderButtonTouched()
    }
    
    //MARK: - Inputs
    private func setupOnConfirmOrderButtonTouched() {
        onConfirmOrderButtonTouched
            .do(onNext: startLoading)
            .map { [weak self] _ -> (String, GBROrderStatus) in
                guard let self = self else { return ("", .waitingConfirmation) }
                return (self.order.orderId, self.retrieveStatusToPut(from: self.order))
            }
            .subscribe(onNext: putOrderStatus)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Service
    private func putOrderStatus(orderId: String,
                                _ status: GBROrderStatus) {
        func handleSuccess() {
            stopLoading()
            onOrderConfirmedSuccess.accept(())
        }
        
        func handleError(_: Error) {
            stopLoading()
            showAlert.onNext(getAlertConfirmOrderErrorModel())
        }
        
        service.putOrderStatus(order.orderId,
                               to: status)
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Helper methods
    private func retrieveStatusToPut(from order: GBROrderModel) -> GBROrderStatus {
        if order.status == .waitingConfirmation {
            return .confirmed
        } else {
            return .finished
        }
    }
    
    private func startLoading(_: Any? = nil) {
        isLoaderShowing.onNext(true)
    }
    
    private func stopLoading(_: Any? = nil) {
        isLoaderShowing.onNext(false)
    }
    
    private func getAlertConfirmOrderErrorModel() -> ShowAlertModel {
        .init(title: "Não foi possível confirmar o pedido",
              message: "Tente novamente",
              viewControllerRef: viewControllerRef)
    }
}

extension GBROrderDetailViewModel: GrubChaserLoadableViewModel {}
extension GBROrderDetailViewModel: GrubChaserAlertableViewModel {}
