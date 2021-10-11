//
//  WeatherDetailViewController.swift
//  WeatherAPP
//
//  Created by Oluwatobiloba Akinrujomu on 11/10/2021.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherConditionImg: UIImageView!
    
    var indexPath: Int?
    var country: CountryViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        country = CountriesListViewModel().countryViewModel(at: indexPath ?? 0)
        
        weatherConditionImg.addOverlay()
        fetchWeatherDetails()
        
    }
    
    func fetchWeatherDetails() {
        startActivityIndicator()
        let queryParam = "\(country?.state ?? ""), \(country?.countryName ?? "")"
        print(queryParam)
        WebServices().load(resource: WeatherDataResponse.getWeatherDetails(queryParam: queryParam)) { [weak self] response in
            self?.stopActivityIndicator()
            switch response.success {
            case true:
                let response = response.data as? WeatherDataResponse
                if let response = response {
                    self?.loadDetails(response)
                }
            case false:
                print("Error fetching weather details")
                
            }
        }
    }
    
    func loadDetails(_ data: WeatherDataResponse) {
        weatherImg.loadImageViewURL("https://openweathermap.org/img/wn/\(data.weather?[0].icon ?? "04d")@2x.png")
        weatherTypeLabel.text = data.weather?[0].main
        temperatureLabel.text = "\(data.main?.temp ?? 0)ºC"
        cityNameLabel.text = data.name
        countryLabel.text = data.sys?.country
        pressureLabel.text = "\(data.main?.pressure ?? 0) hPa"
        humidityLabel.text = "\(data.main?.humidity ?? 0) %"
        
        switch data.weather![0].id! {
        case 200..<300:
            weatherConditionImg.image = UIImage(named: "thunderstorm")
        case 300..<400:
            weatherConditionImg.image = UIImage(named: "drizzle")
        case 500..<600:
            weatherConditionImg.image = UIImage(named: "rainy")
        case 700..<800:
            weatherConditionImg.image = UIImage(named: "atmosphere")
        default:
            weatherConditionImg.image = UIImage(named: "clear")
            
        }
    }
}
