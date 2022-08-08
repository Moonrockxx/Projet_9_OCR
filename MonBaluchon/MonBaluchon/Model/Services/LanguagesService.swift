//
//  LanguagesService.swift
//  MonBaluchon
//
//  Created by TomF on 19/07/2022.
//

import Foundation

class LanguagesService {
    static var shared = LanguagesService()
    private init() {}
    
    private var task: URLSessionDataTask?
    
    func getLanguages(callback: @escaping (Result<Languages, APIErrors>) -> Void) {
        let url = self.buildgetLanguagesURL()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                callback(.failure(.badURL))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                callback(.failure(.badResquest))
                return
            }
            
            guard let responseJSON = try? JSONDecoder().decode(Languages.self, from: data) else {
                callback(.failure(.dataParsing))
                return
            }
            
            do {
                let lang = try JSONDecoder().decode(Languages.self, from: data)
                callback(.success(lang))
            } catch {
                print("Get languages : \(error)")
                callback(.failure(.dataParsing))
            }
        }
        task?.resume()
    }
    
    func getTranslation(from: String, to: String, text: String, callback: @escaping (Result<Translations, APIErrors>) -> Void) {
        let url = self.buildTranslationURL(from: from, to: to, text: text)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error data")
                callback(.failure(.badURL))
                return
            }
            print(String(data: data, encoding: .utf8) ?? "")
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("error response")
                callback(.failure(.badResquest))
                return
            }
            print(response)
            
            do {
                let responseJSON = try JSONDecoder().decode(Translations.self, from: data)
                let translatedText = Translations(data: responseJSON.data)
                callback(.success(translatedText))
            } catch {
                print(error)
                callback(.failure(.dataParsing))
            }
        }
        task?.resume()
    }
    
    private func buildgetLanguagesURL() -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "translation.googleapis.com"
        components.path = "/language/translate/v2/languages"
        components.queryItems = [
            URLQueryItem(name: "key", value: Bundle.main.infoDictionary?["TRANSLATION_API_KEY"] as? String),
            URLQueryItem(name: "target", value: "en")
        ]
        
        guard let url = components.url else {
            return URL(string: "")!
        }
        return url
    }
    
    private func buildTranslationURL(from: String, to: String, text: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "translation.googleapis.com"
        components.path = "/language/translate/v2"
        components.queryItems = [
            URLQueryItem(name: "key", value: Bundle.main.infoDictionary?["TRANSLATION_API_KEY"] as? String),
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "target", value: to),
            URLQueryItem(name: "format", value: "text"),
            URLQueryItem(name: "source", value: from)
        ]
        
        guard let url = components.url else {
            return URL(string: "")!
        }
        return url
    }
}
