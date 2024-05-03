//
//  WeatherAppTestSupertalTests.swift
//  WeatherAppTestSupertalTests
//
//  Created by Aijaz Ali on 02/05/2024.
//

import XCTest
@testable import WeatherAppTestSupertal

final class WeatherAppTestSupertalTests: XCTestCase {
    
    var weatherViewModel: WeatherViewModel!

    override func setUpWithError() throws {
        weatherViewModel = WeatherViewModel()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLoadCurrentWeatherDataSuccess() throws {
            // Given
            let expectation = XCTestExpectation(description: "Weather data received")
            let cityName = "Test City"

            // When
            weatherViewModel.loadCurrentWeatherData(cityName: cityName)

            // Then
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                XCTAssertNotNil(self.weatherViewModel.weatherData)
                XCTAssertEqual(self.weatherViewModel.weatherData?.cityName, cityName)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 5)
        }

//        func testLoadCurrentWeatherDataFailure() throws {
//            // Given
//            let expectation = XCTestExpectation(description: "Error message received")
//            let invalidCityName = "Invalid City"
//
//            // When
//            weatherViewModel.loadCurrentWeatherData(cityName: invalidCityName)
//
//            // Then
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                XCTAssertNotNil(self.weatherViewModel.errorMessage)
//                expectation.fulfill()
//            }
//            wait(for: [expectation], timeout: 5)
//        }

}
