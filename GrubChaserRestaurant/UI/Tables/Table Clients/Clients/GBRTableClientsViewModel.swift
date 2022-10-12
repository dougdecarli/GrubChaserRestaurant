//
//  GBRTableClientsViewModel.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 11/10/22.
//

import UIKit
import RxSwift
import RxCocoa

class GBRTableClientsViewModel: GrubChaserBaseViewModel<GBRTablesRouterProtocol> {
    var tableClientsCells: Observable<[GBRUserModel]> {
        clients.asObservable()
    }
    
    let onClientTouched = PublishRelay<GBRUserModel>(),
        table: GBRTableModel
    
    private lazy var clients = BehaviorRelay<[GBRUserModel]>(value: table.clients ?? [])
    
    init(table: GBRTableModel,
         router: GBRTablesRouterProtocol,
         viewControllerRef: UIViewController) {
        self.table = table
        super.init(router: router,
                   viewControllerRef: viewControllerRef)
    }
    
    override func setupBindings() {
        super.setupBindings()
        setupOnClientTouched()
    }
    
    //MARK: - Inputs
    private func setupOnClientTouched() {
        onClientTouched
            .subscribe(onNext: presentClientOrders)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Navigation
    private func presentClientOrders(client: GBRUserModel) {
        router.goToClientOrders(table: table,
                                client: client)
    }
}

