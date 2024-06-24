//
//  AppDelegate.swift
//  Practica_IOS_AvanzadoTests
//
//  Created by David Ortega Iglesias on 15/5/24.
//

import XCTest
@testable import Practica_IOS_Avanzado

final class StoreDataProviderTests: XCTestCase {
	
	var sut: StoreDataProvider!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = StoreDataProvider(storeType: .inMemory)
	}
	
	override func tearDownWithError() throws {
		sut = nil
		try super.tearDownWithError()
	}
	
	func testGivenHeroWhenInsertHeroThenMatch() {
		let hero = HeroModel(id: "id", 
							 name: "name", 
							 description: "description", 
							 photo: "photo", 
							 favorite: true)
		
		let initialHeroes = sut.countHeroes()
		XCTAssertEqual(initialHeroes, 0)
		
		sut.insert(heroes: [hero])
		
		let expectedHeroes = sut.countHeroes()
		XCTAssertEqual(expectedHeroes, 1)
	}
   
    func testGivenLocationWhenInsertLocationThenMatch() {
        let initialCount = sut.fetchLocation().count
        XCTAssertEqual(initialCount, 0)
        
		let heroId: Location.HeroId = Location.HeroId(id: "id")
 
		sut.insert(locations: [Location(id: "id", 
										latitude: "latitude", 
										longitude: "longitude", 
										date: "date", 
										hero: heroId)])

        let finalCount = sut.fetchLocation().count
        XCTAssertEqual(finalCount, 1)
    }
	
	func testGivenTransformationWhenInsertTransformationThenMatch() {
		var count = sut.fetchTransformation().count
		XCTAssertEqual(count, 0)
		
		sut.insert(transformations: [TransformationModel(id: "id", 
														 name: "name", 
														 description: "description", 
														 photo: "photo")])
		
		count = sut.fetchTransformation().count
		XCTAssertEqual(count, 1)
	}
   
    func testGivenNoHerosWhenInsertThenCountHerosAndMatch() {

        var count = sut.countHeroes()
        XCTAssertEqual(count, 0)
        
        sut.insert(heroes: [HeroModel(id: "id", 
									  name: "name", 
									  description: "description", 
									  photo: "photo", 
									  favorite: true)])
        let heroes = sut.fetchHeroes().count

        count = sut.countHeroes()
        XCTAssertEqual(count, 1)
    }
    
    func testGivenHeroTransformationAndLocationWhenClearBBDDThenMatch() {
		let heroId: Location.HeroId = Location.HeroId(id: "id")
        sut.insert(heroes: [HeroModel(id: "id", 
									  name: "name", 
									  description: "description", 
									  photo: "photo", 
									  favorite: true)])
        sut.insert(transformations: [TransformationModel(id: "id", 
														 name: "name", 
														 description: "description", 
														 photo: "photo")])
        sut.insert(locations: [Location(id: "id", 
										latitude: "latitude", 
										longitude: "longitude", 
										date: "date", 
										hero: heroId)])
        
        var countHeroes = sut.countHeroes()
        XCTAssertEqual(countHeroes, 1)
		var countTransformations = sut.fetchTransformation().count
        XCTAssertEqual(countTransformations, 1)
        var countLocations = sut.fetchLocation().count
        XCTAssertEqual(countLocations, 1)

        sut.clearBBDD()
        
        countHeroes = sut.countHeroes()
        XCTAssertEqual(countHeroes, 0)
        countTransformations = sut.fetchTransformation().count
        XCTAssertEqual(countTransformations, 0)
        countLocations = sut.fetchLocation().count
        XCTAssertEqual(countLocations, 0)
        
    }
}
