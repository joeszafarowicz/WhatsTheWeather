//
//  Structs.swift
//  WhatsTheWeather
//
//  Created by Joseph Szafarowicz on 3/12/21.
//

import Foundation

struct OpenWeather: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current
    }
}

struct Current: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let dewPoint: Double
    let uvi: Double
    let clouds: Int
    let visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let currentWeather: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case currentWeather = "weather"
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}

func fetchOpenWeatherData(latitude: Double, longitude: Double) {
    guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=imperial&exclude==minutely,hourly,daily,alerts&appid=API_KEY") else {
        print("Invalid URL")
        return
    }
    let request = URLRequest(url: url)
    URLSession.shared.dataTask(with: request) {data, response, error in
        if let data = data {
          do {
            let decodedResponse = try JSONDecoder().decode(OpenWeather.self, from: data)

            currentCondition = decodedResponse.current.currentWeather[0].main
            currentSummary = decodedResponse.current.currentWeather[0].weatherDescription
            currentTemperature = Int(decodedResponse.current.temp)
            feelsLikeTemperature = Int(decodedResponse.current.feelsLike)
          } catch {
            debugPrint(error)
            print(error.localizedDescription)
          }
          return
        }
    }.resume()
}
