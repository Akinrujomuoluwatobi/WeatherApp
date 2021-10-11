//
//  CountriesListViewModel.swift
//  WeatherAPP
//
//  Created by Oluwatobiloba Akinrujomu on 11/10/2021.
//

import Foundation
import ObjectMapper
class CountriesListViewModel {
    var countriesViewModels: [CountryViewModel]
    
    init() {
        self.countriesViewModels = getCountriesModel()
    }
}

extension CountriesListViewModel{
    func countryViewModel(at index: Int) -> CountryViewModel {
        return countriesViewModels[index]
    }
}

struct CountryViewModel {
    let country: CountriesModel
}

extension CountryViewModel {
    var state: String? {
        return country.name
    }
    
    var countryName: String? {
        return country.country
    }
    
    var image: String? {
        return country.img
    }
    
}

func getCountriesModel() -> [CountryViewModel] {
    if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let convertedString = String(data: data, encoding: String.Encoding.utf8) // the data will be converted to the string
            let countries = Mapper<CountriesModel>().mapArray(JSONString: convertedString!)
            
            print(countries?.toJSONString())
            
            return countries?.map(CountryViewModel.init) ?? [CountryViewModel]()
            
        } catch let error {
            print("parse error: \(error.localizedDescription)")
        }
    } else {
        print("Invalid filename/path.")
    }
    
    return [CountryViewModel]()
}
