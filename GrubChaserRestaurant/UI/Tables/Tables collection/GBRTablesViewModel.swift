//
//  GBRTablesViewModel.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 10/10/22.
//

import RxSwift
import RxCocoa

class GBRTablesViewModel: GrubChaserBaseViewModel<GBRTablesRouterProtocol> {
    var tableCells: Observable<[GBRTableModel]> {
        tables.asObservable()
    }
    
    var showAlert = PublishSubject<ShowAlertModel>(),
        isLoaderShowing = PublishSubject<Bool>()
    
    let onViewWillAppear = PublishRelay<Void>(),
        onTableTouched = PublishRelay<GBRTableModel>()
    
    private let tables = BehaviorRelay<[GBRTableModel]>(value: [])
    
    override func setupBindings() {
        super.setupBindings()
        setupOnViewWillAppear()
        setupOnTableTouched()
    }
    
    //MARK: - Inputs
    private func setupOnViewWillAppear() {
        onViewWillAppear
            .do(onNext: startLoader)
            .subscribe(onNext: getRestaurantTables)
            .disposed(by: disposeBag)
    }
    
    private func setupOnTableTouched() {
        onTableTouched
            .subscribe(onNext: presentClientsTable)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Service
    private func getRestaurantTables() {
        func handleSuccess(tables: [GBRTableModel]) {
            stopLoader()
            self.tables.accept(tables)
        }
        
        func handleError(_: Error) {
            stopLoader()
        }
        
        service.getTables()
            .subscribe(onNext: handleSuccess(tables:),
                       onError: handleError(_:))
            .disposed(by: disposeBag)
    }
    
    //MARK: - Navigation
    private func presentClientsTable(table: GBRTableModel) {
        guard let _ = table.clients?.count else {
            showAlert.onNext(getAlertConfirmOrderErrorModel(tableName: table.name))
            return
        }
        router.presentTableClients(table: table)
    }
    
    private func getAlertConfirmOrderErrorModel(tableName: String) -> ShowAlertModel {
        .init(title: "\(tableName) ainda não possui pedidos",
              message: "",
              viewControllerRef: viewControllerRef)
    }
}

extension GBRTablesViewModel: GrubChaserLoadableViewModel {}
extension GBRTablesViewModel: GrubChaserAlertableViewModel {}
