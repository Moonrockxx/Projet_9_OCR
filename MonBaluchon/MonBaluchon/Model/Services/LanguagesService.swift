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
    
    private static let getLanguagesURL = URL(string: "https://translation.googleapis.com/language/translate/v2/languages?key=AIzaSyCPfvAhyclZQim1gqn-QhsVwvlHlL1ydsc&target=en")!
    
    private var task: URLSessionDataTask?
    
    func getLanguages(callback: @escaping (Bool, Languages?) -> Void) {
        var request = URLRequest(url: LanguagesService.getLanguagesURL)
        request.httpMethod = "POST"
        
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                
                guard let responseJSON = try? JSONDecoder().decode(Languages.self, from: data) else {
                    callback(false, nil)
                    return
                }
                
                let lang = Languages(data: responseJSON.data)
                
                print(lang.data.languages)
                callback(true, lang)
            }
        }
        task?.resume()
    }
    
    func getTranslation(from: String, to: String, text: String, callback: @escaping (Bool, Translations?) -> Void) {
        let url = "https://translation.googleapis.com/language/translate/v2?key=AIzaSyCPfvAhyclZQim1gqn-QhsVwvlHlL1ydsc&q=\(text)&target=\(to)&format=text&source=\(from)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        task = session.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("error data")
                    callback(false, nil)
                    return
                }
                print(String(data: data, encoding: .utf8) ?? "")
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("error response")
                    callback(false, nil)
                    return
                }
                print(response)
                
                do {
                    let responseJSON = try JSONDecoder().decode(Translations.self, from: data)
                    let translatedText = Translations(data: responseJSON.data)
                    callback(true, translatedText)
                } catch {
                    print(error)
                    callback(false, nil)
                }
        }
        task?.resume()
    }
}
