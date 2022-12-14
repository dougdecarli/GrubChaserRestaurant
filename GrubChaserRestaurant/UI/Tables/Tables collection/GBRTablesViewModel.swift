//
//  GBRTablesViewModel.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 10/10/22.
//

import RxSwift
import RxCocoa

enum TablesSegmentedControlType: Int {
    case allTables = 0
    case occupiedTables = 1
    
    init(_ segmentedSelected: Int) {
        switch segmentedSelected {
        case 0:
            self = .allTables
        case 1:
            self = .occupiedTables
        default:
            self = .allTables
        }
    }
}

class GBRTablesViewModel: GrubChaserBaseViewModel<GBRTablesRouterProtocol> {
    var tableCells: Observable<[GBRTableModel]> {
        tables.asObservable()
    }
    
    var showAlert = PublishSubject<ShowAlertModel>(),
        isLoaderShowing = PublishSubject<Bool>()
    
    let onViewWillAppear = PublishRelay<Void>(),
        onTableTouched = PublishRelay<GBRTableModel>(),
        tablesSegmented = BehaviorRelay<TablesSegmentedControlType>(value: .allTables)
    
    private let tables = BehaviorRelay<[GBRTableModel]>(value: [])
    
    override func setupBindings() {
        super.setupBindings()
        observeTables()
        setupOnViewWillAppear()
        setupOnTableTouched()
        setupOnSegmentedSelected()
    }
    
    //MARK: - Inputs
    private func setupOnViewWillAppear() {
        onViewWillAppear
            .do(onNext: startLoader)
            .do(onNext: eraseTables)
            .withLatestFrom(tablesSegmented)
            .subscribe(onNext: routeToGetTables)
            .disposed(by: disposeBag)
    }
    
    private func setupOnTableTouched() {
        onTableTouched
            .subscribe(onNext: presentClientsTable)
            .disposed(by: disposeBag)
    }
    
    private func setupOnSegmentedSelected() {
        tablesSegmented
            .do(onNext: startLoading)
            .do(onNext: eraseTables)
            .subscribe(onNext: routeToGetTables)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Service
    private func routeToGetTables(from segmentedSelected: TablesSegmentedControlType) {
        segmentedSelected == .occupiedTables ?
        getOccupiedRestaurantTables() :
        getAllRestaurantTables()
    }
    
    private func getAllRestaurantTables() {
        func handleSuccess(tables: [GBRTableModel]) {
            stopLoader()
            self.tables.accept(tables)
        }
        
        func handleError(_: Error) {
            stopLoader()
        }
        
        service.getAllTables()
            .subscribe(onNext: handleSuccess(tables:),
                       onError: handleError(_:))
            .disposed(by: disposeBag)
    }
    
    private func getOccupiedRestaurantTables() {
        func handleSuccess(tables: [GBRTableModel]) {
            stopLoader()
            self.tables.accept(tables.filter { $0.clients!.count > 0 })
        }
        
        func handleError(_: Error) {
            stopLoader()
        }
        
        service.getOccupiedTables()
            .subscribe(onNext: handleSuccess(tables:),
                       onError: handleError(_:))
            .disposed(by: disposeBag)
    }
    
    private func observeTables() {
        service
            .listenToTables()
            .withLatestFrom(tablesSegmented)
            .subscribe(onNext: routeToGetTables)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Navigation
    private func presentClientsTable(table: GBRTableModel) {
        if let clients = table.clients,
           clients.count > 0 {
            router.presentTableClients(table: table)
        } else {
            showAlert.onNext(getAlertConfirmOrderErrorModel(tableName: table.name))
        }
    }
    
    private func getAlertConfirmOrderErrorModel(tableName: String) -> ShowAlertModel {
        .init(title: "\(tableName) ainda n??o possui clientes",
              message: "",
              viewControllerRef: viewControllerRef)
    }
    
    //MARK: - Helper methods
    private func eraseTables(_: Any?) {
        tables.accept([])
    }
    
    private func startLoading(_: Any? = nil) {
        isLoaderShowing.onNext(true)
    }
}

extension GBRTablesViewModel: GrubChaserLoadableViewModel {}
extension GBRTablesViewModel: GrubChaserAlertableViewModel {}
