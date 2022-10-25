//
//  GBROrderDetailViewController.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 09/10/22.
//

import UIKit
import RxDataSources

class GBROrderDetailViewController: GrubChaserBaseViewController<GBROrderDetailViewModel> {
    @IBOutlet weak var confirmOrderButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderPriceLabel: UILabel!
    
    typealias OrderProductsSectionModel = AnimatableSectionModel<String, GBRProductBag>
    typealias OrderProductsViewDataSource = RxTableViewSectionedAnimatedDataSource<OrderProductsSectionModel>
    lazy var dataSource = OrderProductsViewDataSource(animationConfiguration: .init(insertAnimation: .automatic), configureCell: { [weak self] (dataSource, tableView, indexPath, item) in
        guard let self = self else { return UITableViewCell() }
        if let cell = tableView.dequeueReusableCell(withIdentifier: GBROrderProductsTableViewCell.identifier,
                                                    for: indexPath) as? GBROrderProductsTableViewCell {
            cell.bind(order: item)
            return cell
        }
        else {
            return UITableViewCell()
        }
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bind()
        setupConfirmationButtonLayout()
    }
    
    override func bindInputs() {
        super.bindInputs()
        
        confirmOrderButton.rx.tap
            .bind(to: viewModel.onConfirmOrderButtonTouched)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        viewModel
            .orderProductsCells
            .map { items -> [OrderProductsSectionModel] in
                return [OrderProductsSectionModel(model: "", items: items)]
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.onOrderConfirmedSuccess
            .subscribe(onNext: dismissAfterConfirmationSuccess)
            .disposed(by: disposeBag)
        
        viewModel
            .totalPriceDriver
            .drive(orderPriceLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupConfirmationButtonLayout() {
        switch viewModel.order.status {
        case .waitingConfirmation:
            confirmOrderButton.setTitle("Confirmar", for: .normal)
        case .confirmed:
            confirmOrderButton.setTitle("Finalizar", for: .normal)
        case .finished:
            confirmOrderButton.isHidden = true
        case .closed:
            break
        }
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: GBROrderProductsTableViewCell.nibName, bundle: .main), forCellReuseIdentifier: GBROrderProductsTableViewCell.identifier)
    }
    
    private func dismissAfterConfirmationSuccess(_ status: GBROrderStatus) {
        guard let tabBar = presentingViewController as? UITabBarController,
              let ordersNavBar = tabBar.viewControllers![0] as? UINavigationController,
              let presenter = ordersNavBar.topViewController as? GBROrdersViewController
        else {
            dismiss(animated: true)
            return
        }
        presenter.viewModel.setSelectedSegmentedOrder.accept(OrdersSegmented(status == .confirmed ? 1 : 2))
        presenter.viewModel.onSegmentedOrderSelected.accept(OrdersSegmented(status == .confirmed ? 1 : 2))
        dismiss(animated: true)
    }
}
