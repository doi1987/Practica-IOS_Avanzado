//
//  ApiProviderMock.swift
//  Practica_IOS_AvanzadoTests
//
//  Created by David Ortega Iglesias on 15/5/24.
//

import Foundation
@testable import Practica_IOS_Avanzado

class ApiProviderMock: ApiProviderProtocol {
	var loginCompletion: Result<String,
								NetworkError> = .success("token")
	
	var heroesCompletion: Result<[HeroModel],
								 NetworkError> = .success([HeroModel(id: "1",
																				  name: "Diego",
																				  description: "Superman",
																				  photo: "",
																				  favorite: true)])
	
	var locationsCompletion: Result<[Location],
									NetworkError> = .success([Location(id: "B93A51C8-C92C-44A",
																				   latitude: "35.71867899343361",
																				   longitude: "139.8202084625344",
																				   date: "2022-02-20T00:00:00Z",
																				   hero: .init(id: "id"))])
	
	var transformationsCompletion: Result<[TransformationModel],
										  NetworkError> = .success([TransformationModel(id: "id",
																						name: "Kaioken",
																						description: "des",
																						photo: nil)])
	
	func loginWith(email: String, password: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
		completion(loginCompletion)
	}
	
	func getHeroesWith(name: String?, completion: @escaping (Result<[HeroModel], NetworkError>) -> Void) {
		completion(heroesCompletion)
	}
	
	func getLocationsForHeroWith(id: String, completion: @escaping (Result<[Location], NetworkError>) -> Void) {
		completion(locationsCompletion)
	}
	
	func getTransformationsForHeroWith(id: String, completion: @escaping (Result<[TransformationModel], NetworkError>) -> Void) {
		completion(transformationsCompletion)
	}
}
