//
//  GBRClientOrdersViewController.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 11/10/22.
//

import UIKit
import RxSwift
import RxDataSources

class GBRClientOrdersViewController: GrubChaserBaseViewController<GBRClientOrdersViewModel> {
    @IBOutlet weak var clientOrdersTableView: UITableView!

    typealias ClientsOrderSectionModel = AnimatableSectionModel<String, GBRProductBag>
    typealias ClientsOrderTableViewDataSource = RxTableViewSectionedAnimatedDataSource<ClientsOrderSectionModel>
    lazy var dataSource = ClientsOrderTableViewDataSource(animationConfiguration: .init(insertAnimation: .automatic), configureCell: { [weak self] (dataSource, tableView, indexPath, item) in
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
        definesPresentationContext = true
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
            .clientOrdersCells
            .map { items -> [ClientsOrderSectionModel] in
                return [ClientsOrderSectionModel(model: "", items: items)]
            }
            .bind(to: clientOrdersTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        clientOrdersTableView.register(UINib(nibName: GBROrderProductsTableViewCell.nibName, bundle: .main), forCellReuseIdentifier: GBROrderProductsTableViewCell.identifier)
    }
}
