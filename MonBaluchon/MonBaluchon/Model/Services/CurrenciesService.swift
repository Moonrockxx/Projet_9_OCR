//
//  CurrenciesService.swift
//  MonBaluchon
//
//  Created by TomF on 15/07/2022.
//

import Foundation

class CurrenciesService {
    private static let symbolsUrl = URL(string: "https://api.apilayer.com/fixer/symbols?apikey=TX9DWV8CznHqJ9pfoKPEYxftjUM0HIEz")!
    
    static func getSymbols(callback: @escaping (Bool, Symbols?) -> Void) {
        var request = URLRequest(url: symbolsUrl)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                callback(false, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                callback(false, nil)
                return
            }
            
            guard let responseJSON = try? JSONDecoder().decode(Symbols.self, from: data) else {
                callback(false, nil)
                return
            }
            
            let symbols = Symbols(symbols: responseJSON.symbols)
            callback(true, symbols)
        }
        task.resume()
    }
}
