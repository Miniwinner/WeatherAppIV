//
//  TenForeCast+CoreDataProperties.swift
//  WeatherAppIV
//
//  Created by Александр Кузьминов on 16.12.23.
//
//

import Foundation
import CoreData


extension TenForeCast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TenForeCast> {
        return NSFetchRequest<TenForeCast>(entityName: "TenForeCast")
    }

    @NSManaged public var idT: Int64
    @NSManaged public var descriptionT: String?
    @NSManaged public var tempMin: Double
    @NSManaged public var tempMax: Double
    @NSManaged public var tempT: Double
    @NSManaged public var longtitude: Double
    @NSManaged public var latitude: Double
}

extension TenForeCast : Identifiable {

}
