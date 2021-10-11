//
//  CountriesModel.swift
//  WeatherAPP
//
//  Created by Oluwatobiloba Akinrujomu on 11/10/2021.
//

import Foundation
import ObjectMapper

// MARK: - CountriesModelElement
class CountriesModel: Mappable, Codable {
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.img <- map["img"]
        self.name <- map["name"]
        self.state <- map["state"]
        self.country <- map["country"]
        self.coord <- map["coord"]
    }
    
    var id: Int?
    var img: String?
    var name, state, country: String?
    var coord: Coord?

}

// MARK: - Coord
class Coord: Mappable, Codable {
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.lon <- map["lon"]
        self.lat <- map["lat"]
    }
    
    var lon, lat: Double?

}
