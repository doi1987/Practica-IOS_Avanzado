//
//  LoginViewModel.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import Foundation

final class LoginViewModel {
	
	private let apiProvider: ApiProvider
	
	var loginStateChanged: ((LoginStatusLoad) -> Void)?
	
	init(apiProvider: ApiProvider = ApiProvider()) {
		self.apiProvider = apiProvider
	}
	
	func loginWith(email: String, password: String) {
		self.loginStateChanged?(.loading)
		apiProvider.loginWith(email: email, password: password) { [weak self] result in
			switch result {
			case .success(_):
				DispatchQueue.main.async {
					self?.loginStateChanged?(.loaded)
				}
			case .failure(let error):
				var error = "Error"
				self?.loginStateChanged?(.errorNetwork(error))
			}
		}
	}
	
	// MARK: - Metodo login
	func onLoginButton(email: String?, password: String?) {
		loginStateChanged?(.loading)
		
		// Check del email y password
		guard let email = email, isValid(email: email) else {
			loginStateChanged?(.loading)
			loginStateChanged?(.showErrorEmail("Error en el email"))
			return
		}
		
		guard let password = password, isValid(password: password) else {
			loginStateChanged?(.loading)
			loginStateChanged?(.showErrorPassword("Error en el password"))
			return
		}
		
		loginWith(email: email, password: password)
	}
	
	// Check email
	func isValid(email: String) -> Bool {
		email.isEmpty == false && email.contains("@")
	}
	
	// Check password
	func isValid(password: String) -> Bool {
		password.isEmpty == false && password.count >= 4
	}
}
