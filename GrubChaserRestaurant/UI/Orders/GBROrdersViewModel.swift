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
    
    let onViewWillAppear = PublishRelay<Void>()
    
    override func setupBindings() {
        super.setupBindings()
        setupOnViewWillAppear()
        observeNewOrdersAddition()
    }
    
    //MARK: Inputs
    private func setupOnViewWillAppear() {
        onViewWillAppear
            .do(onNext: startLoading(_:))
            .subscribe(onNext: getRestaurantNewOrders)
            .disposed(by: disposeBag)
    }
    
    //MARK: Outputs
    
    //MARK: Service
    private func getRestaurantNewOrders() {
        func handleSuccess(_ orders: [GBROrderModel]) {
            stopLoading()
            newOrders.accept(orders)
        }
        
        func handleError(_: Error) {
            stopLoading()
            showAlert.onNext(getAlertErrorModel())
        }
        
        service.getNewOrders()
            .subscribe(onNext: handleSuccess(_:),
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
    
    private func startLoading(_: Any? = nil) {
        isLoaderShowing.onNext(true)
    }
    
    private func stopLoading(_: Any? = nil) {
        isLoaderShowing.onNext(false)
    }
}

extension GBROrdersViewModel: GrubChaserLoadableViewModel {}
extension GBROrdersViewModel: GrubChaserAlertableViewModel {}
