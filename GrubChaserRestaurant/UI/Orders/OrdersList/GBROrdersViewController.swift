//
//  GBROrdersViewController.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 06/10/22.
//

import UIKit
import RxSwift
import RxDataSources

class GBROrdersViewController: GrubChaserBaseViewController<GBROrdersViewModel> {
    @IBOutlet weak var newOrdersTableView: UITableView!
    @IBOutlet weak var ordersSegmentedControl: UISegmentedControl!
    
    typealias OrdersSectionModel = SectionModel<String, GBROrderModel>
    typealias OrdersTableViewDataSource = RxTableViewSectionedReloadDataSource<OrdersSectionModel>
    lazy var dataSource = OrdersTableViewDataSource(configureCell: { [weak self] (dataSource, tableView, indexPath, item) in
        guard let self = self else { return UITableViewCell() }
        if let cell = tableView.dequeueReusableCell(withIdentifier: GBROrdersTableViewCell.identifier,
                                                    for: indexPath) as? GBROrdersTableViewCell {
            self.setupOnConfirmButtonTouched(cell: cell, order: item)
            cell.bind(order: item)
            return cell
        }
        else {
            return UITableViewCell()
        }
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        newOrdersTableView
            .rx
            .modelSelected(GBROrderModel.self)
            .bind(to: viewModel.onOrderTouched)
            .disposed(by: disposeBag)
        
        ordersSegmentedControl
            .rx
            .selectedSegmentIndex
            .map { OrdersSegmented($0) }
            .bind(to: viewModel.onSegmentedOrderSelected)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        viewModel
            .newOrdersCells
            .map { items -> [OrdersSectionModel] in
                return [OrdersSectionModel(model: "", items: items)]
            }
            .bind(to: newOrdersTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel
            .setSelectedSegmentedOrder
            .map(\.rawValue)
            .bind(to: ordersSegmentedControl.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
        
        viewModel
            .tabBarBadgeValue
            .bind(to: navigationController!.tabBarItem.rx.badgeValue)
            .disposed(by: disposeBag)
        
        
    }
    
    private func setupOnConfirmButtonTouched(cell: GBROrdersTableViewCell,
                                             order: GBROrderModel) {
        cell.confirmButton.rx.tap
            .flatMap { Observable.of(order) }
            .bind(to: viewModel.onConfirmButtonTouched)
            .disposed(by: cell.rx.disposeBag)
    }
    
    private func setupTableView() {
        newOrdersTableView.register(UINib(nibName: GBROrdersTableViewCell.nibName,
                                          bundle: .main),
                                    forCellReuseIdentifier: GBROrdersTableViewCell.identifier)
    }
}
