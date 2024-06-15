//
//  ListChannelsPresenter.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

// MARK: - ListChannelsPresentationLogic Protocol
protocol ListChannelsPresentationLogic {
    func presentLoadedData(response: ListChannels.LoadData.Response)
}

// MARK: - ListChannelsPresenter Class
final class ListChannelsPresenter {
    // MARK: - Declarations

    weak var viewController: ListChannelsDisplayLogic?

    // MARK: - Object Lifecycle

    init() {}

    // MARK: - Helpers
    private func getNewEpisodeSections(from response: ListChannels.LoadData.Response) -> [ListChannels.Section] {
        let newEpisodeData = response.newEpisodeData

        guard let data = newEpisodeData?.data else { return [] }

        guard let newEpisodes = data.media else { return [] }

        guard newEpisodes.isNotEmpty else { return [] }

        let prefixedNewEpisodes = newEpisodes.prefix(6)

        let sectionTitle = "New Episodes"

        let sectionItems = prefixedNewEpisodes.map { newEpisode -> ListChannels.Section.Item in
            let imageUrlString = newEpisode.coverAsset?.url ?? ""
            let imageUrl = URL(string: imageUrlString)
            let title = newEpisode.title ?? ""
            let subTitle = newEpisode.channel?.title ?? ""

            return ListChannels.Section.Item(
                imageUrl: imageUrl,
                title: title,
                subTitle: subTitle
            )
        }

        let section = ListChannels.Section(
            title: sectionTitle,
            items: sectionItems
        )

        return [section]
    }

    private func getChannelSections(from response: ListChannels.LoadData.Response) -> [ListChannels.Section] {
        let channelData = response.channelData

        guard let data = channelData?.data else { return [] }

        guard let channels = data.channels else { return [] }

        guard channels.isNotEmpty else { return [] }

        let sections = channels.map { channel -> ListChannels.Section in
            let sectionImageUrlString = channel.coverAsset?.url ?? ""
            let sectionImageUrl = URL(string: sectionImageUrlString)
            let sectionTitle = channel.title ?? ""

            let mediaCount = channel.mediaCount ?? 0
            let episodeString = mediaCount == 1 ? "episode" : "episodes"
            let sectionSubTitle = "\(mediaCount) \(episodeString)"

            let sectionItemSeries = channel.series ?? []
            let isSectionSeriesType = sectionItemSeries.isNotEmpty

            let latestMedia = channel.latestMedia ?? []
            let prefixedLatestMedia = latestMedia.prefix(6)
            let sectionItems = prefixedLatestMedia.map { latestMedia -> ListChannels.Section.Item in
                let imageUrlString = latestMedia.coverAsset?.url ?? ""
                let imageUrl = URL(string: imageUrlString)
                let title = latestMedia.title ?? ""
                let sectionItem = ListChannels.Section.Item(
                    imageUrl: imageUrl,
                    title: title
                )
                return sectionItem
            }

            let section = ListChannels.Section(
                imageUrl: sectionImageUrl,
                title: sectionTitle,
                subTitle: sectionSubTitle,
                items: sectionItems,
                isSeriesType: isSectionSeriesType
            )

            return section
        }

        return sections
    }

    private func getCategorySections(from response: ListChannels.LoadData.Response) -> [ListChannels.Section] {
        let categoryData = response.categoryData

        guard let data = categoryData?.data else { return [] }

        guard let categories = data.categories else { return [] }

        guard categories.isNotEmpty else { return [] }

        let sectionTitle = "Browse by categories"

        let sectionItems = categories.map { category -> ListChannels.Section.Item in
            let name = category.name ?? ""
            let item = ListChannels.Section.Item(title: name)
            return item
        }

        let section = ListChannels.Section(
            title: sectionTitle,
            items: sectionItems
        )

        return [section]
    }
}

// MARK: - ListChannelsPresentationLogic Extension
extension ListChannelsPresenter: ListChannelsPresentationLogic {
    func presentLoadedData(response: ListChannels.LoadData.Response) {
        let newEpisodeSections = getNewEpisodeSections(from: response)
        let channelSections = getChannelSections(from: response)
        let categorySections = getCategorySections(from: response)

        let sections = newEpisodeSections + channelSections + categorySections

        let viewModel = ListChannels.LoadData.ViewModel(sections: sections)

        viewController?.displayLoadedData(viewModel: viewModel)
    }
}
