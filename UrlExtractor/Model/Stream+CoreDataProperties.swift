//
//  Stream+CoreDataProperties.swift
//  
//
//  Created by Panchami Rao on 02/05/21.
//
//

import Foundation
import CoreData

extension Stream {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stream> {
        return NSFetchRequest<Stream>(entityName: "Stream")
    }

    @NSManaged public var url: String?
    @NSManaged public var mainChannel: String?

}
