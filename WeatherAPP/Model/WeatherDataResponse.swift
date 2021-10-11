//
//  WeatherDataResponse.swift
//  WeatherAPP
//
//  Created by Oluwatobiloba Akinrujomu on 11/10/2021.
//

import Foundation
import ObjectMapper

// MARK: - WeatherDataResponse
class WeatherDataResponse: Mappable, Codable {
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.weather <- map["weather"]
        self.main <- map["main"]
        self.sys <- map["sys"]
        self.timezone <- map["timezone"]
        self.id <- map["id"]
        self.name <- map["name"]
    }
    
    var weather: [Weather]?
    var main: Main?
    var sys: Sys?
    var timezone, id: Int?
    var name: String?

}

// MARK: - Main
class Main: Mappable, Codable {
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.temp <- map["temp"]
        self.feelsLike <- map["feels_like"]
        self.tempMin <- map["temp_min"]
        self.tempMax <- map["temp_max"]
        self.pressure <- map["pressure"]
        self.humidity <- map["humidity"]
        self.seaLevel <- map["sea_level"]
        self.grndLevel <- map["grnd_level"]
    }
    
    var temp, feelsLike, tempMin, tempMax: Double?
    var pressure, humidity, seaLevel, grndLevel: Int?

}

// MARK: - Sys
class Sys: Mappable, Codable {
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.country <- map["country"]
        self.sunrise <- map["sunrise"]
        self.sunset <- map["sunset"]
    }
    
    var country: String?
    var sunrise, sunset: Int?

}

// MARK: - Weather
class Weather: Mappable, Codable {
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.main <- map["main"]
        self.weatherDescription <- map["description"]
        self.icon <- map["icon"]
    }
    
    var id: Int?
    var main, weatherDescription, icon: String?

}

extension WeatherDataResponse {
    static func getWeatherDetails(queryParam: String) -> Resource<WeatherDataResponse> {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=50713058a99fdc67ff4cbe293a03bcbb") else { fatalError("Url not valid")
            
        }
        let finalUrl = url.appending("q", value: queryParam)
        return Resource<WeatherDataResponse>(url: finalUrl, body: nil)
        
    }
}
