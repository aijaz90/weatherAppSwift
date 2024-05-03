//
//  WeatherAppNetworkTests.swift
//  WeatherAppTestSupertalTests
//
//  Created by Aijaz Ali on 03/05/2024.
//

import XCTest
@testable import WeatherAppTestSupertal

class WeatherAppNetworkTests: XCTestCase {

    var networkObject: Network!

    override func setUpWithError() throws {
        try super.setUpWithError()
        networkObject = Network()
    }

    override func tearDownWithError() throws {
        networkObject = nil
        try super.tearDownWithError()
    }

    func testGetDataSuccess() async {
        // Given
        let apiRoute = "forecast?" + "latitude=\(12.2)&longitude=\(22.5)" + "&current=temperature_2m"

        // When
        do {
            let result: WeatherModel = try await networkObject.getData(apiRoute: apiRoute)
            // Assuming a successful response here
            // You may need to replace it with your mock data or stub the network call
            XCTAssertNotNil(result)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testInvalidAPIRouteFailure() async {
        // Given
        let invalidApiRoute = "invalidRoute" // Providing an invalid API route

        // When
        do {
            let _: WeatherModel = try await networkObject.getData(apiRoute: invalidApiRoute)
            // If the network call succeeds despite the invalid route, fail the test
            XCTFail("The network call succeeded unexpectedly.")
        } catch {
            // Then
            XCTAssertNotNil(error)
            // Check if the error is what you expect for a failed network request or route
            // For example, you could check if the error is URLError with a specific error code
            XCTAssertTrue(error is URLError)
            // You might also check the specific error code or domain to ensure it's the expected error
            let urlError = error as! URLError
            XCTAssertEqual(urlError.errorCode, URLError.badURL.rawValue)
        }
    }


    // Add more test cases as needed to cover other functionalities

}
