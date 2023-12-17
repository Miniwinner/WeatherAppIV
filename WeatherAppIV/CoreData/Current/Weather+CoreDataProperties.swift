//
//  Weather+CoreDataProperties.swift
//  WeatherAppIV
//
//  Created by Александр Кузьминов on 11.12.23.
//
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }

    @NSManaged public var base: String?
    @NSManaged public var visibility: Decimal
    @NSManaged public var dt: Decimal
    @NSManaged public var timezone: Decimal
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var cod: Decimal
    @NSManaged public var temp: Double
    @NSManaged public var minTemp: Double
    @NSManaged public var maxTemp: Double
    @NSManaged public var descriptionW: String?
    @NSManaged public var longtitude: Double
    @NSManaged public var latitude: Double

}

extension Weather : Identifiable {

}
