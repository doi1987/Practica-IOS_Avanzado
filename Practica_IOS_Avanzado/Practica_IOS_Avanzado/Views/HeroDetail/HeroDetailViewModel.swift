//
//  HeroDetailViewModel.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 24/1/24.
//

import Foundation

final class HeroDetailViewModel {
	// Binding con UI
	var heroDetailStatusLoad: ((HeroDetailStatusLoad) -> Void)?
	
	// Use Case
	private let transformationsUseCase: TransformationTableUseCaseProtocol
	private let locationUseCase: LocationUseCaseProtocol
	
	private var hero: HeroModel
	private var dataTransformations: [TransformationModel] = .init()
	private var locations: [Location] = []
	private let group: DispatchGroup = .init()
	private var error: NetworkError?
	
	// Init
	init(hero: HeroModel, transformationsUseCase: TransformationTableUseCaseProtocol = TransformationTableUseCase(), locationUseCase: LocationUseCaseProtocol = LocationUseCase()) {
		self.hero = hero
		self.transformationsUseCase = transformationsUseCase
		self.locationUseCase = locationUseCase
	}
	
	func loadDetail() {
		heroDetailStatusLoad?(.loading)
		loadTransformations(heroId: hero.id)
		loadLocations(heroId: hero.id)
		updateState()
	}
	
	func getHero() -> HeroModel? {
		hero
	}
	
	func getTransformations() -> [TransformationModel] {
		self.dataTransformations
	}
	
	func heroNameAndId() -> (name: String?, id: String?) {
		(hero.name, hero.id)
	}
	
	func locationsHero() -> [Location] {
		self.locations
	}
}

private extension HeroDetailViewModel {
	// LLamada a getTransformations
	func loadTransformations(heroId: String) {
		group.enter()
		transformationsUseCase.getTransformations(heroId: heroId) { [weak self] transformations in
			self?.dataTransformations = transformations.sorted()
			self?.group.leave()
		} onError: { [weak self] networkError in			
			self?.error = networkError
			self?.group.leave()
		}
	}
	
	func loadLocations(heroId: String) {
		group.enter()
		locationUseCase.getLocations(heroId: heroId) { [weak self] locations in
			self?.locations = locations
			self?.group.leave()
			
		} onError: { [weak self] networkError in
			self?.error = networkError
			self?.group.leave()
		}
	}
	
	func updateState() {
		group.notify(queue: .main) {
			DispatchQueue.main.async { [weak self] in
				guard let error = self?.error else { 
					self?.heroDetailStatusLoad?(.loaded)
					return
				}
				
				self?.heroDetailStatusLoad?(.error(error: error))
			}
		}
	}
}

enum HeroDetailStatusLoad: Equatable {
	case loading
	case loaded
	case error(error: NetworkError)
	case none
}
