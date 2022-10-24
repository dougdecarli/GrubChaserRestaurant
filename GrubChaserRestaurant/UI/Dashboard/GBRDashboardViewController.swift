//
//  GBRDashboardViewController.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 21/10/22.
//

import UIKit
import RxSwift
import RxDataSources

class GBRDashboardViewController: GrubChaserBaseViewController<GBRDashboardViewModel> {
    @IBOutlet weak var dashboardCollectionView: UICollectionView!
    
    typealias DashboardSectionModel = SectionModel<String, GBRDashboardModel>
    typealias DashboardDataSource = RxCollectionViewSectionedReloadDataSource<DashboardSectionModel>
    private let dataSource = DashboardDataSource { dataSource, collectionView, indexPath, item in
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GBRDashboardCollectionViewCell.identifier,
                                                         for: indexPath) as? GBRDashboardCollectionViewCell {
            cell.bind(dashboardModel: item)
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GBRDashboardViewModel(router: GBRDashboardRouter(navigationController: navigationController ?? UINavigationController()),
                                          viewControllerRef: self)
        setupCollectionView()
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
            .dashboardCells
            .map { items -> [DashboardSectionModel] in
                return [DashboardSectionModel(model: "", items: items)]
            }
            .bind(to: dashboardCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 3
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 3) - 3,
                                 height: (UIScreen.main.bounds.height / 4.5) - 3)
        dashboardCollectionView.collectionViewLayout = layout
        
        dashboardCollectionView.register(UINib(nibName: GBRDashboardCollectionViewCell.nibName,
                                            bundle: .main),
                                      forCellWithReuseIdentifier: GBRDashboardCollectionViewCell.identifier)
    }
}

