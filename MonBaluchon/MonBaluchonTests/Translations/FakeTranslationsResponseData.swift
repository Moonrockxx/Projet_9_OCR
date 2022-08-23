//
//  FakeTranslationsResponseData.swift
//  MonBaluchonTests
//
//  Created by TomF on 23/08/2022.
//

import Foundation

class FakeTranslationsResponseData {
    static let responseOk = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!,
                                            statusCode: 200,
                                            httpVersion: nil,
                                            headerFields: nil)!
    
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!,
                                            statusCode: 500,
                                            httpVersion: nil,
                                            headerFields: nil)!
    
    class TranslationsError: Error {}
    static let error = TranslationsError()
    
    static var translationsCorrectData: Data? {
        let bundle = Bundle(for: FakeTranslationsResponseData.self)
        let url = bundle.url(forResource: "Translations", withExtension: "json")
        
        do {
            let data = try Data(contentsOf: url!)
            return data
        } catch {
            // Error ?
        }
        return nil
        
    }
    
    static let translationsIncorrectData = "error".data(using: .utf8)!
}
