//
//  GBRClientOrdersViewController.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 11/10/22.
//

import UIKit
import RxSwift
import RxDataSources

typealias ClientsOrderSectionModel = SectionModel<String, GBRProductBag>
typealias ClientsOrderTableViewDataSource = RxTableViewSectionedReloadDataSource<ClientsOrderSectionModel>

class GBRClientOrdersViewController: GrubChaserBaseViewController<GBRClientOrdersViewModel> {
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var finishOrdersButton: UIButton!
    @IBOutlet weak var clientOrdersTableView: UITableView!
    
    lazy var dataSource = ClientsOrderTableViewDataSource(configureCell: { [weak self] (dataSource, tableView, indexPath, item) in
        guard let self = self else { return UITableViewCell() }
        if let cell = tableView.dequeueReusableCell(withIdentifier: GBROrderProductsTableViewCell.identifier,
                                                    for: indexPath) as? GBROrderProductsTableViewCell {
            cell.bind(order: item)
            return cell
        }
        else {
            return UITableViewCell()
        }
    }, titleForHeaderInSection: { dataSource, indexPath in
        return dataSource[indexPath].model
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pedidos de \(viewModel.client.name.split(separator: " ").first!)"
        navigationController?.navigationBar.backItem?.title = "Mesas"
        setupTableView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear.accept(())
    }
    
    override func bindInputs() {
        super.bindInputs()
        
        finishOrdersButton
            .rx.tap
            .bind(to: viewModel.onFinishOrdersButton)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        viewModel
            .clientOrdersCells
            .startWith([])
            .bind(to: clientOrdersTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel
            .totalPrice
            .map { String($0).currencyFormatting() }
            .bind(to: totalPriceLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        clientOrdersTableView.register(UINib(nibName: GBROrderProductsTableViewCell.nibName,
                                             bundle: .main),
                                       forCellReuseIdentifier: GBROrderProductsTableViewCell.identifier)
    }
}
