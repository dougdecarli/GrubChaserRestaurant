//
//  GBRTableClientsViewController.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 11/10/22.
//

import UIKit
import RxSwift
import RxDataSources

class GBRTableClientsViewController: GrubChaserBaseViewController<GBRTableClientsViewModel> {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var clientsTableView: UITableView!
    
    typealias ClientsSectionModel = AnimatableSectionModel<String, GBRUserModel>
    typealias ClientsTableViewDataSource = RxTableViewSectionedAnimatedDataSource<ClientsSectionModel>
    lazy var dataSource = ClientsTableViewDataSource(animationConfiguration: .init(insertAnimation: .automatic), configureCell: { [weak self] (dataSource, tableView, indexPath, item) in
        guard let self = self else { return UITableViewCell() }
        if let cell = tableView.dequeueReusableCell(withIdentifier: GBRTableClientTableViewCell.identifier,
                                                    for: indexPath) as? GBRTableClientTableViewCell {
            cell.bind(client: item)
            return cell
        }
        else {
            return UITableViewCell()
        }
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.items?.first?.title = "Clientes - \(viewModel.table.name)"
        setupTableView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func bindInputs() {
        super.bindInputs()
        
        clientsTableView
            .rx
            .modelSelected(GBRUserModel.self)
            .do(onNext: dismiss)
            .bind(to: viewModel.onClientTouched)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        viewModel
            .tableClientsCells
            .map { items -> [ClientsSectionModel] in
                return [ClientsSectionModel(model: "", items: items)]
            }
            .bind(to: clientsTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        clientsTableView.register(UINib(nibName: GBRTableClientTableViewCell.nibName,
                                          bundle: .main),
                                    forCellReuseIdentifier: GBRTableClientTableViewCell.identifier)
    }
    
    private func dismiss(_: Any) {
        dismiss(animated: true) {}
    }
}
