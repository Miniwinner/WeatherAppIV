//
//  WeatherViewModel.swift
//  WeatherAppIV
//
//  Created by Александр Кузьминов on 10.12.23.
//

import Foundation
import CoreLocation

class WheatherViewModel {
    
    let networkService = NetworkService()
    let coreDataService = CoreDataService()
    
    
    var rowModels:[RawModel] = []
    var currentList:[RawModel] = []
    
    var rowForeCast:[ForeCastModel] = []
    var foreCastList:[ForeCastModel] = []
    
    var limitedArray:[ForeCastModel] = []
    var limitedArrayTen:[TenDaysRawModel] = []
    
    var rowTenForeCast:[TenDaysRawModel] = []
    var foreCastListTen:[TenDaysRawModel] = []

    var lastCoords:LastModel = LastModel(latitude: 55.7558, longitude: 37.6176)
    
    var loadCurrentWeather: (() -> Void)?
    var loadForeCastTen: (() -> Void)?
    var loadForeCastFour: (() -> Void)?
    var callCLLmanager: (() -> Void)?
    
    let mainHours:[String] = ["15:00", "18:00", "21:00", "00:00", "06:00", "09:00", "12:00", "15:00", "18:00", "21:00", "00:00", "06:00"]
    
    let days:[String] = ["Пн","Вт","Ср","Чт","Пт","Сб","Вс"]
    
    //MARK: - CONNECTION CHECK
    
    func loadData(){
        
        if  networkService.checkConnection() == true{
            callCLLmanager?()
            
        }else{
            
            update(latitude: lastCoords.latitude, longtitude: lastCoords.longitude)
            updateFC(latitude: lastCoords.latitude, longtitude: lastCoords.longitude)
            updateFCT(latitude: lastCoords.latitude, longtitude: lastCoords.longitude)
        }
        
    }
    
   
    
    //MARK: - CURRENT
    
    func loadWeatherInfo(latitude: Double, longitude: Double) {
        lastCoords = LastModel(latitude: latitude, longitude: longitude)
        networkService.fetchWeatherData(for: latitude, for: longitude) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let weatherData):
              
                
                self.coreDataService.update(with: weatherData)
                self.update(latitude: weatherData.coord.lat, longtitude: weatherData.coord.lon)
                
            case .failure(let error):

                print("Ошибка при получении данных о погоде CURRENT: \(error.localizedDescription)")
            }
        }
    }

    private func update(latitude: Double, longtitude: Double) {
        guard let dataModel = coreDataService.fetchOneElement(latitude: latitude, longtitude: longtitude) else { return }

        let rawModel = RawModel(
            name: dataModel.name ?? "NEVERLAND",
            temp: convertToCelsius(dataModel.temp),
            id: dataModel.id,
            description: dataModel.descriptionW ?? "GOOD",
            minTemp: convertToCelsius(dataModel.minTemp),
            maxTemp: convertToCelsius(dataModel.maxTemp)
        )

        rowModels = [rawModel]
        currentList = rowModels

        self.loadCurrentWeather?()
    }

    

    
    //MARK: -  FOUR
    
    func loadWeatherInfoForeCast(latitude: Double, longitude: Double) {
        
        networkService.fetchWeatherFourDays(for: latitude, for: longitude) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weatherDataForeCast):

                
                self.coreDataService.updateFC(with: weatherDataForeCast)
                self.updateFC(latitude: weatherDataForeCast.city.coord.lat, longtitude: weatherDataForeCast.city.coord.lon)

            case .failure(let error):

                print("Ошибка при получении данных о погоде FORECAST: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateFC(latitude:Double,longtitude:Double) {
        guard let dataModels = coreDataService.fetchTwelveElements(latitude: latitude, longtitude: longtitude) else { return }
        print("\(dataModels.count) - count FC")
        rowForeCast = dataModels.compactMap ({ model in
            return ForeCastModel(id: model.id,
                                 temp: model.temp,
                                 icon: model.icon ?? "clear sky",
                                 time: extractTime(from: model.dtTxt ?? "00:00")
            )
                
        })
        
        foreCastList = rowForeCast
        limitedArray = Array(foreCastList.suffix(12))

        self.loadForeCastFour?()
       
    }
    
    //MARK: -  TEN
    
    func loadWeatherInfoForeCastTen(latitude: Double, longitude: Double) {
        
        networkService.fetchWeatherTenDays(for: latitude, for: longitude) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weatherDataForeCast):
                
                
                self.coreDataService.updateFCT(with: weatherDataForeCast)
                self.updateFCT(latitude: weatherDataForeCast.lat, longtitude: weatherDataForeCast.lon)
            case .failure(let error):
                
                print("Ошибка при получении данных о погоде TEN: \(error.localizedDescription)")
            }
        }
        
    }
    
    private func updateFCT(latitude: Double,longtitude: Double) {
        guard let dataModels = coreDataService.fetchSevenElements(latitude: latitude, longitude: longtitude) else { return }
        print("\(dataModels.count) - count FCT")
        rowTenForeCast = dataModels.compactMap ({ model in
            return TenDaysRawModel(id: model.idT,
                                   description: model.descriptionT ?? "clear sky",
                                   temp: model.tempT,
                                   tempMin: convertToCelsius(model.tempMin),
                                   tempMax: convertToCelsius(model.tempMax)
                                   
            )
        })
        foreCastListTen = rowTenForeCast
        limitedArrayTen = Array(foreCastListTen.suffix(7))
        
        self.loadForeCastTen?()
    }
    
    //MARK: - UI LOAD DATA
    
    func cellCount() -> Int{
        return limitedArray.count
    }
    
    
    func itemForCell(index: Int) -> ForeCastModel {
        return limitedArray[index]
    }
    
    func itemForCellTen(index: Int) -> TenDaysRawModel {
        return limitedArrayTen[index]
    }
    
    
    private func convertToCelsius(_ tempKelvin: Double) -> Double {
        return ((tempKelvin - 273.15) * 10).rounded(.toNearestOrAwayFromZero) / 10
    }
    
    private func extractTime(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" 
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        } else {
            return "Вчера"
        }
    }
    
}
