//
//  ListChannelPresenter.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

// MARK: - ListChannelPresentationLogic Protocol
protocol ListChannelPresentationLogic {
    func presentLoadedData(response: ListChannel.LoadData.Response)
}

// MARK: - ListChannelPresenter Class
final class ListChannelPresenter {
    // MARK: - Declarations

    weak var viewController: ListChannelDisplayLogic?

    // MARK: - Object Lifecycle

    init() {}

    // MARK: - Helpers

    private func getNewEpisodeSections(from response: ListChannel.LoadData.Response) -> [ListChannel.Section] {
        let newEpisodeData = response.newEpisodeData

        guard let data = newEpisodeData?.data else { return [] }

        let newEpisodes = data.media ?? []
        let sectionTitle = "New Episodes"
        var sections: [ListChannel.Section] = []
        var sectionItems: [ListChannel.Section.Item] = []

        newEpisodes.forEach { newEpisode in
            let imageUrlString = newEpisode.coverAsset?.url ?? ""
            let imageUrl = URL(string: imageUrlString)
            let title = newEpisode.title ?? ""
            let subTitle = newEpisode.channel?.title ?? ""
            let item = ListChannel.Section.Item(
                imageUrl: imageUrl,
                title: title,
                subTitle: subTitle
            )
            sectionItems.append(item)
        }

        let prefixedSectionItems = Array(sectionItems.prefix(6))

        sectionItems = prefixedSectionItems

        let section = ListChannel.Section(
            title: sectionTitle,
            items: sectionItems
        )

        sections.append(section)

        return sections
    }

    private func getChannelSections(from response: ListChannel.LoadData.Response) -> [ListChannel.Section] {
        let channelData = response.channelData

        guard let data = channelData?.data else { return [] }

        let channels = data.channels ?? []
        var sections: [ListChannel.Section] = []

        channels.forEach { channel in
            let sectionImageUrlString = channel.coverAsset?.url ?? ""
            let sectionImageUrl = URL(string: sectionImageUrlString)
            let sectionTitle = channel.title ?? ""
            let mediaCount = channel.mediaCount ?? 0
            let episodeString = mediaCount == 1 ? "episode" : "episodes"
            let sectionSubTitle = "\(mediaCount) \(episodeString)"

            let sectionItemSeries = channel.series ?? []
            let isSectionSeriesType = sectionItemSeries.isNotEmpty
            let items = channel.latestMedia ?? []
            var sectionItems: [ListChannel.Section.Item] = []

            items.forEach { item in
                let imageUrlString = item.coverAsset?.url ?? ""
                let imageUrl = URL(string: imageUrlString)
                let title = item.title ?? ""
                let sectionItem = ListChannel.Section.Item(
                    imageUrl: imageUrl,
                    title: title
                )
                sectionItems.append(sectionItem)
            }

            let prefixedSectionItems = Array(sectionItems.prefix(6))

            sectionItems = prefixedSectionItems

            let section = ListChannel.Section(
                imageUrl: sectionImageUrl,
                title: sectionTitle, 
                subTitle: sectionSubTitle,
                items: sectionItems,
                isSeriesType: isSectionSeriesType
            )

            sections.append(section)
        }

        return sections
    }

    private func getCategorySections(from response: ListChannel.LoadData.Response) -> [ListChannel.Section] {
        let categoryData = response.categoryData

        guard let data = categoryData?.data else { return [] }

        let categories = data.categories ?? []
        let sectionTitle = "Browse by categories"
        var sections: [ListChannel.Section] = []
        var sectionItems: [ListChannel.Section.Item] = []

        categories.forEach { category in
            let name = category.name ?? ""
            let item = ListChannel.Section.Item(
                title: name
            )
            sectionItems.append(item)
        }

        let section = ListChannel.Section(
            title: sectionTitle,
            items: sectionItems
        )

        sections.append(section)

        return sections
    }
}

// MARK: - ListChannelPresentationLogic Extension
extension ListChannelPresenter: ListChannelPresentationLogic {
    func presentLoadedData(response: ListChannel.LoadData.Response) {
        let newEpisodeSections = getNewEpisodeSections(from: response)
        let channelSections = getChannelSections(from: response)
        let categorySections = getCategorySections(from: response)

        var sections: [ListChannel.Section] = []

        sections.append(contentsOf: newEpisodeSections)
        sections.append(contentsOf: channelSections)
        sections.append(contentsOf: categorySections)

        let viewModel = ListChannel.LoadData.ViewModel(sections: sections)

        viewController?.displayLoadedData(viewModel: viewModel)
    }
}
