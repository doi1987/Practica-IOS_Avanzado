//
//  StoreDataProvider.swift
//  Practica_IOS_Avanzado
//
//  Created by David Ortega Iglesias on 2/3/24.
//

import Foundation
import CoreData

enum StoreType {
	
	case disk
	case inMemory
}

class StoreDataProvider {
	
	private static var managedObjectModel: NSManagedObjectModel = {
		let bundle = Bundle(for: StoreDataProvider.self)
		guard  let url = bundle.url(forResource: "Model", withExtension: "momd"),
			   let mom = NSManagedObjectModel(contentsOf: url) else {
			fatalError(" Error loading model file")
		}
		return mom
	}()
	
	private let persistentContainer: NSPersistentContainer!
	
	lazy var context: NSManagedObjectContext = {
		var viewContext = persistentContainer.viewContext
		viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
		return viewContext
	}()
	
	init(storeType: StoreType = .disk) {
		self.persistentContainer = NSPersistentContainer(name: "Model", managedObjectModel: Self.managedObjectModel)
		if  storeType == .inMemory {
			// Para persistir en memoria la BBDD debemos asignar la URL /dev/null al store Description
			// Para testing es necesario que la base de datos esté en memoria
			if let store = self.persistentContainer.persistentStoreDescriptions.first {
				store.url = URL(filePath: "dev/null")
			} else {
				fatalError(" Error loading persistent Store Description")
			}
		}
		self.persistentContainer.loadPersistentStores { _, error in
			if let error {
				fatalError("Error creating BBDD \(error)")
			}
		}
	}
	
	func saveContext() {
		if context.hasChanges {
			do {
			   try context.save()
			} catch {
				context.rollback()
				debugPrint("Error saving changes in BBDD")
			}
		}
	}
}

extension StoreDataProvider {
	func insert(heroes: [Hero]) {
		for hero in heroes {
			let newHero = NSMHero(context: context)
			newHero.id = hero.id
			newHero.name = hero.name
			newHero.heroDescription = hero.description
			newHero.photo = hero.photo
			newHero.favorite = hero.favorite ?? false
		}
		saveContext()
	}
	
	func fetchHeroes(filter: NSPredicate? = nil, sorting:[NSSortDescriptor]? = nil) -> [NSMHero] {
		let request = NSMHero.fetchRequest()
		request.predicate = filter
		if sorting == nil {
			let sort = NSSortDescriptor(key: "name", ascending: true)
			request.sortDescriptors = [sort]
		} else {
			request.sortDescriptors = sorting
		}
		do {
			return try context.fetch(request)
		} catch {
			return []
		}
	}
	
	func countHeroes() -> Int {
		let request = NSMHero.fetchRequest()
		do {
			return try context.count(for: request)
		} catch {
			return 0
		}
	}
	
	func insert(transformations: [Transformation]){
		for transformation in transformations {
			let newTransformation = NSMTransformation(context: context)
			newTransformation.id = transformation.id
			newTransformation.name = transformation.name
			newTransformation.transformationDescription = transformation.description
			newTransformation.photo = transformation.photo
			let filter = NSPredicate(format: "id == %@", transformation.hero?.id ?? "")
			let hero = fetchHeroes(filter: filter).first
			newTransformation.hero = hero
		}
		saveContext()
	}
	
	func fetchTransformation() -> [NSMTransformation] {
		let request = NSMTransformation.fetchRequest()
		do {
			return try context.fetch(request)
		} catch {
			return []
		}
	}
	
	func insert(locations: [Location]) {
		for location in locations {
			let newLocation = NSMLocation(context: context)
			newLocation.id = location.id
			newLocation.latitude = location.latitude
			newLocation.longitude = location.longitude
			newLocation.date = location.date
			let filter = NSPredicate(format: "id == %@", location.hero?.id ?? "")
			let hero = fetchHeroes(filter: filter).first
			newLocation.hero = hero
		}
		saveContext()
	}
	
	func fetchLocation() -> [NSMLocation] {
		let request = NSMLocation.fetchRequest()
		do {
			return try context.fetch(request)
		} catch {
			return []
		}
	}
	
	func clearBBDD() {
		let deleteHeroes = NSBatchDeleteRequest(fetchRequest: NSMHero.fetchRequest())
		let deleteTransformations = NSBatchDeleteRequest(fetchRequest: NSMTransformation.fetchRequest())
		let deleteLocations = NSBatchDeleteRequest(fetchRequest: NSMLocation.fetchRequest())
		context.reset()
		
		for task in [deleteHeroes, deleteTransformations, deleteLocations] {
			do {
			   try  context.execute(task)
			} catch {
				debugPrint("Error clearing BBDD")
			}
		}
	}
}
