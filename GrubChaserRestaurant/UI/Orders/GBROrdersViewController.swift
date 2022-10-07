//
//  GBROrdersViewController.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 06/10/22.
//

import UIKit
import RxDataSources

class GBROrdersViewController: GrubChaserBaseViewController<GBROrdersViewModel> {
    @IBOutlet weak var newOrdersTableView: UITableView!
    
    typealias OrdersSectionModel = SectionModel<String, [GBROrderModel]>
    typealias OrdersTableViewDataSource = RxTableViewSectionedReloadDataSource<OrdersSectionModel>
//    var dataSource = OrdersTableViewDataSource(configureCell: { (dataSource, collectionView, indexPath, item) in
//    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Novos Pedidos"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        viewModel = GBROrdersViewModel(router: GBROrderRouter(navigationController: navigationController ?? UINavigationController()),
                                       viewControllerRef: self)
        setupTableView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear.accept(())
    }
    
    override func bindInputs() {
        super.bindInputs()
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        viewModel
            .newOrdersCells
            .bind(to: newOrdersTableView.rx.items(cellIdentifier: GBROrdersTableViewCell.identifier,
                                                  cellType: GBROrdersTableViewCell.self)) {
                (row, element, cell) in
                cell.bind(order: element)
            }.disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        newOrdersTableView.register(UINib(nibName: GBROrdersTableViewCell.nibName,
                                          bundle: .main),
                                    forCellReuseIdentifier: GBROrdersTableViewCell.identifier)
    }
}
