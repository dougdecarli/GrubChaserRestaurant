//
//  GrubChaserBaseViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 22/08/22.
//

import RxCocoa
import RxSwift

class GrubChaserBaseViewModel<Router>: GrubChaserViewModelProtocol {
    var disposeBag = DisposeBag(),
        service = GBRService.instance,
        router: Router,
        viewControllerRef: UIViewController
    
    init(router: Router,
         viewControllerRef: UIViewController) {
        self.router = router
        self.viewControllerRef = viewControllerRef
    }
    
    open func setupBindings() {}
    
    open func cleanBindings() {
        disposeBag = DisposeBag()
    }
}
