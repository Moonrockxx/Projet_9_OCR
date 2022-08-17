//
//  WeatherService.swift
//  MonBaluchon
//
//  Created by TomF on 27/07/2022.
//

import Foundation
class WeatherService {
    
    private var weatherSession = URLSession(configuration: .default)
    
    init() {}
    
    init(weatherSession: URLSession?) {
        if let session = weatherSession {
            self.weatherSession = session
        }
    }
    
    func getWeather(city: String, callback: @escaping (Bool, Weathers?) -> Void) {
        let url = self.buildGetWeatherUrl(city: city)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = weatherSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Weather get coordinate : error data for \(city)")
                callback(false, nil)
                return
            }
            print(String(data: data, encoding: .utf8) ?? "")
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Weather get coordinate : error response")
                callback(false, nil)
                return
            }
            print(response)
            
            do {
                let weather = try JSONDecoder().decode(Weathers.self, from: data)
                callback(true, weather)
            } catch {
                print("Weather get coordinate : \(error)")
                callback(false, nil)
            }
        }
        
        task.resume()
    }
    
    private func buildGetWeatherUrl(city: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: Bundle.main.infoDictionary?["WEATHER_API_KEY"] as? String)
        ]
        
        guard let url = components.url else {
            return URL(string: "")!
        }
        return url
    }
}
