//
//  Collection+Extension.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/11/24.
//

import Foundation

extension Collection {

    /**
     A Boolean value indicating whether the collection is not empty.

     - Returns: `true` if the collection is not empty; otherwise, `false`.

     - Example:
     ```swift
     let numbers = [1, 2, 3]
     print(numbers.isNotEmpty) // true

     let emptyCollection: [Int] = []
     print(emptyCollection.isNotEmpty) // false
     ```

     - Complexity: O(1)
     */
    var isNotEmpty: Bool { return !self.isEmpty }
}
