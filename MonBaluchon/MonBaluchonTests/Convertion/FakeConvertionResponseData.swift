//
//  FakeConvertionResponseData.swift
//  MonBaluchonTests
//
//  Created by TomF on 18/08/2022.
//

import Foundation

class FakeConvertionResponseData {
    static let responseOk = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!,
                                            statusCode: 200,
                                            httpVersion: nil,
                                            headerFields: nil)!
    
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!,
                                            statusCode: 500,
                                            httpVersion: nil,
                                            headerFields: nil)!
    
    class ConvertionError: Error {}
    static let error = ConvertionError()
    
    static var convertionCorrectData: Data? {
        let bundle = Bundle(for: FakeConvertionResponseData.self)
        let url = bundle.url(forResource: "Convertion", withExtension: "json")
        
        do {
            let data = try Data(contentsOf: url!)
            return data
        } catch {
            // Error ?
        }
        return nil
        
    }
    
    static let convertionIncorrectData = "error".data(using: .utf8)!
}
