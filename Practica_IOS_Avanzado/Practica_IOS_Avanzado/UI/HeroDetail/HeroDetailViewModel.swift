//
//  HeroDetailViewModel.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import Foundation

enum DetailHeroState {
	case updated
}

final class DetailHeroViewModel {
	
	private let apiProvider: ApiProvider
	private let hero: Hero
	
	private var locations: [Location] = []
	
	var stateChanged: ((DetailHeroState) -> Void)?
	
	init(apiProvider: ApiProvider = ApiProvider(), hero: Hero) {
		self.apiProvider = apiProvider
		self.hero = hero
	}
	
	deinit {
		debugPrint("Hero detail liberado")
	}
	
	
	func loadData() {
		
		guard let id = hero.id else { return }
		
		var gafError: KCDragonBallError?
		let group = DispatchGroup()
		
		group.enter()
		loadLocationsForHeroWith(id: id) { error in
			if let error {
				gafError = error
			}
			group.leave()
		}
		
		
		//TODO: - Pedir Transformacions y guardarlas en BBDD
		
		group.notify(queue: .main) {
			if let gafError {
				// TODO: - Manage Error
				return
			}
			self.updatedData()
		}
	}
	
	private func loadLocationsForHeroWith(id: String, completion: @escaping (KCDragonBallError?) -> Void) {
		
		apiProvider.getLocationsForHeroWith(id: id) { [weak self] result in
			switch result {
			case .success(let locations):
				DispatchQueue.main.async {
					self?.locations = locations
					//TODO: - Añadir localizaciones a BBDD
					completion(nil)
				}
			case .failure(let error):
				completion(error)
			}
		}
	}
	
	private func updatedData() {
		self.stateChanged?(.updated)
	}
	
	func heroNameAndId() -> (String?, String?) {
		return (hero.name, hero.id)
	}
	
	func getTitle() -> String {
		return hero.name ?? "No name"
	}
	
	func locationsHero() -> [Location] {
		return self.locations
	}
}
