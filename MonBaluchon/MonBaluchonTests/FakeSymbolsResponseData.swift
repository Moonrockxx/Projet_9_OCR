//
//  FakeSymbolsResponseData.swift
//  MonBaluchonTests
//
//  Created by TomF on 18/08/2022.
//

import Foundation

class FakeSymbolsResponseData {
    static let responseOk = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!,
                                            statusCode: 200,
                                            httpVersion: nil,
                                            headerFields: nil)!
    
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!,
                                            statusCode: 500,
                                            httpVersion: nil,
                                            headerFields: nil)!
    
    class SymbolsError: Error {}
    static let error = SymbolsError()
    
    static var symbolsCorrectData: Data? {
        let bundle = Bundle(for: FakeSymbolsResponseData.self)
        let url = bundle.url(forResource: "Symbols", withExtension: "json")
        
        do {
            let data = try Data(contentsOf: url!)
            return data
        } catch {
            // Error ?
        }
        return nil
        
    }
    
    static let symbolsIncorrectData = "error".data(using: .utf8)!
}
