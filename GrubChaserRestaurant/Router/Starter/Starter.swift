//
//  Starter.swift
//  GrubChaserRestaurant
//
//  Created by Douglas Immig on 04/10/22.
//

import UIKit

class Starter {
    static func startFlow(window: UIWindow?) {
        let loginRouter = LoginRouter(window: window)
        
        if (UserDefaults.standard.object(forKey: UserDefaultsKeys.loggedRestaurant.rawValue) != nil) {
            loginRouter.goToMainFlow()
        } else {
            loginRouter.start()
        }
    }
}
