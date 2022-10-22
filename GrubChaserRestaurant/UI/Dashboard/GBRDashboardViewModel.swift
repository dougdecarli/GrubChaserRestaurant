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
                weeklyOrdersNumber = BehaviorRelay<Int>(value: 0),
                monthlyOrdersNumber = BehaviorRelay<Int>(value: 0),
                todaysRevenueValue = BehaviorRelay<Double>(value: 0),
                weeklyRevenueValue = BehaviorRelay<Double>(value: 0),
                monthlyRevenueValue = BehaviorRelay<Double>(value: 0)
    
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
                                 weeklyOrdersNumber,
                                 monthlyOrdersNumber,
                                 todaysRevenueValue,
                                 weeklyRevenueValue)
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
            getOrders()
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
    private func getOrders() {
        func handleSuccess(todaysOrders: Int,
                           weeklyOrders: Int,
                           monthlyOrders: Int) {
            todaysOrdersNumber.accept(todaysOrders)
            weeklyOrdersNumber.accept(weeklyOrders)
            monthlyOrdersNumber.accept(monthlyOrders)
            getRevenues()
        }
        
        func handleError(_: Error) {
            stopLoader()
        }
        
        service.getNumberOfOrdersByTodayWeeklyAndMonthly()
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }

    private func getRevenues() {
        func handleSuccess(todaysRevenue: Double,
                           weeklyRevenue: Double,
                           monthlyRevenue: Double) {
            monthlyRevenueValue.accept(monthlyRevenue)
            todaysRevenueValue.accept(todaysRevenue)
            weeklyRevenueValue.accept(weeklyRevenue)
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
                          todaysOrders: Int,
                          weeklyOrders: Int,
                          monthlyOrders: Int,
                          todaysRevenue: Double,
                          weeklyRevenue: Double) -> Observable<[GBRDashboardModel]> {
        Observable.of(addActiveClientsCell(clients) +
                      addOccupiedTablesCell(occupiedTables) +
                      addFreeTablesCell(freeTables) +
                      addTodaysOrdersCell(todaysOrders, weeklyOrders, monthlyOrders) +
                      addTodaysRevenueCell(todaysRevenue, weeklyRevenue, monthlyRevenueValue.value))
    }
    
    //MARK: Realtime
    private func addActiveClientsCell(_ clients: Int) -> [GBRDashboardModel] {
        [.init(title: "Clientes ativos", value: String(clients), type: .realtime)]
    }
    
    private func addOccupiedTablesCell(_ occupiedTables: Int) -> [GBRDashboardModel] {
        [.init(title: "Mesas ocupadas", value: String(occupiedTables), type: .realtime)]
    }
    
    private func addFreeTablesCell(_ freeTables: Int) -> [GBRDashboardModel] {
        [.init(title: "Mesas livres", value: String(freeTables), type: .realtime)]
    }
    
    //MARK: Orders
    private func addTodaysOrdersCell(_ todaysOrders: Int,
                                     _ weeklyOrders: Int,
                                     _ monthlyOrders: Int) -> [GBRDashboardModel] {
        [.init(title: "Pedidos hoje", value: String(todaysOrders), type: .orders),
         .init(title: "Pedidos esta semana", value: String(weeklyOrders), type: .orders),
         .init(title: "Pedidos este mês", value: String(monthlyOrders), type: .orders)]
    }
    
    private func addTodaysRevenueCell(_ todaysRevenue: Double,
                                      _ weeklyRevenue: Double,
                                      _ monthlyRevenue: Double) -> [GBRDashboardModel] {
        [.init(title: "Receita hoje", value: String(todaysRevenue).currencyFormatting(), type: .revenue),
         .init(title: "Receita semanal", value: String(weeklyRevenue).currencyFormatting(), type: .revenue),
         .init(title: "Receita mensal", value: String(monthlyRevenue).currencyFormatting(), type: .revenue)]
    }
}

extension GBRDashboardViewModel: GrubChaserLoadableViewModel {}
extension GBRDashboardViewModel: GrubChaserAlertableViewModel {}
