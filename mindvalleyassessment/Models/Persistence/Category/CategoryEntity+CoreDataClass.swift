//
//  CategoryEntity+CoreDataClass.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/13/24.
//
//

import CoreData

public class CategoryEntity: NSManagedObject {
    // MARK: - Helpers

    func mapToCategory() -> Category.Category {
        let entity = self
        let name = entity.name
        let category = Category.Category(name: name)
        return category
    }

    func set(category: Category.Category, at index: Int) {
        let entity = self
        let id = Int64(index)
        let name = category.name

        entity.id = id
        entity.name = name
    }
}
