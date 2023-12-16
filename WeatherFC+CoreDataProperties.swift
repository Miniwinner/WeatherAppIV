//
//  WeatherFC+CoreDataProperties.swift
//  WeatherAppIV
//
//  Created by Александр Кузьминов on 14.12.23.
//
//

import Foundation
import CoreData


extension ForeCast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForeCast> {
        return NSFetchRequest<ForeCast>(entityName: "ForeCast")
    }

    @NSManaged public var temp: Double
    @NSManaged public var icon: String?
    @NSManaged public var id: Int64
   


}

extension ForeCast : Identifiable {

}
