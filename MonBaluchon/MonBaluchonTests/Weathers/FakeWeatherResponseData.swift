//
//  FakeWeatherResponseData.swift
//  MonBaluchonTests
//
//  Created by TomF on 10/08/2022.
//

import Foundation

class FakeWheatherResponseData {
    static let responseOk = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!,
                                            statusCode: 200,
                                            httpVersion: nil,
                                            headerFields: nil)!
    
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!,
                                            statusCode: 500,
                                            httpVersion: nil,
                                            headerFields: nil)!
    
    class WeatherError: Error {}
    static let error = WeatherError()
    
    static var weatherCorrectData: Data? {
        let bundle = Bundle(for: FakeWheatherResponseData.self)
        let url = bundle.url(forResource: "Weathers", withExtension: "json")
        
        do {
            let data = try Data(contentsOf: url!)
            return data
        } catch {
            // Error ?
        }
        return nil
        
    }
    
    static let weatherIncorrectData = "error".data(using: .utf8)!
}
