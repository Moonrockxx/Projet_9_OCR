//
//  WeatherService.swift
//  MonBaluchon
//
//  Created by TomF on 27/07/2022.
//

import Foundation
class WeatherService {
    static var shared = WeatherService()
    private init() {}
    
    private var task: URLSessionDataTask?
    
    func getWeather(lat: Double, lon: Double, callback: @escaping (Bool, Weathers?) -> Void) {
        let url = self.buildGetWeatherURL(lat: lat, long: lon)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        
        task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                callback(false, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                callback(false, nil)
                return
            }
            
            guard let responseJSON = try? JSONDecoder().decode(Weathers.self, from: data) else {
                callback(false, nil)
                return
            }
            
            let weather = Weathers(coord: responseJSON.coord, weather: responseJSON.weather, base: responseJSON.base, main: responseJSON.main, visibility: responseJSON.visibility, wind: responseJSON.wind, clouds: responseJSON.clouds, dt: responseJSON.dt, sys: responseJSON.sys, timezone: responseJSON.timezone, id: responseJSON.id, name: responseJSON.name, cod: responseJSON.cod)
            
            callback(true, weather)
        }
        task?.resume()
    }
    
    func getCoordinates(city: String, callback: @escaping (Bool, Coordinates?) -> Void) {
        let url = self.buildGetCityCoordonates(city: city)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        
        task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                callback(false, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                callback(false, nil)
                return
            }
            
            guard let responseJSON = try? JSONDecoder().decode(Coordinates.self, from: data) else {
                callback(false, nil)
                return
            }
            
            let coord = Coordinates(name: responseJSON.name, localNames: responseJSON.localNames, lat: responseJSON.lat, lon: responseJSON.lon, country: responseJSON.country, state: responseJSON.state)
            
            print(coord)
            callback(true, coord)
        }
        task?.resume()
    }
    
    private func buildGetCityCoordonates(city: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/geo/1.0/direct"
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "appid", value: Bundle.main.infoDictionary?["WEATHER_API_KEY"] as? String)
        ]
        
        guard let url = components.url else {
            return URL(string: "")!
        }
        return url
    }
    
    private func buildGetWeatherURL(lat: Double, long: Double) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "long", value: String(long)),
            URLQueryItem(name: "appid", value: Bundle.main.infoDictionary?["WEATHER_API_KEY"] as? String)
        ]
        
        guard let url = components.url else {
            return URL(string: "")!
        }
        return url
    }
    
}
