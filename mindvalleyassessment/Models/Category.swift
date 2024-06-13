//
//  Category.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/8/24.
//

struct Category: Decodable {
    let data: Data?

    struct Data: Decodable {
        let categories: [Category]?
    }

    struct Category: Decodable {
        let name: String?
    }
}
