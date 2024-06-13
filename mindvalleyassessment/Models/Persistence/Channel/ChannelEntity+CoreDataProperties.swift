//
//  ChannelEntity+CoreDataProperties.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/13/24.
//
//

import Foundation
import CoreData


extension ChannelEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChannelEntity> {
        return NSFetchRequest<ChannelEntity>(entityName: "ChannelEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var imageUrlString: String?
    @NSManaged public var mediaCount: Int64
    @NSManaged public var series: String?
    @NSManaged public var title: String?
    @NSManaged public var channelItems: NSOrderedSet?

}

// MARK: Generated accessors for channelItems
extension ChannelEntity {

    @objc(insertObject:inChannelItemsAtIndex:)
    @NSManaged public func insertIntoChannelItems(_ value: ChannelSubEntity, at idx: Int)

    @objc(removeObjectFromChannelItemsAtIndex:)
    @NSManaged public func removeFromChannelItems(at idx: Int)

    @objc(insertChannelItems:atIndexes:)
    @NSManaged public func insertIntoChannelItems(_ values: [ChannelSubEntity], at indexes: NSIndexSet)

    @objc(removeChannelItemsAtIndexes:)
    @NSManaged public func removeFromChannelItems(at indexes: NSIndexSet)

    @objc(replaceObjectInChannelItemsAtIndex:withObject:)
    @NSManaged public func replaceChannelItems(at idx: Int, with value: ChannelSubEntity)

    @objc(replaceChannelItemsAtIndexes:withChannelItems:)
    @NSManaged public func replaceChannelItems(at indexes: NSIndexSet, with values: [ChannelSubEntity])

    @objc(addChannelItemsObject:)
    @NSManaged public func addToChannelItems(_ value: ChannelSubEntity)

    @objc(removeChannelItemsObject:)
    @NSManaged public func removeFromChannelItems(_ value: ChannelSubEntity)

    @objc(addChannelItems:)
    @NSManaged public func addToChannelItems(_ values: NSOrderedSet)

    @objc(removeChannelItems:)
    @NSManaged public func removeFromChannelItems(_ values: NSOrderedSet)

}

extension ChannelEntity : Identifiable {

}
