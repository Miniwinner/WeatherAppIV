//
//  CoreDataService.swift
//  WeatherAppIV
//
//  Created by Александр Кузьминов on 11.12.23.
//

import Foundation
import CoreData
import UIKit

class CoreDataService {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    //MARK: - CURRENT
    func fetchOneElement(latitude:Double,longtitude:Double) -> Weather? {
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        request.predicate = NSPredicate(format: "latitude == %lf AND longtitude == %lf", latitude, longtitude)
        do {
            let models = try context.fetch(request)
            return models[0]
        } catch {
            print("Ошибка при извлечении данных: \(error.localizedDescription)")
            return nil
        }
    }
    
    
   
    func update(with stock: CurrentWeather) {
       

        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        request.predicate = NSPredicate(format: "latitude == %lf AND longtitude == %lf", stock.coord.lat, stock.coord.lon)

        do {
            let models = try context.fetch(request)
            if let existingModel = models.first {
                existingModel.latitude = stock.coord.lat
                existingModel.longtitude = stock.coord.lon
                existingModel.name = stock.name ?? "Unknown"
                existingModel.descriptionW = stock.weather.first?.description ?? "Description not available"
                
                if let temp = stock.main?.temp {
                    existingModel.temp = temp
                } else {
                    print("Отсутствует температура в stock.main")
                    return
                }
                

                try context.save()
                print("\(stock.coord.lat) \(stock.coord.lon) update CU ✅✅✅")
            } else {
                
                addStock(stock: stock)
            }
        } catch {
            print("Error updating stock: \(error.localizedDescription)")
        }
    }

