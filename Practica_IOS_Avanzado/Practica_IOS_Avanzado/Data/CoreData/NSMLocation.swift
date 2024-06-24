//
//  NSMLocation+CoreDataClass.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 1/3/24.
//
//

import Foundation
import CoreData

@objc(NSMLocation)
public class NSMLocation: NSManagedObject {

}

extension NSMLocation {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<NSMLocation> {
		return NSFetchRequest<NSMLocation>(entityName: "Location")
	}

	@NSManaged public var id: String
	@NSManaged public var latitude: String?
	@NSManaged public var longitude: String?
	@NSManaged public var date: String?
	@NSManaged public var hero: NSMHero?

}

extension NSMLocation: Identifiable {

}
