//
//  TransformationModel.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 24/1/24.
//

import Foundation

struct TransformationModel: Decodable, Hashable {
	let id: String
	let name: String
	let description: String
	let photo: String?
}

extension TransformationModel: Comparable {
	static func < (lhs: TransformationModel, rhs: TransformationModel) -> Bool {
		guard let lhsNumber = lhs.name.getTransformationNumber(),
			  let rhsNumber = rhs.name.getTransformationNumber() else {
			return lhs.name < rhs.name
		}

		return lhsNumber < rhsNumber
	}
}
