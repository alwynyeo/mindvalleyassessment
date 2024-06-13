//
//  CategoryEntity+CoreDataProperties.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/13/24.
//
//

import CoreData

extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}

extension CategoryEntity : Identifiable {

}
