//
//  GBRLoginViewController.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 04/10/22.
//

import UIKit

class GBRLoginViewController: GrubChaserBaseViewController<GBRLoginViewModel> {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func bindInputs() {
        super.bindInputs()
        emailTextField.rx.text.orEmpty
            .startWith("")
            .bind(to: viewModel.emailValue)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .startWith("")
            .bind(to: viewModel.passwordValue)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModel.onLoginButtonTouched)
            .disposed(by: disposeBag)
    }
    
    override func bindOutputs() {
        super.bindOutputs()
        
        viewModel.isLoginButtonEnabled
            .asDriver(onErrorJustReturn: false)
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
 
