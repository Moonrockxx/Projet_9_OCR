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
                
//                guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: Any] else {
//                    callback(false, nil)
//                    return
//                }
                
                guard let responseJSON = try? JSONDecoder().decode(Languages.self, from: data) else {
                    callback(false, nil)
                    return
                }
                
                let lang = Languages(lang: responseJSON.lang)
                
                print(lang.lang)
                callback(true, lang)
            }
        }
        task?.resume()
    }
}
