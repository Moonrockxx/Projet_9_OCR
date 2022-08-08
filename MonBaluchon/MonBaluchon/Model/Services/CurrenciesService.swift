//
//  CurrenciesService.swift
//  MonBaluchon
//
//  Created by TomF on 15/07/2022.
//

import Foundation

class CurrenciesService {
    static var shared = CurrenciesService()
    private init() {}
    
    private var task: URLSessionDataTask?
    
    func getSymbols(callback: @escaping (Result<Symbols, APIErrors>) -> Void) {
        let url = self.buildGetSymbolsURL()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(Bundle.main.infoDictionary?["CURRENCIES_API_KEY"] as! String, forHTTPHeaderField: "apikey")
        
        
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Get Symbols : error data")
                callback(.failure(.badURL))
                return
            }
            print("Get Symbols : \(String(data: data, encoding: .utf8) ?? "")")
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Get Symbols : error response")
                callback(.failure(.badResquest))
                return
            }
            print(response)
            
            do {
                let responseJSON = try JSONDecoder().decode(Symbols.self, from: data)
                let symbols = Symbols(symbols: responseJSON.symbols)
                callback(.success(symbols))
            } catch {
                print("Get Symbols : \(error)")
                callback(.failure(.dataParsing))
            }
        }
        task?.resume()
    }
    
    func convert(from: String, to: String, amount: String, callback: @escaping (Result<Convertion, APIErrors>) -> Void) {
        let url = self.buildConvertionURL(from: from, to: to, amount: amount)
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue(Bundle.main.infoDictionary?["CURRENCIES_API_KEY"] as! String, forHTTPHeaderField: "apikey")
        
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Currencies Convertion : error data")
                callback(.failure(.badURL))
                return
            }
            print(String(data: data, encoding: .utf8) ?? "")
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Currencies Convertion : error response")
                callback(.failure(.badResquest))
                return
            }
            print(response)
            
            do {
                let responseJSON = try JSONDecoder().decode(Convertion.self, from: data)
                let convertedAmount = Convertion(result: responseJSON.result)
                callback(.success(convertedAmount))
            } catch {
                print("Currencies Convertion : \(error)")
                callback(.failure(.dataParsing))
            }
        }
        task?.resume()
    }
    
    private func buildGetSymbolsURL() -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.apilayer.com"
        components.path = "/fixer/symbols"
        
        guard let url = components.url else {
            return URL(string: "")!
        }
        return url
    }
    
    private func buildConvertionURL(from: String, to: String, amount: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.apilayer.com"
        components.path = "/fixer/convert"
        components.queryItems = [
            URLQueryItem(name: "to", value: to),
            URLQueryItem(name: "from", value: from),
            URLQueryItem(name: "amount", value: amount)
        ]
        
        guard let url = components.url else {
            return URL(string: "")!
        }
        return url
    }
}
