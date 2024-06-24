//
//  TransformationTableUseCase.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 26/1/24.
//

import Foundation

protocol TransformationTableUseCaseProtocol {
	func getTransformations(heroId: String, onSuccess: @escaping ([TransformationModel]) -> Void, onError: @escaping (NetworkError) -> Void)
}

final class TransformationTableUseCase: TransformationTableUseCaseProtocol {
	private let apiProvider: ApiProviderProtocol
	private let storeDataProvider: StoreDataProviderProtocol
	
	init(apiProvider: ApiProviderProtocol = ApiProvider(), storeDataProvider: StoreDataProviderProtocol = StoreDataProvider()) {
		self.apiProvider = apiProvider
		self.storeDataProvider = storeDataProvider
	}
	
	func getTransformations(heroId: String, onSuccess: @escaping ([TransformationModel]) -> Void, onError: @escaping (NetworkError) -> Void) {		
		let transformationDAO = storeDataProvider.fetchTransformation()
		if !transformationDAO.isEmpty {
			let transformations = transformationDAO.map { transformation in
				TransformationModel(id: transformation.id, name: transformation.name, description: transformation.transformationDescription, photo: transformation.photo)
			}
			onSuccess(transformations)
		} else {
			apiProvider.getTransformationsForHeroWith(id: heroId, completion: { completion in
				switch completion {
				case .success(let transformations):
					onSuccess(transformations)
				case .failure(let error):
					onError(error)
				}
			})
		}
	}
}

// MARK: - Fake Succes
final class TransformationTableUseCaseFakeSuccess: TransformationTableUseCaseProtocol {	
	func getTransformations(heroId: String, onSuccess: @escaping ([TransformationModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		let transformation = [TransformationModel(id: heroId, name: "Kaioken", description: "des", photo: nil)]
		onSuccess(transformation)
		
	}
}

// MARK: - Fake Error

final class TransformationTableUseCaseFakeError: TransformationTableUseCaseProtocol {
	func getTransformations(heroId: String, onSuccess: @escaping ([TransformationModel]) -> Void, onError: @escaping (NetworkError) -> Void)  {
		onError(.other)
	}
}
