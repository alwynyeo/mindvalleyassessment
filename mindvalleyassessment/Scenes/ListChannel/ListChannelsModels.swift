//
//  ListChannelsModels.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

// MARK: - ListChannels Enum
enum ListChannels {
    enum LoadData {
        struct Request {}

        struct Response {
            let newEpisodeData: NewEpisode?
            let channelData: Channel?
            let categoryData: Category?
        }

        struct ViewModel {
            let sections: [Section]
        }
    }

    enum RefreshData {
        struct Request {}
    }

    struct Section: Hashable {
        let id: String
        var imageUrl: URL? = nil
        let title: String
        var subTitle: String? = nil
        let items: [Item]
        var isSeriesType: Bool = false

        init(
            imageUrl: URL? = nil,
            title: String,
            subTitle: String? = nil,
            items: [Item],
            isSeriesType: Bool = false
        ) {
            self.id = UUID().uuidString
            self.imageUrl = imageUrl
            self.title = title
            self.subTitle = subTitle
            self.items = items
            self.isSeriesType = isSeriesType
        }

        struct Item: Hashable {
            let id: String
            var imageUrl: URL? = nil
            let title: String
            var subTitle: String? = nil

            init(
                imageUrl: URL? = nil,
                title: String,
                subTitle: String? = nil
            ) {
                self.id = UUID().uuidString
                self.imageUrl = imageUrl
                self.title = title
                self.subTitle = subTitle
            }
        }
    }
}
