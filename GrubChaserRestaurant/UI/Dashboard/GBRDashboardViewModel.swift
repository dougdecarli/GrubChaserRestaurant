//
//  GBRDashboardViewModel.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 21/10/22.
//

import RxCocoa
import RxSwift

class GBRDashboardViewModel: GrubChaserBaseViewModel<GBRDashboardRouterProtocol> {
    let onViewWillAppear = PublishRelay<Void>()
    
    var showAlert = PublishSubject<ShowAlertModel>(),
        isLoaderShowing = PublishSubject<Bool>()
    
    var dashboardCells: Observable<[GBRDashboardModel]> {
        setupDashboardCells()
    }
    
    private var activeClientsNumber = BehaviorRelay<Int>(value: 0),
                occupiedTablesNumber = BehaviorRelay<Int>(value: 0),
                freeTablesNumber = BehaviorRelay<Int>(value: 0),
                todaysOrdersNumber = BehaviorRelay<Int>(value: 0),
                todaysRevenueValue = BehaviorRelay<Double>(value: 0)
    
    override func setupBindings() {
        super.setupBindings()
        setupOnViewWillAppear()
    }
    
    //MARK: - Inputs
    private func setupOnViewWillAppear() {
        onViewWillAppear
            .do(onNext: startLoader)
            .subscribe(onNext: getActiveClients)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Outputs
    private func setupDashboardCells() -> Observable<[GBRDashboardModel]> {
        Observable.combineLatest(activeClientsNumber,
                                 occupiedTablesNumber,
                                 freeTablesNumber,
                                 todaysOrdersNumber,
                                 todaysRevenueValue)
            .flatMap(addCells)
    }
    
    //MARK: - Service
    //MARK: Realtime data
    private func getActiveClients() {
        func handleSuccess(numberOfActiveClients: Int) {
            activeClientsNumber.accept(numberOfActiveClients)
            getTables()
        }
        
        func handleError(_: Error) {
            stopLoader()
        }
        
        service.getNumberOfActiveClients()
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    private func getTables() {
        func handleSuccess(tables: [GBRTableModel]) {
            let numberOfOccupiedTables = tables.filter { $0.clients?.count ?? 0 > 0 }
            occupiedTablesNumber.accept(numberOfOccupiedTables.count)
            freeTablesNumber.accept(tables.count - numberOfOccupiedTables.count)
            getTodaysOrders()
        }
        
        func handleError(_: Error) {
            stopLoader()
        }
        
        service.getAllTables()
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    //MARK: Orders and revenue
    private func getTodaysOrders() {
        func handleSuccess(todaysOrders: Int) {
            todaysOrdersNumber.accept(todaysOrders)
            getTodaysRevenue()
        }
        
        func handleError(_: Error) {
            stopLoader()
        }
        
        service.getTodaysNumberOfOrders()
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }

    private func getTodaysRevenue() {
        func handleSuccess(todaysRevenue: Double) {
            todaysRevenueValue.accept(todaysRevenue)
            stopLoader()
        }
        
        func handleError(_: Error) {
            stopLoader()
        }
        
        service.getTodaysRevenue()
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Cells management
    private func addCells(clients: Int,
                          occupiedTables: Int,
                          freeTables: Int,
                          todaysOrder: Int,
                          todaysRevenue: Double) -> Observable<[GBRDashboardModel]> {
        Observable.of(addActiveClientsCell(clients) +
                      addOccupiedTablesCell(occupiedTables) +
                      addFreeTablesCell(freeTables) +
                      addTodaysOrdersCell(todaysOrder) +
                      addTodaysRevenueCell(todaysRevenue))
    }
    
    //MARK: Realtime
    private func addActiveClientsCell(_ clients: Int) -> [GBRDashboardModel] {
        [.init(title: "Clientes ativos", value: String(clients))]
    }
    
    private func addOccupiedTablesCell(_ occupiedTables: Int) -> [GBRDashboardModel] {
        [.init(title: "Mesas ocupadas", value: String(occupiedTables))]
    }
    
    private func addFreeTablesCell(_ freeTables: Int) -> [GBRDashboardModel] {
        [.init(title: "Mesas livres", value: String(freeTables))]
    }
    
    //MARK: Orders
    private func addTodaysOrdersCell(_ todaysOrder: Int) -> [GBRDashboardModel] {
        [.init(title: "Pedidos hoje", value: String(todaysOrder))]
    }
    
    private func addTodaysRevenueCell(_ todaysRevenue: Double) -> [GBRDashboardModel] {
        [.init(title: "Receita hoje", value: String(todaysRevenue).currencyFormatting())]
    }
}

extension GBRDashboardViewModel: GrubChaserLoadableViewModel {}
extension GBRDashboardViewModel: GrubChaserAlertableViewModel {}
