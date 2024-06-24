//
//  Location.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import Foundation

struct Location: Decodable, Equatable {
	let id: String
	let latitude: String?
	let longitude: String?
	let date: String?
	let hero: HeroId
	
	// Si las las claves del json no coinciden con las de las propiedades de nuestra clase/struct
	// Hay que incicar que clave  corresponde con nuestras propiedades, para ello usamos un enum
	//que implemente el protocol CondingKwy
	enum CodingKeys: String, CodingKey {
		case id
		case latitude = "latitud"
		case longitude = "longitud"
		case date = "dateShow"
		case hero
	}
	
	struct HeroId: Decodable, Equatable {
		let id: String
	}
}
