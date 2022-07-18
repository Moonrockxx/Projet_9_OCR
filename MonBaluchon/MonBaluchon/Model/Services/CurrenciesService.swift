//
//  CurrenciesService.swift
//  MonBaluchon
//
//  Created by TomF on 15/07/2022.
//

import Foundation

class CurrenciesService: ConvertDelegate {
    var exchangeVC: ExchangeViewController
//    var convertedAmount: Convertion?
    private static let symbolsUrl = URL(string: "https://api.apilayer.com/fixer/symbols?apikey=TeOLN3KvPxA1VOD4az4SXQLi7ac7RE71")!
    
    init(_ exchange: ExchangeViewController) {
        self.exchangeVC = exchange
        exchange.delegate = self
    }
    
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
    
    func convert(from: String, to: String, amount: String, callback: @escaping (Bool, Convertion?) -> Void) {
        let url = "https://api.apilayer.com/fixer/convert?to=\(to)&from=\(from)&amount=\(amount)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("TeOLN3KvPxA1VOD4az4SXQLi7ac7RE71", forHTTPHeaderField: "apikey")
        
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
            
            guard let responseJSON = try? JSONDecoder().decode(Convertion.self, from: data) else {
                callback(false, nil)
                return
            }
            
            let convertedAmount = Convertion(convertionResult: responseJSON.convertionResult)
            callback(true, convertedAmount)
        }
        task.resume()
    }
}
