//
//  TransformationCollectionViewCell.swift
//  Practica_IOS_AvanzadoTests
//
//  Created by David Ortega Iglesias on 15/5/24.
//

import XCTest
@testable import Practica_IOS_Avanzado

final class HomeViewModelTests: XCTestCase {
	private var sut: HomeViewModel!
	private var heroUseCase: HeroesUseCaseProtocol!
	private var secureDataProviderMock: SecureDataProtocol = SecureDataProviderMock()
	private var storeDataProvider: StoreDataProviderProtocol!

    override func setUpWithError() throws {
		try super.setUpWithError()
		storeDataProvider = StoreDataProvider(storeType: .inMemory)
		sut = HomeViewModel(heroUseCase: HeroesUseCaseFakeSuccess(),
							storeDataProvider: storeDataProvider,
							secureDataKeychain: secureDataProviderMock)
		
    }

    override func tearDownWithError() throws {
		sut = nil
		storeDataProvider = nil
		heroUseCase = nil
		try super.tearDownWithError()
    }
    
    func testGivenLoadHeroesWhenGetThenMatch() throws {
		createWithHomeUseCaseFakeSuccess()
		let expectation = XCTestExpectation(description: "Heroes loaded")
		expectation.expectedFulfillmentCount = 2
		
		var output: StatusLoad?
		sut.homeStatusLoad = { state in
			output = state
			expectation.fulfill()
		}
        
		sut.loadHeroes()

        wait(for: [expectation], timeout: 0.1)
		
		let expectedHero: HeroModel =  HeroModel(id: "2",
												 name: "Alejandro",
												 description: "Spiderman",
												 photo: "",
												 favorite: false)
		
		let outputResult: StatusLoad = try XCTUnwrap(output)
		let heroResult: HeroModel = try XCTUnwrap(sut.dataHeroes.first)
		
		XCTAssertEqual(outputResult, .loaded)
		XCTAssertEqual(heroResult, expectedHero)
    }
	
	func testGivenLoadHeroesWhenGetThenMatchError() throws {
		createWithHomeUseCaseFakeError()
		let expectation = XCTestExpectation(description: "Heroes loaded")
		expectation.expectedFulfillmentCount = 2
		
		var output: StatusLoad?
		sut.homeStatusLoad = { state in
			output = state
			expectation.fulfill()
		}
		
		sut.loadHeroes()

		wait(for: [expectation], timeout: 0.1)
		
		let outputResult: StatusLoad = try XCTUnwrap(output)
		
		XCTAssertEqual(outputResult, .error(error: .noData))
	}
	
    
    func testGivenTokenAndHeroesInDBWhenLogoutThenMatch() {
		let expectedToken = "expectedToken"
		let heroes = [HeroModel(id: "1", name: "Diego", description: "Superman", photo: "", favorite: true) ,
					  HeroModel(id: "2", name: "Alejandro", description: "Spiderman", photo: "", favorite: false),
					  HeroModel(id: "3", name: "Rocio", description: "Super Woman", photo: "", favorite: true)]
		
		secureDataProviderMock.setToken(value: expectedToken)
		storeDataProvider.insert(heroes: heroes)
        XCTAssertEqual(secureDataProviderMock.getToken(), expectedToken)
		XCTAssertGreaterThan(storeDataProvider.countHeroes(), 0)
        
		sut.logout()
        
        XCTAssertNil(secureDataProviderMock.getToken())
		XCTAssertEqual(storeDataProvider.countHeroes(), 0)
    }

}

private extension HomeViewModelTests {
	func createWithHomeUseCaseFakeError() {
		heroUseCase = HeroesUseCaseFakeError()
		sut = HomeViewModel(heroUseCase: heroUseCase, 
							storeDataProvider: storeDataProvider, 
							secureDataKeychain: secureDataProviderMock)
	}
	
	func createWithHomeUseCaseFakeSuccess() {
		heroUseCase = HeroesUseCaseFakeSuccess()
		sut = HomeViewModel(heroUseCase: heroUseCase, 
							storeDataProvider: storeDataProvider, 
							secureDataKeychain: secureDataProviderMock)
	}
}
