//
//  GBRTablesViewController.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 10/10/22.
//

import UIKit
import RxDataSources

class GBRTablesViewController: GrubChaserBaseViewController<GBRTablesViewModel> {
    @IBOutlet weak var tablesCollectionView: UICollectionView!
    @IBOutlet weak var tablesSegmentedControl: UISegmentedControl!
    
    typealias TablesSectionModel = AnimatableSectionModel<String, GBRTableModel>
    typealias TablesDataSource = RxCollectionViewSectionedAnimatedDataSource<TablesSectionModel>
    private let dataSource = TablesDataSource(animationConfiguration: .init(insertAnimation: .automatic)) { dataSource, collectionView, indexPath, item in
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GBRTablesCollectionViewCell.identifier,
                                                         for: indexPath) as? GBRTablesCollectionViewCell {
            cell.bind(table: item)
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GBRTablesViewModel(router: GBRTablesRouter(navigationController: navigationController ?? UINavigationController()),
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
        
        tablesCollectionView
            .rx
            .modelSelected(GBRTableModel.self)
            .bind(to: viewModel.onTableTouched)
            .disposed(by: disposeBag)
        
        tablesSegmentedControl
            .rx
            .selectedSegmentIndex
            .map { TablesSegmentedControlType($0) }
            .bind(to: viewModel.tablesSegmented)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        viewModel
            .tableCells
            .map { items -> [TablesSectionModel] in
                return [TablesSectionModel(model: "", items: items)]
            }
            .bind(to: tablesCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 3
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 2) - 3,
                                 height: (UIScreen.main.bounds.width / 2) - 3)
        tablesCollectionView.collectionViewLayout = layout
        
        tablesCollectionView.register(UINib(nibName: GBRTablesCollectionViewCell.nibName,
                                            bundle: .main),
                                      forCellWithReuseIdentifier: GBRTablesCollectionViewCell.identifier)
    }
}
