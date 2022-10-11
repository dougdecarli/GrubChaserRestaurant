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
    
    let onViewWillAppear = PublishRelay<Void>()
    
    private let tables = BehaviorRelay<[GBRTableModel]>(value: [])
    
    override func setupBindings() {
        super.setupBindings()
        setupOnViewWillAppear()
    }
    
    //MARK: - Inputs
    private func setupOnViewWillAppear() {
        onViewWillAppear
            .do(onNext: startLoader)
            .subscribe(onNext: getRestaurantTables)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Outputs
    
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
}

extension GBRTablesViewModel: GrubChaserLoadableViewModel {}
extension GBRTablesViewModel: GrubChaserAlertableViewModel {}
