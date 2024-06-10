//
//  Channel.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/8/24.
//

struct Channel: Decodable {
    let data: Data

    struct Data: Decodable {
        let channels: [Channel]
    }

    struct Channel: Decodable {
        let title: String
        let series: [Series]
        let mediaCount: Int
        let latestMedia: [LatestMedia]
        let id: String
        let iconAsset: IconAsset
        let coverAsset: CoverAsset
    }

    struct Series: Decodable {
        let title: String
        let coverAsset: CoverAsset
    }

    struct LatestMedia: Decodable {
        let type: String
        let title: String
        let coverAsset: CoverAsset
    }

    struct IconAsset: Decodable {
        let thumbnailUrl: String
    }

    struct CoverAsset: Decodable {
        let url: String
    }
}
