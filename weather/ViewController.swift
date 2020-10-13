//
//  ViewController.swift
//  weather
//
//  Created by pavel on 9/5/20.
//  Copyright © 2020 pavel. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    //search bar
    @IBOutlet weak var searchBar: UISearchBar!
    
    // labels temp
    @IBOutlet weak var nameCityLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var descriptionWeatherLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    // buttons
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var burgerButton: UIButton!
    
    var models = [List]()
    var modelsLocation = [WeatherLocation]()
    
    // table view
    @IBOutlet weak var fiveDaysTableView: UITableView!
    let heightForRow: CGFloat = 51
    let id = "WeatherTableViewCell"
    
    // location
    private var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    
    // location detail weather view
    @IBOutlet weak var detailWeatherView: UIView!
    @IBOutlet weak var likeTempLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocation()
        
        // hidden table view
        fiveDaysTableView.isHidden = true
        
        // frame search view
        self.searchView.frame.origin.x = self.searchView.frame.origin.x - self.searchView.bounds.width
        
        // frame test view and label
        self.detailWeatherView.center.y = self.view.center.y + (self.view.bounds.height/3.5)
        
        // search bar
        searchBar.delegate = self
        searchBar.placeholder = "Name city"
        
        // table view
        fiveDaysTableView.delegate = self
        fiveDaysTableView.dataSource = self
        fiveDaysTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: id)
        
    }
    
    //MARK: - show and hiddem menu
    @IBAction func burgerButton(_ sender: UIButton) {
        showSearchView()
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        hiddenSearchView()
    }
    
    
    func showSearchView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.searchView.frame.origin.x = self.searchView.frame.origin.x + self.searchView.bounds.width
        }, completion: nil)
    }
    
    
    func hiddenSearchView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.searchView.frame.origin.x = self.searchView.frame.origin.x - self.searchView.bounds.width
        }, completion: nil)
        
    }
    

    //MARK: - location and update view
    func setupLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation() // start
        locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    
    func locationUpdateView(placeLocation: String, description: String, detailDescription: String, temp: String, wind: String, humidilty: String) {
        self.nameCityLabel.text = placeLocation
        self.descriptionWeatherLabel.text = description
        self.detailDescriptionLabel.text = detailDescription
        self.temperatureLabel.text = temp
        self.windLabel.text = wind
        self.humidityLabel.text = humidilty
    }
    
    
    func locationDetailUpdateView(feelsLike: String, tempMin: String, tempMax: String, pressure: String) {
        self.likeTempLabel.text = feelsLike
        self.tempMinLabel.text = tempMin
        self.tempMaxLabel.text = tempMax
        self.pressureLabel.text = pressure
    }
    
    
// MARK: - show alert if error or wrong name city
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "City not found", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
// MARK: - image view and background color view
    func updateView(description: String?) {
        switch description {
        case "Sunny":
            weatherImageView.image = UIImage(named: "sunny")
            view.backgroundColor = UIColor(red: 0.9, green: 0.8, blue: 0.3, alpha: 1.0)
        case "Rain":
            weatherImageView.image = UIImage(named: "rain")
            view.backgroundColor = UIColor(red: 0.2, green: 0.3, blue: 0.6, alpha: 1.0)
        case "Clouds":
            weatherImageView.image = UIImage(named: "clouds")
            view.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.8, alpha: 1.0)
        case "Mist":
            weatherImageView.image = UIImage(named: "haze")
            view.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.8, alpha: 1.0)
        case "Clear":
            weatherImageView.image = UIImage(named: "clear")
            view.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.4, alpha: 1.0)
        case "Smoke":
            weatherImageView.image = UIImage(named: "haze")
            view.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.8, alpha: 1.0)
        default:
            break
        }
    }

    // MARK: - date format
    // date format of the day
    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: inputDate)
    }
    
    
    // date format of day in cells
    func getTableCellDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        let formatterTableCell = DateFormatter()
        formatterTableCell.dateFormat = "EEEE, MMM d, h:mm a"
        return formatterTableCell.string(from: inputDate)
    }
    
}

