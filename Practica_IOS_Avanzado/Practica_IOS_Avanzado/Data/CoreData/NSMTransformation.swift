//
//  NSMTransformation+CoreDataClass.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 1/3/24.
//
//

import Foundation
import CoreData

@objc(NSMTransformation)
public class NSMTransformation: NSManagedObject {

}

extension NSMTransformation {

	@nonobjc public class func fetchRequest() -> NSFetchRequest<NSMTransformation> {
		return NSFetchRequest<NSMTransformation>(entityName: "Transformation")
	}

	@NSManaged public var id: String?
	@NSManaged public var name: String?
	@NSManaged public var transformationDescription: String?
	@NSManaged public var photo: String?
	@NSManaged public var hero: NSMHero?

}

extension NSMTransformation : Identifiable {

}
