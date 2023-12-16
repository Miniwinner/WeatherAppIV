//
//  NetworkService.swift
//  WeatherAppIV
//
//  Created by Александр Кузьминов on 10.12.23.
//

import Foundation
import CoreLocation

//1 https://api.openweathermap.org/data/2.5/weather?lat=52&lon=35&appid=567c7b63e5f9a2a52e3fb07c3aa0a5f8
let key = "cb9724d7ea370100c6cee75a0855d1e3"

//2 https://pro.openweathermap.org/data/2.5/forecast/hourly?lat=52&lon=35&appid=cb9724d7ea370100c6cee75a0855d1e3
//3 api.openweathermap.org/data/2.5/forecast/daily?lat=52&lon=35&cnt=7&appid=cb9724d7ea370100c6cee75a0855d1e3
//4 api.openweathermap.org/data/2.5/forecast?lat=21.2827778&lon=-157.8294444&appid=cb9724d7ea370100c6cee75a0855d1e3
class NetworkService {
    
    func fetchWeatherData(for lat: Double, for lon: Double, completion: @escaping (Result<CurrentWeather, Error>) -> Void) {
        guard let urlWeather = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(key)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let requestWeather = URLRequest(url: urlWeather)
        
        URLSession.shared.dataTask(with: requestWeather) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let weather = try self.parseJson(type: CurrentWeather.self, data: data)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
   
   //MARK: - FORECAST
    
    func fetchWeatherFourDays(for lat: Double, for lon: Double, completion: @escaping (Result<ForeCastWeather, Error>) -> Void) {
        guard let urlWeather = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(key)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let requestWeather = URLRequest(url: urlWeather)
        
        URLSession.shared.dataTask(with: requestWeather) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let weather = try self.parseJson(type: ForeCastWeather.self, data: data)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchWeatherTenDays(for lat: Double, for lon: Double, completion: @escaping (Result<TenDaysWeather, Error>) -> Void) {
        guard let urlWeather = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=current,hourly,minutely&appid=\(key)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let requestWeather = URLRequest(url: urlWeather)
        
        URLSession.shared.dataTask(with: requestWeather) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let weather = try self.parseJson(type: TenDaysWeather.self, data: data)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func parseJson<T: Codable>(type: T.Type, data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    enum NetworkError: Error {
        case invalidURL
        case noData
    }
}
