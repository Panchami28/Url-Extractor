//
//  FavoriteStreams+CoreDataProperties.swift
//  
//
//  Created by Panchami Rao on 04/05/21.
//
//

import Foundation
import CoreData


extension FavoriteStreams {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteStreams> {
        return NSFetchRequest<FavoriteStreams>(entityName: "FavoriteStreams")
    }

    @NSManaged public var mainChannel: String?
    @NSManaged public var url: String?
    @NSManaged public var heartName: String?

}
