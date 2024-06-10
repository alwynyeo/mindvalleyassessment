//
//  NewEpisode.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/8/24.
//

struct NewEpisode: Decodable {
    let data: Data

    struct Data: Decodable {
        let media: [Media]
    }

    struct Media: Decodable {
        let type: String
        let title: String
        let coverAsset: CoverAsset
        let channel: Channel
    }

    struct CoverAsset: Decodable {
        let url: String
    }

    struct Channel: Decodable {
        let title: String
    }
}
