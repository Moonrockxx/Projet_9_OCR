//
//  FakeLanguagesResponseData.swift
//  MonBaluchonTests
//
//  Created by TomF on 23/08/2022.
//

import Foundation

class FakeLanguagesResponseData {
    static let responseOk = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!,
                                            statusCode: 200,
                                            httpVersion: nil,
                                            headerFields: nil)!
    
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!,
                                            statusCode: 500,
                                            httpVersion: nil,
                                            headerFields: nil)!
    
    class LanguagesError: Error {}
    static let error = LanguagesError()
    
    static var languagesCorrectData: Data? {
        let bundle = Bundle(for: FakeLanguagesResponseData.self)
        let url = bundle.url(forResource: "Languages", withExtension: "json")
        
        do {
            let data = try Data(contentsOf: url!)
            return data
        } catch {
            // Error ?
        }
        return nil
        
    }
    
    static let languagesIncorrectData = "error".data(using: .utf8)!
}
