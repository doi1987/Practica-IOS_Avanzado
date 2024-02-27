//
//  Transformation.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import Foundation

struct Transformation: Decodable {
	let id: String?
	let name: String?
	let description: String?
	let photo: String?
	let hero: Hero?
}
