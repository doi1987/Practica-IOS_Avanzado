//
//  TransformationTableUseCase.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 26/1/24.
//

import Foundation

protocol LocationUseCaseProtocol {
	func getLocations(heroId: String, onSuccess: @escaping ([Location]) -> Void, onError: @escaping (NetworkError) -> Void)
}

final class LocationUseCase: LocationUseCaseProtocol {
	private let apiProvider: ApiProviderProtocol
	private let storeDataProvider: StoreDataProviderProtocol
	
	init(apiProvider: ApiProviderProtocol = ApiProvider(), storeDataProvider: StoreDataProviderProtocol = StoreDataProvider()) {
		self.apiProvider = apiProvider
		self.storeDataProvider = storeDataProvider
	}
	
	func getLocations(heroId: String, onSuccess: @escaping ([Location]) -> Void, onError: @escaping (NetworkError) -> Void) {
		let locationsDAO = storeDataProvider.fetchLocation()
		if locationsDAO.isEmpty {
			apiProvider.getLocationsForHeroWith(id: heroId, completion: { completion in
				switch completion {
				case .success(let locations):
					onSuccess(locations)
				case .failure(let error):
					onError(error)
				}
			})
		} else {
			let locations = locationsDAO.map { location in
				Location(id: location.id, latitude: location.latitude, longitude: location.longitude, date: location.date, hero: Location.HeroId(id: heroId))
			}
			storeDataProvider.insert(locations: locations)
			onSuccess(locations)
		}
	}
}

// MARK: - Fake Success
final class LocationUseCaseFakeSuccess: LocationUseCaseProtocol {
	func getLocations(heroId: String, onSuccess: @escaping ([Location]) -> Void, onError: @escaping (NetworkError) -> Void) {
		let location = [Location(id: "B93A51C8-C92C-44AE-B1D1-9AFE9BA0BCCC", latitude: "35.71867899343361", longitude: "139.8202084625344", date: "2022-02-20T00:00:00Z", hero: .init(id: heroId))]
		onSuccess(location)
		
	}
}

// MARK: - Fake Error

final class LocationUseCaseFakeError: LocationUseCaseProtocol {
	func getLocations(heroId: String, onSuccess: @escaping ([Location]) -> Void, onError: @escaping (NetworkError) -> Void)  {
		onError(.other)
		
	}
}
