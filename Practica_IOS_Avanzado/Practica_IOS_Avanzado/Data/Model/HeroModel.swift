//
//  HeroModel.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 23/1/24.
//

import Foundation

struct HeroModel: Decodable, Hashable {
	let id: String
	let name: String
	let description: String
	let photo: String?
	let favorite: Bool
}

extension HeroModel: Comparable {
	static func < (lhs: HeroModel, rhs: HeroModel) -> Bool {
		lhs.name < rhs.name
	}
}
