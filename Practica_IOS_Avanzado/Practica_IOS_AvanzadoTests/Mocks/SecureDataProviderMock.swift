//
//  SecureDataProviderMock.swift
//  Practica_IOS_AvanzadoTests
//
//  Created by David Ortega Iglesias on 15/5/24.
//

import Foundation
@testable import Practica_IOS_Avanzado

struct SecureDataProviderMock: SecureDataProtocol {
	let userDefaults = UserDefaults.standard
	let token = "TOKEN"
    
    func setToken(value: String) {
        userDefaults.setValue(value, forKey: token)
    }
    
    func getToken() -> String? {
        userDefaults.value(forKey: token) as? String
    }
    
    func deleteToken() {
        userDefaults.removeObject(forKey: token)
    }
}
