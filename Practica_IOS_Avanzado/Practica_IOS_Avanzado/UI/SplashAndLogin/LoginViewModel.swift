//
//  LoginViewModel.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import Foundation

//indica al controller el estado
enum LoginState {
	case loading
	case success
	case failed
}


final class LoginViewModel {
	
	private let apiProvider: ApiProvider
	
	var loginStateChanged: ((LoginState) -> Void)?
	
	init(apiProvider: ApiProvider = ApiProvider()) {
		self.apiProvider = apiProvider
	}
	
	func loginWith(email: String, password: String) {
		self.loginStateChanged?(.loading)
		apiProvider.loginWith(email: email, password: password) { [weak self] result in
			switch result {
			case .success(_):
				DispatchQueue.main.async {
					self?.loginStateChanged?(.success)
				}
			case .failure(let error):
				self?.loginStateChanged?(.failed)
				debugPrint(error.localizedDescription)
			}
		}
	}
}
