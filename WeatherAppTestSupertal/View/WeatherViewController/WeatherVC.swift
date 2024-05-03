//
//  WeatherVC.swift
//  WeatherAppTestSupertal
//
//  Created by Aijaz Ali on 02/05/2024.
//

import UIKit
import Combine

class WeatherVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var weatherTempratureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var cityNameTextField: UITextField!
    
    // MARK: Properties
    private var viewModel = WeatherViewModel()
    private var cancellables: Set<AnyCancellable> = []

    // MARK: Lifecycle of view
    override func viewDidLoad() {
        super.viewDidLoad()
        self.observeViewModel()
        self.prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func prepareView() {
        self.showActivity()
    }
    
    // MARK: Show activity loader
    private func showActivity() {
        self.searchButton.isUserInteractionEnabled = false
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    // MARK: Hide activity loader
    private func hideActivity() {
        self.searchButton.isUserInteractionEnabled = true
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        self.cityNameTextField.text = ""
    }
    
    
    // MARK: Action
    @IBAction func getWaetherDataButtonTapped(_ sender: UIButton) {
        if !(cityNameTextField.text?.isEmpty ??  false), let cityString = cityNameTextField.text {
            self.showActivity()
            self.viewModel.searchCityLocationByName(cityName: cityString)
        }
    }
    
    // MARK: Observer
    private func observeViewModel() {
        // Observe the weather data
        viewModel.$weatherData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weatherData in
                self?.updateUIWithWeatherData(weatherData)
            }
            .store(in: &cancellables)

        // Observe the error message
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showError(errorMessage)
                }
            }
            .store(in: &cancellables)
    }

    private func updateUIWithWeatherData(_ weatherData: WeatherModel?) {
        self.hideActivity()
        if let weatherData = weatherData {
            self.cityNameLabel.text = weatherData.cityName
            self.weatherTempratureLabel.text = "\(weatherData.current?.temperature2m ?? 0) \(weatherData.currentUnits?.temperature2m ?? "C")"
        }
    }

    private func showError(_ message: String) {
        self.hideActivity()
        self.cityNameLabel.text = "Error: \(message)"
    }
}
