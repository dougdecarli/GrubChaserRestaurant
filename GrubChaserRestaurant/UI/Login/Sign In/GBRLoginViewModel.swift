//
//  GBRLoginViewModel.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 04/10/22.
//

import RxSwift
import RxRelay
import RxCocoa
import FirebaseAuth
import FirebaseAuth
import UIKit
import NVActivityIndicatorView

class GBRLoginViewModel: GrubChaserBaseViewModel<LoginRouterProtocol> {
    private let firebaseAuth: Auth
    
    var emailValue = BehaviorRelay<String>(value: ""),
        passwordValue = BehaviorRelay<String>(value: ""),
        onLoginButtonTouched = PublishRelay<Void>(),
        showAlert = PublishSubject<ShowAlertModel>(),
        isLoaderShowing = PublishSubject<Bool>()
    
    var isLoginButtonEnabled: Observable<Bool> {
        setupIsLoginButtonEnabled()
    }
    
    var isEmailValid: Observable<Bool> {
        setupIsEmailValid()
    }
    
    var isPasswordValid: Observable<Bool> {
        setupIsPasswordValid()
    }
    
    init(router: LoginRouterProtocol,
         viewControllerRef: UIViewController,
         firebaseAuth: Auth = Auth.auth()) {
        self.firebaseAuth = firebaseAuth
        super.init(router: router,
                   viewControllerRef: viewControllerRef)
    }
    
    override func setupBindings() {
        setupOnLoginButtonTouched()
    }
    
    //MARK: Inputs
    private func setupOnLoginButtonTouched() {
        onLoginButtonTouched
            .withLatestFrom(Observable.combineLatest(emailValue, passwordValue))
            .flatMap(buildLoginModel)
            .do(onNext: startLoading)
            .subscribe(onNext: firebaseLogin)
            .disposed(by: disposeBag)
    }
    
    //MARK: Outputs
    private func setupIsLoginButtonEnabled() -> Observable<Bool> {
        Observable.combineLatest(isEmailValid,
                                 isPasswordValid)
        .map { $0 && $1 }
    }
    
    private func setupIsEmailValid() -> Observable<Bool> {
        emailValue
            .map { $0.contains("@") && $0.contains(".com") }
    }
    
    private func setupIsPasswordValid() -> Observable<Bool> {
        passwordValue
            .map { $0.count > 4 }
    }
    
    //MARK: - Firebase sign in
    private func firebaseLogin(_ loginModel: GBRLoginModel) {
        func handleSuccess(_ authResult: AuthDataResult) {
            getRestaurant(from: authResult.user.uid)
        }
        
        func handleError(_: Error) {
            stopLoading()
            showErrorOnLoginAlertView()
        }
        
        firebaseAuth.rx.signIn(withEmail: loginModel.email,
                              password: loginModel.password)
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    private func getRestaurant(from uid: String) {
        func handleSuccess(restaurant: GBRRestaurantModel) {
            stopLoading()
            saveRestaurantLogged(restaurant: restaurant)
            router.goToMainFlow()
        }
        
        func handleError(_: Error) {
            stopLoading()
            showErrorOnLoginAlertView()
        }
        
        service.getRestaurant(with: uid)
            .subscribe(onNext: handleSuccess,
                       onError: handleError)
            .disposed(by: disposeBag)
    }
    
    //MARK: Helper methods
    private func buildLoginModel(email: String,
                                 password: String) -> Observable<GBRLoginModel> {
        Observable.of(.init(email: email, password: password))
    }
    
    private func saveRestaurantLogged(restaurant: GBRRestaurantModel) {
        UserDefaults.standard.saveLoggedUser(restaurant)
    }
    
    private func startLoading(_: Any? = nil) {
        isLoaderShowing.onNext(true)
    }
    
    private func stopLoading(_: Any? = nil) {
        isLoaderShowing.onNext(false)
    }
    
    func showErrorOnLoginAlertView() {
        showAlert.onNext(.init(title: "Ocorreu um erro ao efetuar o seu login",
                               message: "Por favor, tente novamente",
                               viewControllerRef: viewControllerRef))
    }
}

extension GBRLoginViewModel: GrubChaserAlertableViewModel {}
extension GBRLoginViewModel: GrubChaserLoadableViewModel {}

