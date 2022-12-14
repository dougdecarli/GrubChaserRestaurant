//
//  GBROrdersViewModel.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 06/10/22.
//

import RxSwift
import RxCocoa

enum OrdersSegmented: Int {
    case newOrders = 0
    case confirmed = 1
    case finished = 2
    
    init(_ segmentedSelected: Int) {
        switch segmentedSelected {
        case 0:
            self = .newOrders
        case 1:
            self = .confirmed
        case 2:
            self = .finished
        default:
            self = .newOrders
        }
    }
}

class GBROrdersViewModel: GrubChaserBaseViewModel<GBROrdersRouterProtocol> {
    var newOrdersCells: Observable<[GBROrderModel]> {
        orders.asObservable()
    }
    
    var showAlert = PublishSubject<ShowAlertModel>(),
        isLoaderShowing = PublishSubject<Bool>()
    
    private let orders = BehaviorRelay<[GBROrderModel]>(value: [])
    
    let onViewWillAppear = PublishRelay<Void>(),
        onConfirmButtonTouched = PublishRelay<GBROrderModel>(),
        onOrderTouched = PublishRelay<GBROrderModel>(),
        onSegmentedOrderSelected = BehaviorRelay<OrdersSegmented>(value: .newOrders),
        setSelectedSegmentedOrder = PublishRelay<OrdersSegmented>(),
        tabBarBadgeValue = PublishRelay<String?>()
    
    override init(router: GBROrdersRouterProtocol, viewControllerRef: UIViewController) {
        super.init(router: router, viewControllerRef: viewControllerRef)
        observeOrders()
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnViewWillAppear()
        setupOnConfirmButtonTouched()
        setupOnOrderTouched()
        setupOnSegmentedOrderSelected()
        observeOrdersFromStatus()
    }
    
    //MARK: Inputs
    private func setupOnViewWillAppear() {
        onViewWillAppear
            .do(onNext: startLoading(_:))
            .withLatestFrom(onSegmentedOrderSelected)
            .map { GBROrderStatus($0.rawValue) }
            .subscribe(onNext: getRestaurantOrders)
            .disposed(by: disposeBag)
    }
    
    private func setupOnConfirmButtonTouched() {
        onConfirmButtonTouched
            .do(onNext: startLoading)
            .map { [weak self] order -> (String, GBROrderStatus) in
                guard let self = self else { return ("", .waitingConfirmation) }
                return (order.orderId, self.retrieveStatusToPut(from: order))
            }
            .subscribe(onNext: putOrderStatus)
            .disposed(by: disposeBag)
    }
    
    private func setupOnOrderTouched() {
        onOrderTouched
            .subscribe(onNext: router.presentOrderVc)
            .disposed(by: disposeBag)
    }
    
    private func setupOnSegmentedOrderSelected() {
        onSegmentedOrderSelected
            .do(onNext: startLoading)
            .do(onNext: eraseCells)
            .map { GBROrderStatus($0.rawValue) }
            .subscribe(onNext: getRestaurantOrders)
            .disposed(by: disposeBag)
    }
    
    //MARK: Service
    private func getRestaurantOrders(from status: GBROrderStatus) {
        func handleSuccess(_ ordersModel: [GBROrderModel]) {
            stopLoading()
            orders.accept(ordersModel)
        }
        
        func handleError(error: Error) {
            stopLoading()
            if error is DecodableErrorType {
                orders.accept([])
                return
            }
            showAlert.onNext(getAlertErrorModel())
        }
        
        service.getRestaurantOrders(from: status)
            .subscribe(onNext: handleSuccess(_:),
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    private func getAllRestaurantOrders() {
        func handleSuccess(_ ordersModel: [GBROrderModel]) {
            stopLoading()
            let waitingConfirmationOrders = ordersModel.filter { $0.status == .waitingConfirmation }.count
            tabBarBadgeValue.accept(waitingConfirmationOrders > 0 ? String(waitingConfirmationOrders) : nil)
        }
        
        func handleError(error: Error) {
            stopLoading()
            if error is DecodableErrorType {
                orders.accept([])
                return
            }
            showAlert.onNext(getAlertErrorModel())
        }
        
        service.getAllRestaurantOrders()
            .subscribe(onNext: handleSuccess(_:),
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    private func putOrderStatus(orderId: String,
                                _ status: GBROrderStatus) {
        func handleSuccess() {
            stopLoading()
            eraseCells()
            setSelectedSegmentedOrder.accept(OrdersSegmented(status == .confirmed ? 1 : 2))
            getRestaurantOrders(from: status)
        }
        
        func handleError(_: Error) {
            stopLoading()
            showAlert.onNext(getAlertConfirmOrderErrorModel())
        }
        
        service.putOrderStatus(orderId,
                               to: status)
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    private func observeOrders() {
        _ = service.listenToOrders()
            .subscribe(onNext: getAllRestaurantOrders)
    }
    
    private func observeOrdersFromStatus() {
        service.listenToOrders()
            .withLatestFrom(onSegmentedOrderSelected)
            .map { GBROrderStatus($0.rawValue) }
            .subscribe(onNext: getRestaurantOrders)
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
    
    private func eraseCells(_: Any? = nil) {
        orders.accept([])
    }
    
    private func getAlertErrorModel() -> ShowAlertModel {
        .init(title: "N??o foi poss??vel buscar pedidos",
              message: "Tente novamente",
              viewControllerRef: viewControllerRef)
    }
    
    private func getAlertConfirmOrderErrorModel() -> ShowAlertModel {
        .init(title: "N??o foi confirmar o pedido",
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