    func addStock(stock: CurrentWeather) {
        guard let sysId = stock.sys?.id,
              let temp = stock.main?.temp,
              let tempMax = stock.main?.tempMax,
              let tempMin = stock.main?.tempMin,
              let weatherDescription = stock.weather.first?.description else {
            
            print("Отсутствуют необходимые данные для создания нового объекта погоды")
            return
        }

        let newForecast = Weather(context: context)
        newForecast.latitude = stock.coord.lat
        newForecast.longtitude = stock.coord.lon
        newForecast.name = stock.name
        newForecast.temp = temp
        newForecast.id = Int64(sysId)
        newForecast.descriptionW = weatherDescription
        newForecast.maxTemp = tempMax
        newForecast.minTemp = tempMin

        do {
            try context.save()
            print("\(stock.coord.lat) \(stock.coord.lon) add CU ✅✅✅")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - FORECAST FOUR
    
    func fetchTwelveElements(latitude:Double,longtitude:Double) -> [ForeCast]? {
        let request: NSFetchRequest<ForeCast> = ForeCast.fetchRequest()
        request.predicate = NSPredicate(format: "latitude == %lf AND longtitude == %lf", latitude, longtitude)
        request.fetchLimit = 12
        do {
            let models = try context.fetch(request)
            return models
        } catch {
            print("Ошибка при извлечении данных: \(error.localizedDescription)")
            return []
        }
    }
    
    
    func updateFC(with stock: ForeCastWeather) {
        guard let forecastItems = stock.list?.prefix(12) else {
            print("Нет данных в stock.list")
            return
        }

        for forecastItem in forecastItems {
            guard let dt = forecastItem.dt,
                  let temp = forecastItem.main.temp,
                  let weatherDescription = forecastItem.weather.first?.description?.rawValue else {
                print("Отсутствует необходимая информация для элемента прогноза")
                continue 
            }

            let request: NSFetchRequest<ForeCast> = ForeCast.fetchRequest()
            request.predicate = NSPredicate(format: "latitude == %lf AND longtitude == %lf AND dtTxt == %@", stock.city.coord.lat,stock.city.coord.lon,forecastItem.dtTxt)

            do {
                let models = try context.fetch(request)
                if let existingModel = models.first {
                    existingModel.latitude = stock.city.coord.lat
                    existingModel.longtitude = stock.city.coord.lon
                    existingModel.temp = temp
                    existingModel.dtTxt = forecastItem.dtTxt
                    existingModel.id = Int64(dt)
                    existingModel.icon = weatherDescription
                    try context.save()
                    print("\(stock.city.coord.lat) \(stock.city.coord.lon) add FT✅✅✅")
                } else {
                    addStockFC(forecastItem: forecastItem,latitude: stock.city.coord.lat,longtitude: stock.city.coord.lon)
                }
            } catch {
                print("Error updating stock: \(error.localizedDescription)")
            }
        }
    }

    func addStockFC(forecastItem: List,latitude:Double,longtitude:Double) {
        guard let entity = NSEntityDescription.entity(forEntityName: "ForeCast", in: context),
              let dt = forecastItem.dt,
              let temp = forecastItem.main.temp,
              let weatherDescription = forecastItem.weather.first?.description?.rawValue else {
            print("Отсутствуют необходимые данные для добавления нового прогноза")
            return
        }

        let newForecast = ForeCast(entity: entity, insertInto: context)
        newForecast.temp = temp
        newForecast.id = Int64(dt)
        newForecast.icon = weatherDescription
        newForecast.latitude = latitude
        newForecast.longtitude = longtitude
        newForecast.dtTxt = forecastItem.dtTxt
        do {
            try context.save()
            print("\(latitude) \(longtitude) add FT✅✅✅")
        } catch {
            print("Не удалось сохранить новый прогноз: \(error.localizedDescription)")
        }
    }
 
   //MARK: - FORECAST TEN
    
    func fetchSevenElements(latitude: Double, longitude: Double) -> [TenForeCast]? {
        let request: NSFetchRequest<TenForeCast> = TenForeCast.fetchRequest()
        request.predicate = NSPredicate(format: "latitude == %lf AND longtitude == %lf", latitude, longitude)
        request.fetchLimit = 7

        do {
            let models = try context.fetch(request)
            return models
        } catch {
            print("Ошибка при извлечении данных: \(error.localizedDescription)")
            return []
        }
    }

    
    func updateFCT(with stock: TenDaysWeather) {
        guard let forecastItems = stock.daily?.prefix(7) else {
            print("Нет данных в stock.daily")
            return
        }
        for forecastItem in forecastItems {
            guard let temp = forecastItem.temp,
                  let weatherDescription = forecastItem.weather.first?.description else {
                print("Необходимые данные для обновления отсутствуют")
                continue
            }

            let request: NSFetchRequest<TenForeCast> = TenForeCast.fetchRequest()
            request.predicate = NSPredicate(format: "latitude == %lf AND longtitude == %lf AND idT == %ld", stock.lat, stock.lon,forecastItem.dt)

            do {
                let models = try context.fetch(request)
                if let existingModel = models.first {
                    existingModel.latitude = stock.lat
                    existingModel.longtitude = stock.lon
                    existingModel.idT = Int64(forecastItem.dt)
                    existingModel.tempT = temp.day
                    existingModel.descriptionT = weatherDescription
                    existingModel.tempMax = temp.max
                    existingModel.tempMin = temp.min
                    try context.save()
                    print("\(stock.lat) \(stock.lon) update FCT ✅✅✅")
                } else {
                    addStockFCT(forecastItem: forecastItem,longtitude: stock.lon,latitude: stock.lat )
                }
            } catch {
                print("Error updating stock: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    func addStockFCT(forecastItem: Daily,longtitude: Double,latitude: Double) {
        guard let entity = NSEntityDescription.entity(forEntityName: "TenForeCast", in: context),
              let temp = forecastItem.temp,
             
              let weatherDescription = forecastItem.weather.first?.description else {
            print("Необходимые данные для добавления отсутствуют")
            return
        }
        
     

        let newForecast = TenForeCast(entity: entity, insertInto: context)
        newForecast.idT = Int64(forecastItem.dt)
        newForecast.tempT = temp.day
        newForecast.descriptionT = weatherDescription
        newForecast.tempMin = temp.min
        newForecast.tempMax = temp.max
        newForecast.latitude = latitude
        newForecast.longtitude = longtitude
        
        do {
            try context.save()
            print("\(latitude) \(longtitude) add FCT ✅✅✅")
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
