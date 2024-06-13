//
//  NewEpisodeEntity+CoreDataProperties.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/13/24.
//
//

import Foundation
import CoreData


extension NewEpisodeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewEpisodeEntity> {
        return NSFetchRequest<NewEpisodeEntity>(entityName: "NewEpisodeEntity")
    }

    @NSManaged public var channelTitle: String?
    @NSManaged public var id: Int64
    @NSManaged public var imageUrlString: String?
    @NSManaged public var title: String?

}

extension NewEpisodeEntity : Identifiable {

}
