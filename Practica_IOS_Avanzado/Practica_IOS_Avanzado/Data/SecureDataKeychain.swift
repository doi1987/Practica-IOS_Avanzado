//
//  SecureDataKeychain.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import Foundation
import KeychainSwift


protocol SecureDataProtocol {
	func setToken(value: String)
	func getToken() -> String?
	func deleteToken()
}

final class SecureDataKeychain: SecureDataProtocol {
	private let keychain = KeychainSwift()
	private let keyToken = "keyToken"
	
	func setToken(value: String) {
		keychain.set(value, forKey: keyToken)
	}
	
	func getToken() -> String? {
		keychain.get(keyToken)
	}
	
	func deleteToken() {
		keychain.delete(keyToken)
	}
}

// Implementación del SEcureDataProtocol con Userdefaults
// Se puede usar para Testing por ejemplo
final class SecureDataUserDefaults: SecureDataProtocol {
	
	private let userDefaults = UserDefaults.standard
	private let keyToken = "keyToken"
	
	func setToken(value: String) {
		userDefaults.setValue(value, forKey: keyToken)
	}
	
	func getToken() -> String? {
		userDefaults.value(forKey: keyToken) as? String
	}
	
	func deleteToken() {
		userDefaults.removeObject(forKey: keyToken)
	}
}
