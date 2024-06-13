//
//  ChannelSubEntity+CoreDataProperties.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/13/24.
//
//

import Foundation
import CoreData


extension ChannelSubEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChannelSubEntity> {
        return NSFetchRequest<ChannelSubEntity>(entityName: "ChannelSubEntity")
    }

    @NSManaged public var imageUrlString: String?
    @NSManaged public var title: String?
    @NSManaged public var channel: ChannelEntity?

}

extension ChannelSubEntity : Identifiable {

}
