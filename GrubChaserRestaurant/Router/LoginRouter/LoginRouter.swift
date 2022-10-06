//
//  LoginRouter.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 04/10/22.
//

import UIKit

class LoginRouter: LoginRouterProtocol {
    private let window: UIWindow?,
                loginStoryboard = UIStoryboard(name: "Login",
                                               bundle: nil),
                mainStoryboard = UIStoryboard(name: "Main",
                                              bundle: nil)
    
    private var navigationController: UINavigationController!
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        goToLogin()
    }
    
    func goToLogin() {
        let vc = loginStoryboard.instantiateViewController(withIdentifier: "loginVC") as! GBRLoginViewController
        vc.viewModel = GBRLoginViewModel(router: self,
                                         viewControllerRef: vc)
        setupNavigationController(vc)
        window?.rootViewController = navigationController
    }
    
    func goToMainFlow() {
        let tabBar = mainStoryboard.instantiateViewController(withIdentifier: "mainTabBarVC")
        window?.rootViewController = tabBar
    }
    
    private func setupNavigationController(_ vc: UIViewController) {
        navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = ColorPallete.defaultRed
    }
}