// MARK: - location
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        guard let coordinates = location?.coordinate else {
            return
        }
        
        let longitude = coordinates.longitude
        let latitude = coordinates.latitude
        let urlStringLocation = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=imperial&appid=1f54b6b75677b4b94465e3a558e93a5f"
        let url = URL(string: urlStringLocation)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let weatherLocation: WeatherLocation?
                weatherLocation = try JSONDecoder().decode(WeatherLocation.self, from: data)
                
                // update labels location and search view
                let place = "\(weatherLocation?.name ?? ""), \(weatherLocation?.sys.country ?? "")"
                let descriptionLoc = "\(weatherLocation?.weather.first?.main ?? "")"
                let detailDescription = "\(weatherLocation?.weather.first?.description ?? "")"
                let temp = "\(weatherLocation?.main.temp ?? 0)°F"
                let wind = "Wind: \(weatherLocation?.wind.speed ?? 0) m/s"
                let humidilty = "Humidity: \(weatherLocation?.main.humidity ?? 0) %"
                
                // update labels location weather detail view
                let feels_like = "Feels like: \(weatherLocation?.main.feels_like ?? 0) °F"
                let temp_min = "Temperature min: \(weatherLocation?.main.temp_min ?? 0) °F"
                let temp_max = "Temperature max: \(weatherLocation?.main.temp_max ?? 0) °F"
                let pressure = "Pressure: \(weatherLocation?.main.pressure ?? 0) in"
                  
                DispatchQueue.main.async {
                    self.locationDetailUpdateView(feelsLike: feels_like, tempMin: temp_min, tempMax: temp_max, pressure: pressure)
                    self.locationUpdateView(placeLocation: place, description: descriptionLoc, detailDescription: detailDescription, temp: temp, wind: wind, humidilty: humidilty)// city, description, detailDescription, temp, wind, humidilty
                    self.updateView(description: descriptionLoc) //image
                    self.todayLabel.text = self.getDayForDate(Date(timeIntervalSince1970: Double(weatherLocation?.dt ?? 0))) // date
                }
            } catch let error {
                print(error)
            }
        }.resume()
        locationManager?.stopUpdatingLocation()
    }
}


// MARK: - search bar
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let nameCity = searchBar.text!.replacingOccurrences(of: " ", with: "%20") // if city with space
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(nameCity)&units=imperial&appid=937dd1f8313e820f6becf5d2fcfe4f08"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }

            do {
                let weather: WeatherSearchCity?
                weather = try JSONDecoder().decode(WeatherSearchCity.self, from: data)
                
                let description = "\(weather?.list.first?.weather.first?.main ?? "")"
                
                self.models = (weather?.list as! [List])
                
                DispatchQueue.main.async {
                    self.fiveDaysTableView.isHidden = false
                    self.detailWeatherView.isHidden = true
                    self.fiveDaysTableView.reloadData()
                    self.hiddenSearchView()
        
                    if ((response as! HTTPURLResponse).statusCode) == 404 {
                        self.showAlert() // show alert if wrong name city
                    } else {
                        self.nameCityLabel.text = "\(weather?.city.name ?? ""), \(weather?.city.country ?? "")"    // name city
                        self.descriptionWeatherLabel.text = "\(weather?.list.first?.weather.first?.main ?? "")"      // description weather
                        self.detailDescriptionLabel.text = "\(weather?.list.first?.weather.first?.description ?? "")" // detail description weather
                        self.temperatureLabel.text = ("\((weather?.list.first?.main.temp)!)°F")                    // temperature
                        self.windLabel.text = ("Wind: \((weather?.list.first?.wind.speed)!) m/s")                  // speed wind
                        self.humidityLabel.text = ("Humidity: \((weather?.list.first?.main.humidity)!) %")           // humidity
                        self.updateView(description: description)                                              // image
                        self.todayLabel.text = self.getDayForDate(Date(timeIntervalSince1970: Double(self.models.first?.dt ?? 0))) //
                    }
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
}

// MARK: - table view
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = fiveDaysTableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
        guard let customCell = cell as? WeatherTableViewCell else {
            return cell
        }
        
        customCell.backgroundColor = .clear                                    //цвет ячейки прозрачный
        customCell.tempLabel.text = "\(models[indexPath.row].main.temp) °F"      //temp
        customCell.humidityLabel.text = "\(models[indexPath.row].main.humidity) %"//humidity
        customCell.windLabel.text = "\(models[indexPath.row].wind.speed) m/s"    //wind
        customCell.dayOfWeekLabel.text = "\(getTableCellDayForDate(Date(timeIntervalSince1970: Double(models[indexPath.row].dt))))" // day week
        
        // image custom cell
        let icon = models[indexPath.row].weather.first?.main
        if icon?.contains("Sunny") ?? true {
            customCell.weatherImage.image = UIImage(named: "sunny")
        } else if icon?.contains("Rain") ?? true {
            customCell.weatherImage.image = UIImage(named: "rain")
        } else if icon?.contains("Clouds") ?? true {
           customCell.weatherImage.image = UIImage(named: "clouds")
        } else if icon?.contains("Mist") ?? true {
           customCell.weatherImage.image = UIImage(named: "haze")
        } else if icon?.contains("Clear") ?? true {
           customCell.weatherImage.image = UIImage(named: "clear")
        }
        return customCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow
    }
    
}





