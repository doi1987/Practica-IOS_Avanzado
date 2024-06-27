//
//  AppDelegate.swift
//  Practica_IOS_AvanzadoTests
//
//  Created by David Ortega Iglesias on 15/5/24.


import XCTest
@testable import Practica_IOS_Avanzado

final class ApiProviderTests: XCTestCase {
	private let loginURL: URL = URL(string: "https://dragonball.keepcoding.education/api/auth/login")!
	private var sut: ApiProviderProtocol!
	private let token = "expectedToken"
	
	private var secureDataProviderMock: SecureDataProtocol = SecureDataProviderMock()
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		sut = initialize()
	}
	
	override func tearDownWithError() throws {
		sut = nil
		secureDataProviderMock.deleteToken()
		try super.tearDownWithError()
	}
	
	
	
	func testGivenEmailAndPasswordWhenLoginSuccessThenMatch() throws {
		let email = "email"
		let password = "password"
		let expectation = expectation(description: "Login success")

		MockURLProtocol.requestHandler = { request in
			let response = try XCTUnwrap(MockURLProtocol.urlResponseTest(url: self.loginURL, statusCode: 200))
			let data = try XCTUnwrap(self.token.data(using: .utf8))
			return (response, data)
		}
		
		var output: String?
		sut.loginWith(email: email, password: password) { result in
			switch result {
			case .success(let token):
				output = token
				expectation.fulfill()
			case .failure(_):
				XCTFail("This test expected a success")
			}
		}
		
		wait(for: [expectation], timeout: 0.1)
		

		let secureToken: String = try XCTUnwrap(secureDataProviderMock.getToken())
		let outputResult: String = try XCTUnwrap(output)
		XCTAssertEqual(outputResult, token)
		XCTAssertEqual(outputResult, secureToken)
	}
	
	func testGivenEmailAndPasswordWhenLoginFailThenMatch() throws {
		struct LoginError: Encodable {
			let reason: String
			let error: Bool
		}
		let email = "email"
		let password = "password"
		let expectation = expectation(description: "Login success")

		MockURLProtocol.requestHandler = { request in
			let data: Data = try XCTUnwrap(JSONEncoder().encode(LoginError(reason: "Ha habido un error", error: true)))
			let response = try XCTUnwrap(MockURLProtocol.urlResponseTest(url: self.loginURL, statusCode: 401))
			return (response, data)
		}
		
		var output: NetworkError?
		sut.loginWith(email: email, password: password) { result in
			switch result {
			case .success(_):
				XCTFail("This test expected a fail")
			case .failure(let error):
				output = error
				expectation.fulfill()
			}
		}
		
		wait(for: [expectation], timeout: 0.1)
		
		let outputResult: NetworkError = try XCTUnwrap(output)
		XCTAssertEqual(outputResult, .unauthorized)
	}
	
	
	
	func testGivenNoNameWhenGetHeroesThenSuccess() throws {
		let expectedHero = HeroModel(id: "14BB8E98-6586-4EA7-B4D7-35D6A63F5AA3",
									 name: "Maestro Roshi",
									 description: "Es un maestro de artes marciales que tiene una escuela, donde entrenará a Goku y Krilin para los Torneos de Artes Marciales. Aún en los primeros episodios había un toque de tradición y disciplina, muy bien representada por el maestro. Pero Muten Roshi es un anciano extremadamente pervertido con las chicas jóvenes, una actitud que se utilizaba en escenas divertidas en los años 80. En su faceta de experto en artes marciales, fue quien le enseñó a Goku técnicas como el Kame Hame Ha",
									 photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/Roshi.jpg?width=300",
									 favorite: true)
		
		secureDataProviderMock.setToken(value: self.token)
		
		MockURLProtocol.requestHandler = { request in			
			let url = URL(string: "https://dragonball.keepcoding.education/api/heros/all")!
			
			let path = Bundle(for: type(of: self)).path(forResource: "heroes", ofType: "json")!
			let data = try Data(contentsOf: URL(filePath: path))
			let response = MockURLProtocol.urlResponseTest(url: url, statusCode: 200)!
			return (response, data)
		}
		
		let expectation = expectation(description: "Load Heroes")
		var output: [HeroModel]?
		
		sut.getHeroesWith(name: nil) { result in			
			switch result {
			case .success(let heroes):
				output = heroes
				expectation.fulfill()
			case .failure(_):
				XCTFail("expected success")
			}
		}
		
		wait(for: [expectation], timeout: 0.1)
		
		let outputResult = try XCTUnwrap(output)
		XCTAssertEqual(outputResult.first, expectedHero)
	}
	
	
	func testGivenNoNameWhenGetHeroesThenFail() throws {
		secureDataProviderMock.setToken(value: self.token)

		MockURLProtocol.requestHandler = { request in
			let url = URL(string: "https://dragonball.keepcoding.education/api/heros/all")!
			let path = Bundle(for: type(of: self)).path(forResource: "heroes", ofType: "json")!
			let data = try! Data(contentsOf: URL(filePath: path))
			let response = MockURLProtocol.urlResponseTest(url: url, statusCode: 500)!
			return (response, data)
		}
		
		let expectation = expectation(description: "Load Heroes")
		var output: NetworkError?
		
		sut.getHeroesWith(name: nil) { result in
			switch result {
			case .success( _):
				XCTFail("expected failure")
			case .failure( let error):
				output = error
				expectation.fulfill()
			}
		}
		wait(for: [expectation], timeout: 0.1)
		
		let outputResult = try XCTUnwrap(output)
		XCTAssertEqual(outputResult, .serverError)
	}
	
	func testGivenHeroIdWhenGetLocationThenSuccess() throws {
		let id = "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"
		let heroId: Location.HeroId = Location.HeroId(id: id)
		let expectedLocation = Location(id: "B93A51C8-C92C-44AE-B1D1-9AFE9BA0BCCC", 
										latitude: "35.71867899343361", 
										longitude: "139.8202084625344", 
										date: "2022-02-20T00:00:00Z", 
										hero: heroId)
		
		secureDataProviderMock.setToken(value: self.token)
		
		MockURLProtocol.requestHandler = { request in			
			let url = URL(string: "https://dragonball.keepcoding.education/api/heros/locations")!
			
			let path = Bundle(for: type(of: self)).path(forResource: "locations", ofType: "json")!
			let data = try Data(contentsOf: URL(filePath: path))
			let response = MockURLProtocol.urlResponseTest(url: url, statusCode: 200)!
			return (response, data)
		}
		
		let expectation = expectation(description: "Load Locations")
		var output: [Location]?
		
		sut.getLocationsForHeroWith(id: id) { result in			
			switch result {
			case .success(let locations):
				output = locations
				expectation.fulfill()
			case .failure(_):
				XCTFail("This test expected a success")
			}
		}
		
		wait(for: [expectation], timeout: 0.1)
		
		let outputResult = try XCTUnwrap(output?.first)
		XCTAssertEqual(outputResult, expectedLocation)
	}
	
	func testGivenHeroIdWhenGetLocationThenFail() throws {
		let idHero = "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"
		secureDataProviderMock.setToken(value: self.token)

		MockURLProtocol.requestHandler = { request in
			let url = URL(string: "https://dragonball.keepcoding.education/api/heros/locations")!
			let path = Bundle(for: type(of: self)).path(forResource: "locations", ofType: "json")!
			let data = try! Data(contentsOf: URL(filePath: path))
			let response = MockURLProtocol.urlResponseTest(url: url, statusCode: 500)!
			return (response, data)
		}
		
		let expectation = expectation(description: "Load Locations")
		var output: NetworkError?
		
		sut.getLocationsForHeroWith(id: idHero) { result in
			switch result {
			case .success( _):
				XCTFail("This test expected a failure")
			case .failure( let error):
				output = error
				expectation.fulfill()
			}
		}
		wait(for: [expectation], timeout: 0.1)
		
		let outputResult = try XCTUnwrap(output)
		XCTAssertEqual(outputResult, .serverError)
	}
	
	func testGivenHeroIdWhenGetTransformationsThenSuccess() throws {
		let idHero = "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"
		let expectedTransformation = TransformationModel(id: "17824501-1106-4815-BC7A-BFDCCEE43CC9", 
														 name: "1. Oozaru – Gran Mono", 
														 description: "Cómo todos los Saiyans con cola, Goku es capaz de convertirse en un mono gigante si mira fijamente a la luna llena. Así es como Goku cuando era un infante liberaba todo su potencial a cambio de perder todo el raciocinio y transformarse en una auténtica bestia. Es por ello que sus amigos optan por cortarle la cola para que no ocurran desgracias, ya que Goku mató a su propio abuelo adoptivo Son Gohan estando en este estado. Después de beber el Agua Ultra Divina, Goku liberó todo su potencial sin necesidad de volver a convertirse en Oozaru", 
														 photo: "https://areajugones.sport.es/wp-content/uploads/2021/05/ozarru.jpg.webp")
		
		secureDataProviderMock.setToken(value: self.token)
		
		MockURLProtocol.requestHandler = { request in			
			let url = URL(string: "https://dragonball.keepcoding.education/api/heros/tranformations")!
			
			let path = Bundle(for: type(of: self)).path(forResource: "transformations", ofType: "json")!
			let data = try Data(contentsOf: URL(filePath: path))
			let response = MockURLProtocol.urlResponseTest(url: url, statusCode: 200)!
			return (response, data)
		}
		
		let expectation = expectation(description: "Load Transformations")
		var output: [TransformationModel]?
		
		sut.getTransformationsForHeroWith(id: idHero) { result in			
			switch result {
			case .success(let transformations):
				output = transformations
				expectation.fulfill()
			case .failure(_):
				XCTFail("This test expected a success")
			}
		}
		
		wait(for: [expectation], timeout: 0.1)
		
		let outputResult = try XCTUnwrap(output)
		XCTAssertEqual(outputResult.first, expectedTransformation)
	}
	
	
	func testGivenHeroIdWhenGetTransformationsThenFail() throws {
		let idHero = "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"
		secureDataProviderMock.setToken(value: self.token)

		MockURLProtocol.requestHandler = { request in
			let url = URL(string: "https://dragonball.keepcoding.education/api/heros/tranformations")!
			let path = Bundle(for: type(of: self)).path(forResource: "transformations", ofType: "json")!
			let data = try! Data(contentsOf: URL(filePath: path))
			let response = MockURLProtocol.urlResponseTest(url: url, statusCode: 500)!
			return (response, data)
		}
		
		let expectation = expectation(description: "Load Transformations")
		var output: NetworkError?
		
		sut.getLocationsForHeroWith(id: idHero) { result in
			switch result {
			case .success( _):
				XCTFail("This test expected a failure")
			case .failure( let error):
				output = error
				expectation.fulfill()
			}
		}
		wait(for: [expectation], timeout: 0.1)
		
		let outputResult = try XCTUnwrap(output)
		XCTAssertEqual(outputResult, .serverError)
	}
}

private extension ApiProviderTests {
	func initialize() -> ApiProvider {
		let configuration = URLSessionConfiguration.ephemeral
		configuration.protocolClasses = [MockURLProtocol.self]
		let session = URLSession.init(configuration: configuration)
		return  ApiProvider(session: session, secureData: secureDataProviderMock)
	}
}
