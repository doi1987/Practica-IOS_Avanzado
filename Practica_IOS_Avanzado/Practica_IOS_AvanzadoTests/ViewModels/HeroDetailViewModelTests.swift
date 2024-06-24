//
//  TransformationCollectionViewCell.swift
//  Practica_IOS_AvanzadoTests
//
//  Created by David Ortega Iglesias on 15/5/24.
//

import XCTest
@testable import Practica_IOS_Avanzado

final class HeroDetailViewModelTests: XCTestCase {

    private var sut: HeroDetailViewModel!
	private let hero: HeroModel = HeroModel(id: "1",
											name: "Diego",
											description: "Superman",
											photo: "",
											favorite: true) 

    override func setUpWithError() throws {
		try super.setUpWithError()
		sut = .init(hero: hero,
					transformationsUseCase: TransformationTableUseCaseFakeSuccess(),
					locationUseCase: LocationUseCaseFakeSuccess())
    }

    override func tearDownWithError() throws {
        sut = nil
		try super.tearDownWithError()
    }
	
	func testGivenAnInitialHeroWhenGetHeroTheMatch() throws {
		let output = sut.getHero()
		XCTAssertEqual(output, hero)
		let name = try XCTUnwrap(sut.heroNameAndId().name)
		let id = try XCTUnwrap(sut.heroNameAndId().id)
		
		XCTAssertEqual(name, hero.name)
		XCTAssertEqual(id, hero.id)
	}
    
    func testGivenWhenLoadDataThenMatchSuccess() throws {        
		let expectation = XCTestExpectation(description: "Load detail")
		expectation.expectedFulfillmentCount = 2
		
		var output: HeroDetailStatusLoad?
		sut.heroDetailStatusLoad = { state in
			output = state
			expectation.fulfill()
		}
		
		sut.loadDetail()
		
		wait(for: [expectation], timeout: 0.1)
		let outputResult = try XCTUnwrap(output)
		XCTAssertEqual(outputResult, .loaded)

		let expectedTransformations = [TransformationModel(id: hero.id,
														   name: "Kaioken",
														   description: "des",
														   photo: nil)]
		let outputTransformations = sut.getTransformations()
		XCTAssertEqual(outputTransformations, expectedTransformations)
		
		let expectedLocations = [Location(id: "B93A51C8-C92C-44AE-B1D1-9AFE9BA0BCCC", 
										  latitude: "35.71867899343361", 
										  longitude: "139.8202084625344", 
										  date: "2022-02-20T00:00:00Z", 
										  hero: .init(id: hero.id))]
		
		let outputLocations = sut.locationsHero()
		XCTAssertEqual(outputLocations, expectedLocations)
		
    }
	
	func testGivenWhenLoadDataThenMatchError() throws {
		sut = HeroDetailViewModel(hero: hero, 
								  transformationsUseCase: TransformationTableUseCaseFakeError(),
								  locationUseCase: LocationUseCaseFakeError())
		
		let expectation = XCTestExpectation(description: "Load detail")
		expectation.expectedFulfillmentCount = 2
		
		var output: HeroDetailStatusLoad?
		sut.heroDetailStatusLoad = { state in
			output = state
			expectation.fulfill()
		}
		
		sut.loadDetail()
		
		wait(for: [expectation], timeout: 0.1)
		let outputResult = try XCTUnwrap(output)
		XCTAssertEqual(outputResult, .error(error: .other))
	}
}
