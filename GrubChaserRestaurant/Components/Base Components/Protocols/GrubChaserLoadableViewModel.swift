//
//  GrubChaserLoadableViewModel.swift
//  GrubChaser
//
//  Created by Douglas Immig on 09/09/22.
//

import RxSwift

protocol GrubChaserLoadableViewModel {
    var isLoaderShowing: PublishSubject<Bool> { get }
}

extension GrubChaserLoadableViewModel {
    func startLoader(_: Any? = nil) {
        isLoaderShowing.onNext(true)
    }
    
    func stopLoader(_: Any? = nil) {
        isLoaderShowing.onNext(false)
    }
}
