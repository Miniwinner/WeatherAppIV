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
    
    
    var maxID:Int = 0
    
    var onWeatherInfoLoaded: (() -> Void)?
    var loadCollection: (() -> Void)?
    var loadCollection2: (() -> Void)?
    let hours:[String] = ["15:00", "18:00", "", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40","41","42","43","44","45"]
    
    let mainHours:[String] = ["15:00", "18:00", "21:00", "00:00", "06:00", "09:00", "12:00", "15:00", "18:00", "21:00", "00:00", "06:00"]
    
    let days:[String] = ["Пн","Вт","Ср","Чт","Пт","Сб","Вс"]
    
    func loadWeatherInfo(latitude: Double, longitude: Double) {
   
        networkService.fetchWeatherData(for: latitude, for: longitude) { [weak self] result in
            guard let self = self else { return }
            maxID += 1
            switch result {
            case .success(let weatherData):
               // print(weatherData)
                // Использование полученных данных о погоде
                self.coreDataService.update(with: weatherData)
                 // Обновление интерфейса после получения данных
                self.onWeatherInfoLoaded?()
            case .failure(let error):
                // Обработка ошибки
                print("Ошибка при получении данных о погоде CURRENT: \(error.localizedDescription)")
            }
        }
        self.update()
    }

    func loadWeatherInfoForeCast(latitude: Double, longitude: Double) {
        
        networkService.fetchWeatherFourDays(for: latitude, for: longitude) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weatherDataForeCast):
               // print(weatherData)
                // Использование полученных данных о погоде
                self.coreDataService.updateFC(with: weatherDataForeCast)
                 // Обновление интерфейса после получения данных
               // self.onWeatherInfoForeCastLoaded?()
            case .failure(let error):
                // Обработка ошибки
                print("Ошибка при получении данных о погоде FORECAST: \(error.localizedDescription)")
            }
        }
        self.updateFC()
    }
    
    func loadWeatherInfoForeCastTen(latitude: Double, longitude: Double) {
        
        networkService.fetchWeatherTenDays(for: latitude, for: longitude) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weatherDataForeCast):
//                print(weatherDataForeCast)
                // Использование полученных данных о погоде
                self.coreDataService.updateFCT(with: weatherDataForeCast)
                 // Обновление интерфейса после получения данных
               // self.onWeatherInfoForeCastLoaded?()
            case .failure(let error):
                // Обработка ошибки
                print("Ошибка при получении данных о погоде TEN: \(error.localizedDescription)")
            }
        }
        self.updateFCT()
    }
    
    
    
    private func update() {
        guard let dataModels = coreDataService.fetchStock() else { return }
        rowModels = dataModels.compactMap ({ model in
            return RawModel(name: model.name ?? "NEVERLAND",
                            temp: ((model.temp - 273.15) * 10).rounded(.toNearestOrAwayFromZero) / 10,
                            id: model.id,
                            description: model.descriptionW ?? "GOOD",
                            minTemp: ((model.minTemp - 273.15) * 10).rounded(.toNearestOrAwayFromZero) / 10,
                            maxTemp: ((model.maxTemp - 273.15) * 10).rounded(.toNearestOrAwayFromZero) / 10
            )
            
        })
        currentList = rowModels
//        print(dataModels)
    }
    
    private func updateFC() {
        guard let dataModels = coreDataService.fetchStockFC() else { return }
        //print(dataModels.count)
        rowForeCast = dataModels.compactMap ({ model in
            return ForeCastModel(id: model.id,
                                 temp: model.temp,
                                 icon: model.icon ?? "clear sky" )
            
        })
        
        foreCastList = rowForeCast
        limitedArray = Array(foreCastList.prefix(12))
//        print(foreCastList.count)
//        print(limitedArray.count)
        self.loadCollection2?()
       
    }
    
    private func updateFCT() {
        guard let dataModels = coreDataService.fetchStockFCT() else { return }
        print(dataModels.count)
        rowTenForeCast = dataModels.compactMap ({ model in
            return TenDaysRawModel(id: model.idT,
                                   description: model.descriptionT ?? "clear sky",
                                   temp: model.tempT)
            
        })
        
        foreCastListTen = rowTenForeCast
        limitedArrayTen = Array(foreCastListTen.prefix(7))
//        print(dataModels)
//        print(limitedArrayTen)
        self.loadCollection2?()
       
    }
    
    func cellCount() -> Int{
        return limitedArray.count
    }
    
    
    func itemForCell(index: Int) -> ForeCastModel {
        return limitedArray[index]
    }
    
    func itemForCellTen(index: Int) -> TenDaysRawModel {
        return limitedArrayTen[index]
    }
    
}
