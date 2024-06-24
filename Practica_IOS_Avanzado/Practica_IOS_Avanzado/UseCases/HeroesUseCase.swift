//
//  HomeUseCase.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 23/1/24.
//

import Foundation

	// MARK: - Protocolo Home
protocol HeroesUseCaseProtocol {
	func getHeroes(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void)
}
	
	// MARK: - CLase homeUseCase
final class HeroesUseCase: HeroesUseCaseProtocol {
	private let apiProvider: ApiProviderProtocol
	private let storeDataProvider: StoreDataProviderProtocol
	
	init(apiProvider: ApiProviderProtocol = ApiProvider(),
		 storeDataProvider: StoreDataProviderProtocol = StoreDataProvider()) {
		self.apiProvider = apiProvider
		self.storeDataProvider = storeDataProvider
	}
	
	func getHeroes(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		if storeDataProvider.countHeroes() > 0 {
			let heroesDAO = storeDataProvider.fetchHeroes(filter: nil, sorting: nil)
			let heroes = heroesDAO.map({
				HeroModel(id: $0.id,
						  name: $0.name,
						  description: $0.heroDescription,
						  photo: $0.photo,
						  favorite: $0.favorite) })
			onSuccess(heroes)
		} else {
			apiProvider.getHeroesWith(name: "", completion: { [weak self] completion in
				switch completion {
				case .success(let heroes):
					self?.storeDataProvider.insert(heroes: heroes)
					onSuccess(heroes)
				case .failure(let error):
					onError(error)
				}
			})
		}
	}
}

// MARK: - Fake Succes
final class HeroesUseCaseFakeSuccess: HeroesUseCaseProtocol {
	func getHeroes(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		let heroes = [HeroModel(id: "1", name: "Diego", description: "Superman", photo: "", favorite: true) ,
					  HeroModel(id: "2", name: "Alejandro", description: "Spiderman", photo: "", favorite: false),
					  HeroModel(id: "3", name: "Rocio", description: "Super Woman", photo: "", favorite: true)]
		onSuccess(heroes)
	}
}

// MARK: - Fake Error

final class HeroesUseCaseFakeError: HeroesUseCaseProtocol {
	func getHeroes(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		onError(.noData)
		
	}
}
