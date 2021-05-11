//
//  RecentSearch+CoreDataProperties.swift
//  
//
//  Created by Panchami Rao on 07/05/21.
//
//

import Foundation
import CoreData


extension RecentSearch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentSearch> {
        return NSFetchRequest<RecentSearch>(entityName: "RecentSearch")
    }

    @NSManaged public var siteUrl: String?
    @NSManaged public var date: Date?

}
