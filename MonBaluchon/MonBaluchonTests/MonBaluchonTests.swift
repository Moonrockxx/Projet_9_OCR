//
//  MonBaluchonTests.swift
//  MonBaluchonTests
//
//  Created by TomF on 22/06/2022.
//

@testable import MonBaluchon
import XCTest

@available(iOS, deprecated: 13.0)
class MonBaluchonTests: XCTestCase {
    // MARK: WeatherService
    // URL Builder return empty URL
//    func testURLWithNoComponentsReturnEmptyURL() {
//        let weatherService = WeatherService()
//        let londonURL = weatherService.buildGetWeatherUrl(path: "data/2.5/weather", city: "london")
//        XCTAssertNil(londonURL)
//    }
    
    // API Call return an error
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
    
    // API Call return no datas
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
    
    // API Call return correct datas with incorrect response
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
    
    // API Call return incorrect datas with correct response
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
    
    // API Call return correct datas AND correct response
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
    
    // MARK: CurrenciesService - Symbols
    // API Call return an error
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
    
    // API Call return no datas
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
    
    // API Call return correct datas with incorrect response
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
    
    // API Call return incorrect datas with correct response
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
    
    // API Call return correct datas AND correct response
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
    
    // MARK: CurrenciesService - Convertion
    // API Call return an error
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
    
    // API Call return no datas
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
    
    // API Call return correct datas with incorrect response
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
    
    // API Call return incorrect datas with correct response
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
    
    // API Call return correct datas AND correct response
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
    
    // MARK: LanguagesService - Languages
    // API Call return an error
    func testGetLanguagesShouldPostFailedCallbackIfError() {
        let languagesService = LanguagesService(languagesSession: URLSessionFake(data: nil, response: nil, error: FakeConvertionResponseData.error))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        languagesService.getLanguages { success, languages in
            XCTAssertFalse(success)
            XCTAssertNil(languages)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // API Call return no datas
    func testGetLanguagesShouldPostFailedCallbackIfNoData() {
        let languagesService = LanguagesService(languagesSession: URLSessionFake(data: nil, response: nil, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        languagesService.getLanguages { success, languages in
            XCTAssertFalse(success)
            XCTAssertNil(languages)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // API Call return correct datas with incorrect response
    func testGetLanguagesShouldPostFailedCallbackIfIncorrectResponse() {
        let languagesService = LanguagesService(languagesSession: URLSessionFake(data: FakeLanguagesResponseData.languagesCorrectData, response: FakeLanguagesResponseData.responseKO, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        languagesService.getLanguages { success, languages in
            XCTAssertFalse(success)
            XCTAssertNil(languages)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // API Call return incorrect datas with correct response
    func testGetLanguagesShouldPostFailedCallbackIfIncorrectData() {
        let languagesService = LanguagesService(languagesSession: URLSessionFake(data: FakeLanguagesResponseData.languagesIncorrectData, response: FakeLanguagesResponseData.responseOk, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        languagesService.getLanguages { success, languages in
            XCTAssertFalse(success)
            XCTAssertNil(languages)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // API Call return correct datas AND correct response
    func testGetLanguagesShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let languagesService = LanguagesService(languagesSession: URLSessionFake(data: FakeLanguagesResponseData.languagesCorrectData, response: FakeLanguagesResponseData.responseOk, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        languagesService.getLanguages { success, languages in
            let langKey = "af"
            let langName = "Afrikaans"
            let key = (languages?.data.languages.filter { $0.name == "Afrikaans" })?.first?.language
            let name = (languages?.data.languages.filter { $0.language == "af" })?.first?.name
            
            XCTAssertTrue(success)
            XCTAssertNotNil(languages)
            XCTAssertEqual(key, langKey)
            XCTAssertEqual(name, langName)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: LanguagesService - Translations
    // API Call return an error
    func testGetTranslationsShouldPostFailedCallbackIfError() {
        let languagesService = LanguagesService(languagesSession: URLSessionFake(data: nil, response: nil, error: FakeTranslationsResponseData.error))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        languagesService.getTranslation(from: "en", to: "fr", text: "Hello, my name is Thomas") { success, translation in
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // API Call return no datas
    func testGetTranslationsShouldPostFailedCallbackIfNoData() {
        let languagesService = LanguagesService(languagesSession: URLSessionFake(data: nil, response: nil, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        languagesService.getTranslation(from: "en", to: "fr", text: "Hello, my name is Thomas") { success, translation in
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // API Call return correct datas with incorrect response
    func testGetTranslationsShouldPostFailedCallbackIfIncorrectResponse() {
        let languagesService = LanguagesService(languagesSession: URLSessionFake(data: FakeTranslationsResponseData.translationsCorrectData, response: FakeTranslationsResponseData.responseKO, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        languagesService.getTranslation(from: "en", to: "fr", text: "Hello, my name is Thomas") { success, translation in
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // API Call return incorrect datas with correct response
    func testGetTranslationsShouldPostFailedCallbackIfIncorrectData() {
        let languagesService = LanguagesService(languagesSession: URLSessionFake(data: FakeTranslationsResponseData.translationsIncorrectData, response: FakeTranslationsResponseData.responseOk, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        languagesService.getTranslation(from: "en", to: "fr", text: "Hello, my name is Thomas") { success, translation in
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    // API Call return correct datas AND correct response
    func testGetTranslationsShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let languagesService = LanguagesService(languagesSession: URLSessionFake(data: FakeTranslationsResponseData.translationsCorrectData, response: FakeTranslationsResponseData.responseOk, error: nil))
        let expectation = XCTestExpectation(description: "Wait for queue change")
        languagesService.getTranslation(from: "en", to: "fr", text: "Hello, my name is Thomas") { success, translation in
            XCTAssertTrue(success)
            XCTAssertNotNil(translation)
            
            let textTranslated = "Bonjour, mon nom est Thomas"
            XCTAssertEqual(textTranslated, translation?.data.translations.first?.translatedText)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
