//
//  TransformationCollectionViewCell.swift
//  Practica_IOS_AvanzadoTests
//
//  Created by David Ortega Iglesias on 15/5/24.
//

import XCTest
@testable import Practica_IOS_Avanzado

final class LoginViewModelTests: XCTestCase {
	private var apiProviderMock: ApiProviderMock!
    private var sut: LoginViewModel!

    override func setUpWithError() throws {
		try super.setUpWithError()
		apiProviderMock = .init()
        sut = LoginViewModel(apiProvider: apiProviderMock)
    }

    override func tearDownWithError() throws {
		apiProviderMock = nil
        sut = nil
		try super.tearDownWithError()
    }
    
    func testGivenEmailAndPasswordWhenLoginSuccessThenStateMatch() throws {
        let email = "email"
        let password = "password"
		
		let expectation = expectation(description: "Logon success and token stored")
		expectation.expectedFulfillmentCount = 2
		apiProviderMock.loginCompletion = .success("token")
		var output: LoginState?
		
		sut.loginStateChanged = { state in
			output = state
			expectation.fulfill()
		}
		
        sut.loginWith(email: email, password: password)
	
		wait(for: [expectation], timeout: 0.1)
	
		let outputResult = try XCTUnwrap(output)
		XCTAssertEqual(outputResult, .success) 
		
    }
	
	func testGivenEmailAndPasswordWhenLoginFailThenStateMatch() throws {
		let email = "email"
		let password = "password"
		
		let expectation = expectation(description: "Logon success and token stored")
		expectation.expectedFulfillmentCount = 2
		var output: LoginState?
		
		sut.loginStateChanged = { state in
			output = state
			expectation.fulfill()
		}
		apiProviderMock.loginCompletion = .failure(.unauthorized)

		sut.loginWith(email: email, password: password)
	
		wait(for: [expectation], timeout: 0.1)
	
		let outputResult = try XCTUnwrap(output)
		XCTAssertEqual(outputResult, .failed(.unauthorized)) 
	}
	
	func testGivenNoEmailWhenIsNotValidThenMatch() throws {
		let email: String = ""
		
		let output = sut.isValid(email: email)
		
		XCTAssertFalse(output)
	}
	
	func testGivenEmailWhenIsValidThenMatch() throws {
		let email: String = "goku@dragonball.com"
		
		let output = sut.isValid(email: email)
		
		XCTAssertTrue(output)
	}
	
	func testGivenPassWithLessThanFourCharsWhenIsNotValidThenMatch() throws {
		let pass: String = "pas"
		
		let output = sut.isValid(password: pass)
		
		XCTAssertFalse(output)
	}
	
	func testGivenPassWithMoreThanThreeCharsWhenIsValidThenMatch() throws {
		let pass: String = "aaaaa"
		
		let output = sut.isValid(password: pass)
		
		XCTAssertTrue(output)
	}
}
