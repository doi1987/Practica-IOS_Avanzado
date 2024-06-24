//
//  HeroAnnotation.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 27/2/24.
//

import Foundation
import MapKit


//LAs annotation deben implemntar el protocol MKAnnotation y heredar de NSOBject
//Tien una propiedad obligatoria coordinate que las coordenada, además tiene 2 propiedades opcionales
//title  y subtitle que se mostraran en el callout de la MAkAnnotationView si creamos una
//Por otro lado podemos añadir nuestras propiedades las que nos hagan falta para identificar
// la annotation pulsada en el evento del delegate de MKMapview
class HeroAnnotation: NSObject, MKAnnotation {
	var coordinate: CLLocationCoordinate2D
	var title: String?
	var id: String?
	var subtitle: String?
	
	init(coordinate: CLLocationCoordinate2D, title: String? = nil, id: String? = nil, subtitle: String? = nil) {
		self.coordinate = coordinate
		self.title = title
		self.id = id
		self.subtitle = subtitle
	}
}
