//
//  NSMHero+CoreDataClass.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 1/3/24.
//
//

import Foundation
import CoreData

@objc(NSMHero)
public class NSMHero: NSManagedObject {

}

extension NSMHero {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<NSMHero> {
		return NSFetchRequest<NSMHero>(entityName: "Hero")
	}

	@NSManaged public var id: String?
	@NSManaged public var name: String?
	@NSManaged public var heroDescription: String?
	@NSManaged public var photo: String?
	@NSManaged public var favorite: Bool
	@NSManaged public var transformations: Set<NSMTransformation>?
	@NSManaged public var locations: Set<NSMLocation>?

}

// MARK: Generated accessors for transformations
extension NSMHero {

	@objc(addTransformationsObject:)
	@NSManaged public func addToTransformations(_ value: NSMTransformation)

	@objc(removeTransformationsObject:)
	@NSManaged public func removeFromTransformations(_ value: NSMTransformation)

	@objc(addTransformations:)
	@NSManaged public func addToTransformations(_ values: NSSet)

	@objc(removeTransformations:)
	@NSManaged public func removeFromTransformations(_ values: NSSet)

}

// MARK: Generated accessors for locations
extension NSMHero {

	@objc(addLocationsObject:)
	@NSManaged public func addToLocations(_ value: NSMLocation)

	@objc(removeLocationsObject:)
	@NSManaged public func removeFromLocations(_ value: NSMLocation)

	@objc(addLocations:)
	@NSManaged public func addToLocations(_ values: NSSet)

	@objc(removeLocations:)
	@NSManaged public func removeFromLocations(_ values: NSSet)

}

extension NSMHero : Identifiable {

}
