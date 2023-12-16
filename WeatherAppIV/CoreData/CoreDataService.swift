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
    
    func fetchOneElement(name: String) -> Weather? {
        // Создаем запрос в базу данных, который возвращает все элементы
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        // Добавляем параметр для запроса, чтобы получить определенный элемент
        request.predicate = NSPredicate(format: "id == %@", name)
        
        do {
            let model = try context.fetch(request)
            
            guard !model.isEmpty else {
                return nil
            }
            return model[0]
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
   
    func update(with stock: CurrentWeather) {
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        
        // Проверка на nil для stock.sys.id
        guard let stockSysId = stock.sys?.id else {
            print("Отсутствует id в stock.sys")
            return
        }
        request.predicate = NSPredicate(format: "id == %ld", stockSysId)
        
        do {
            let models = try context.fetch(request)
            if let existingModel = models.first {
                existingModel.name = stock.name
                existingModel.descriptionW = stock.weather.first?.description
                // Проверка на nil для stock.main.temp
                if let temp = stock.main?.temp {
                    existingModel.temp = temp
                } else {
                    print("Отсутствует температура в stock.main")
                    // Здесь можно установить значение по умолчанию, если это необходимо
                }
                
                existingModel.id = Int64(stockSysId)
                
                try context.save()
                print("\(stockSysId) update ✅✅✅")
            } else {
                // Если модель не существует, добавьте новую
                addStock(stock: stock)
            }
        } catch {
            print("Error updating stock: \(error.localizedDescription)")
        }
    }

    
    
    func fetchStock() -> [Weather]? {
        let fetchRequest: NSFetchRequest<Weather> = Weather.fetchRequest()
        
        do {
            let models = try context.fetch(fetchRequest)
            return models
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func addStock(stock: CurrentWeather) {
        let entity = NSEntityDescription.entity(forEntityName: "Weather", in: context)
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! Weather
        
        taskObject.name = stock.name
        taskObject.temp = stock.main?.temp ?? 0
        taskObject.id = Int64(stock.sys?.id ?? 111)
        taskObject.descriptionW = stock.weather.first?.description
        taskObject.maxTemp = stock.main?.tempMax ?? 0
        taskObject.minTemp = stock.main?.tempMin ?? 0
        do {
            try context.save()
            print("\(stock.sys?.id ?? 101) add ✅✅✅")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - FORECAST
    
    func fetchOneElementFC(name: String) -> ForeCast? {
        // Создаем запрос в базу данных, который возвращает все элементы
        let request: NSFetchRequest<ForeCast> = ForeCast.fetchRequest()
        // Добавляем параметр для запроса, чтобы получить определенный элемент
        request.predicate = NSPredicate(format: "id == %@", name)
        
        do {
            let model = try context.fetch(request)
            
            guard !model.isEmpty else {
                return nil
            }
            return model[0]
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    func updateFC(with stock: ForeCastWeather) {
        
        guard let forecastItems = stock.list else {
            print("Нет данных в stock.list")
            return
        }

        for forecastItem in forecastItems {
            let request: NSFetchRequest<ForeCast> = ForeCast.fetchRequest()
            
           
            
            request.predicate = NSPredicate(format: "id == %ld", forecastItem.dt ?? 0)

            do {
                let models = try context.fetch(request)
                if let existingModel = models.first {
                    
                    existingModel.temp = forecastItem.main.temp ?? 1
                    existingModel.id = Int64(forecastItem.dt ?? 0)

                    if  let weatherDescription = forecastItem.weather.first?.description?.rawValue {
                        existingModel.icon = weatherDescription
                    } else {
                        print("Отсутствуют данные о погоде для данного прогноза")
                        existingModel.icon = "nil"
                    }
                    
                    try context.save()
                } else {
                    
                    addStockFC(forecastItem: forecastItem)
                }
            } catch {
                print("Error updating stock: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchStockFC() -> [ForeCast]? {
        let fetchRequest: NSFetchRequest<ForeCast> = ForeCast.fetchRequest()
        
        do {
            let models = try context.fetch(fetchRequest)
            return models
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    
    func addStockFC(forecastItem: List) {
        let entity = NSEntityDescription.entity(forEntityName: "ForeCast", in: context)
        let newForecast = NSManagedObject(entity: entity!, insertInto: context) as! ForeCast
        
        newForecast.temp = forecastItem.main.temp ?? 1
        newForecast.id = Int64(forecastItem.dt ?? 0)
        if let weatherDescription = forecastItem.weather.first {
            newForecast.icon = weatherDescription.description?.rawValue
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    func updateFCT(with stock: TenDaysWeather) {
        
        guard let forecastItems = stock.daily else {
            print("Нет данных в stock.daily")
            return
        }
//        print(forecastItems)
        for forecastItem in forecastItems {
//print(forecastItem)
        let request: NSFetchRequest<TenForeCast> = TenForeCast.fetchRequest()
               
            request.predicate = NSPredicate(format: "idT == %ld", forecastItem.dt ?? 0)
        
        do {
            let models = try context.fetch(request)
            if let existingModel = models.first {
            
                existingModel.idT = Int64(forecastItem.dt ?? 0)
                existingModel.tempT = forecastItem.temp?.day ?? 1010
                existingModel.descriptionT = forecastItem.weather.first?.description ?? "GOOF"
                
                try context.save()
                print("\(forecastItem.dt ?? 0) update ✅✅✅")
            } else {
                addStockFCT(forecastItem: forecastItem)
            }
        } catch {
            print("Error updating stock: \(error.localizedDescription)")
        }
        }
    }
    
    func fetchStockFCT() -> [TenForeCast]? {
        let fetchRequest: NSFetchRequest<TenForeCast> = TenForeCast.fetchRequest()
        
        do {
            let models = try context.fetch(fetchRequest)
            return models
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func addStockFCT(forecastItem: Daily) {
        let entity = NSEntityDescription.entity(forEntityName: "TenForeCast", in: context)
        let newForecast = NSManagedObject(entity: entity!, insertInto: context) as! TenForeCast
        
        newForecast.idT = Int64(forecastItem.dt ?? 1123)
        newForecast.tempT = forecastItem.temp?.day ?? 1010
        newForecast.descriptionT = forecastItem.weather.first?.description ?? "GOOF"
        print(newForecast)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
