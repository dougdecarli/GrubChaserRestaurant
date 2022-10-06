//
//  UserDefaultsExtensions.swift
//  GrubChaser
//
//  Created by Douglas Immig on 10/09/22.
//

import Foundation

enum UserDefaultsKeys: String {
    case loggedRestaurant
}

extension UserDefaults {
    func saveLoggedUser(_ userModel: GBRRestaurantModel) {
        if let userEncoded = try? JSONEncoder().encode(userModel) {
            UserDefaults.standard.set(userEncoded,
                                      forKey: UserDefaultsKeys.loggedRestaurant.rawValue)
        }
    }
    
    func getLoggedUser() -> GBRRestaurantModel? {
        let userData = UserDefaults.standard.object(forKey: UserDefaultsKeys.loggedRestaurant.rawValue)
        guard let data = userData as? Data else {
            return nil
        }
        let userModel = try? JSONDecoder().decode(GBRRestaurantModel.self, from: data)
        return userModel
    }
    
    func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
