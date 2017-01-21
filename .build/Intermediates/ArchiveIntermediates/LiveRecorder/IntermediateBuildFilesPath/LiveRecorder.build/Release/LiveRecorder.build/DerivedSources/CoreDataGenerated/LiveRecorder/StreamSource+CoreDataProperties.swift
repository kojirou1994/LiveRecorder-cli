//
//  StreamSource+CoreDataProperties.swift
//  
//
//  Created by 王宇 on 2017/1/18.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension StreamSource {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StreamSource> {
        return NSFetchRequest<StreamSource>(entityName: "StreamSource");
    }

    @NSManaged public var name: String?
    @NSManaged public var roomId: Int64
    @NSManaged public var website: String?

}
