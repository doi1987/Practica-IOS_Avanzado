//
//  Hero.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import Foundation

struct Hero: Decodable {
	let id: String?
	let name: String?
	let description: String?
	let photo: String?
	let favorite: Bool?
}
