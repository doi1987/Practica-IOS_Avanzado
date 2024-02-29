//
//  LoginStatusLoad.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 29/2/24.
//

import Foundation

enum LoginStatusLoad {
	case loading 
	case loaded
	case showErrorEmail(_ error: String?)
	case showErrorPassword(_ error: String?)
	case errorNetwork(_ error: String)
}
