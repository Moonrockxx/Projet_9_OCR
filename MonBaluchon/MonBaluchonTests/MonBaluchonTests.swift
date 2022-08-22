//
//  MonBaluchonTests.swift
//  MonBaluchonTests
//
//  Created by TomF on 22/06/2022.
//

@testable import MonBaluchon
import XCTest

class MonBaluchonTests: XCTestCase {
    // MARK: WeatherService
    // Erreur
    func testGetWeatherShouldPostFailedCallbackIfError() {
        let weatherService = WeatherService(weatherSession: URLSessionFake(data: nil, response: nil, error: FakeWheatherResponseData.error))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherService.getWeather(city: "London") { success, weather in
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Pas de data
    func testGetWeatherShouldPostFailedCallbackIfNoData() {
        let weatherService = WeatherService(weatherSession: URLSessionFake(data: nil, response: nil, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherService.getWeather(city: "London") { success, weather in
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Données correcte, réponse incorrecte
    func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse() {
        let weatherService = WeatherService(weatherSession: URLSessionFake(data: FakeWheatherResponseData.weatherCorrectData, response: FakeWheatherResponseData.responseKO, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherService.getWeather(city: "London") { success, weather in
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Données incorrecte, réponse correcte
    func testGetWeatherShouldPostFailedCallbackIfIncorrectData() {
        let weatherService = WeatherService(weatherSession: URLSessionFake(data: FakeWheatherResponseData.weatherIncorrectData, response: FakeWheatherResponseData.responseOk, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherService.getWeather(city: "London") { success, weather in
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Données correcte, réponse correcte
    func testGetWeatherShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let weatherService = WeatherService(weatherSession: URLSessionFake(data: FakeWheatherResponseData.weatherCorrectData, response: FakeWheatherResponseData.responseOk, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherService.getWeather(city: "London") { success, weather in
            let weatherDescription = "few clouds"
            let temp = 302.1
            XCTAssertTrue(success)
            XCTAssertNotNil(weather)
            
            XCTAssertEqual(weatherDescription, weather?.weather.first?.weatherDescription)
            XCTAssertEqual(temp, weather?.main.temp)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: CurrenciesService
    // Symbols
    // Erreur
    func testGetSymbolsShouldPostFailedCallbackIfError() {
        let currenciesService = CurrenciesService(currenciesSession: URLSessionFake(data: nil, response: nil, error: FakeSymbolsResponseData.error))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currenciesService.getSymbols { success, symbols in
            XCTAssertFalse(success)
            XCTAssertNil(symbols)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Pas de data
    func testGetSymbolsShouldPostFailedCallbackIfNoData() {
        let currenciesService = CurrenciesService(currenciesSession: URLSessionFake(data: nil, response: nil, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currenciesService.getSymbols { success, symbols in
            XCTAssertFalse(success)
            XCTAssertNil(symbols)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Données correcte, réponse incorrecte
    func testGetSymbolsShouldPostFailedCallbackIfIncorrectResponse() {
        let currenciesService = CurrenciesService(currenciesSession: URLSessionFake(data: FakeSymbolsResponseData.symbolsCorrectData, response: FakeSymbolsResponseData.responseKO, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currenciesService.getSymbols { success, symbols in
            XCTAssertFalse(success)
            XCTAssertNil(symbols)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Données incorrecte, réponse correcte
    func testGetSymbolsShouldPostFailedCallbackIfIncorrectData() {
        let currenciesService = CurrenciesService(currenciesSession: URLSessionFake(data: FakeSymbolsResponseData.symbolsIncorrectData, response: FakeSymbolsResponseData.responseOk, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currenciesService.getSymbols { success, symbols in
            XCTAssertFalse(success)
            XCTAssertNil(symbols)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Données correcte, réponse correcte
    func testGetSymbolsShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let currenciesService = CurrenciesService(currenciesSession: URLSessionFake(data: FakeSymbolsResponseData.symbolsCorrectData, response: FakeSymbolsResponseData.responseOk, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currenciesService.getSymbols { success, symbols in
            let firstSymbolKey = "AED"
            let firstSymbolName = "United Arab Emirates Dirham"
            XCTAssertTrue(success)
            XCTAssertNotNil(symbols)
            
            let key = (symbols?.symbols.filter { $0.value == "United Arab Emirates Dirham" })?.first?.key
            XCTAssertEqual(firstSymbolKey, key)
            XCTAssertEqual(firstSymbolName, symbols?.symbols["AED"])
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Convertion
    // Erreur
    func testGetConvertionShouldPostFailedCallbackIfError() {
        let currenciesService = CurrenciesService(currenciesSession: URLSessionFake(data: nil, response: nil, error: FakeConvertionResponseData.error))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currenciesService.convert(from: "AED", to: "ALL", amount: "5") { success, result in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Pas de data
    func testGetConvertionShouldPostFailedCallbackIfNoData() {
        let currenciesService = CurrenciesService(currenciesSession: URLSessionFake(data: nil, response: nil, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currenciesService.convert(from: "AED", to: "ALL", amount: "5") { success, result in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Données correcte, réponse incorrecte
    func testGetConvertionShouldPostFailedCallbackIfIncorrectResponse() {
        let currenciesService = CurrenciesService(currenciesSession: URLSessionFake(data: FakeConvertionResponseData.convertionCorrectData, response: FakeConvertionResponseData.responseKO, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currenciesService.convert(from: "AED", to: "ALL", amount: "5") { success, result in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Données incorrecte, réponse correcte
    func testGetConvertionShouldPostFailedCallbackIfIncorrectData() {
        let currenciesService = CurrenciesService(currenciesSession: URLSessionFake(data: FakeConvertionResponseData.convertionIncorrectData, response: FakeConvertionResponseData.responseOk, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currenciesService.convert(from: "AED", to: "ALL", amount: "5") { success, result in
            XCTAssertFalse(success)
            XCTAssertNil(result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // Données correcte, réponse correcte
    func testGetConvertionShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let currenciesService = CurrenciesService(currenciesSession: URLSessionFake(data: FakeConvertionResponseData.convertionCorrectData, response: FakeConvertionResponseData.responseOk, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        currenciesService.convert(from: "AED", to: "BAM", amount: "5") { success, result in
            XCTAssertTrue(success)
            XCTAssertNotNil(result)
            
            let exchangeResult = 2.613275
            XCTAssertEqual(result?.result, exchangeResult)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    // MARK: LanguagesService
}
