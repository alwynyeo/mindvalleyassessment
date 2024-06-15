//
//  ListChannelsPresenterTests.swift
//  mindvalleyassessmentTests
//
//  Created by Alwyn Yeo on 6/15/24.
//

import XCTest

@testable import mindvalleyassessment
final class ListChannelsPresenterTests: XCTestCase {

    // MARK: - Subject Under Test

    var sut: ListChannelPresenter!

    var window: UIWindow!

    // MARK: - Test Cycle

    override func setUpWithError() throws {
        try super.setUpWithError()

        window = UIWindow()
        setupListChannelsPresenter()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        window = nil
        sut = nil
    }

    // MARK: - Test Setup

    func setupListChannelsPresenter() {
        sut = ListChannelPresenter()
    }

    // MARK: - Tests

    func testPresentFetchedNewEpisodeShouldFormatFetchedDataForDisplay() {
        // Given
        let listChannelsDisplayLogicSpy = ListChannelsDisplayLogicSpy()
        sut.viewController = listChannelsDisplayLogicSpy

        // When
        let newEpisodeData = makeNewEpisode()
        let response = ListChannel.LoadData.Response(
            newEpisodeData: newEpisodeData,
            channelData: nil,
            categoryData: nil
        )

        sut.presentLoadedData(response: response)

        // Then
        let displayedSections = listChannelsDisplayLogicSpy.viewModel.sections
        displayedSections.forEach { section in
            XCTAssertEqual(section.imageUrl?.absoluteString, nil, "Presenting fetched new episode should properly format image url")
            XCTAssertEqual(section.title, "New Episodes", "Presenting fetched new episode should properly format title")
            XCTAssertEqual(section.subTitle, nil, "Presenting fetched new episode should properly format subtitle")
            XCTAssertEqual(section.items.count, 4, "Presenting fetched new episode should properly format items")
            XCTAssertEqual(section.isSeriesType, false, "Presenting fetched new episode should properly format series type")
        }
    }

    func testPresentFetchedChannelShouldFormatFetchedChannelForDisplay() {
        // Given
        let listChannelsDisplayLogicSpy = ListChannelsDisplayLogicSpy()
        sut.viewController = listChannelsDisplayLogicSpy

        // When
        let channelData = makeChannel()
        let response = ListChannel.LoadData.Response(
            newEpisodeData: nil,
            channelData: channelData,
            categoryData: nil
        )

        sut.presentLoadedData(response: response)

        // Then
        let displayedSections = listChannelsDisplayLogicSpy.viewModel.sections
        displayedSections.forEach { section in
            XCTAssertEqual(section.imageUrl?.absoluteString, "channelSectionImageUrl", "Presenting fetched channel should properly format image url")
            XCTAssertEqual(section.title, "channelSectionTitle", "Presenting fetched channel should properly format title")
            XCTAssertEqual(section.subTitle, "55 episodes", "Presenting fetched channel should properly format subtitle")
            XCTAssertEqual(section.items.count, 4, "Presenting fetched channel should properly format items")
            XCTAssertEqual(section.isSeriesType, true, "Presenting fetched channel should properly format series type")
        }
    }

    func testPresentFetchedCategoryShouldFormatFetchedCategoryForDisplay() {
        // Given
        let listChannelsDisplayLogicSpy = ListChannelsDisplayLogicSpy()
        sut.viewController = listChannelsDisplayLogicSpy

        // When
        let categoryData = makeCategory()
        let response = ListChannel.LoadData.Response(
            newEpisodeData: nil,
            channelData: nil,
            categoryData: categoryData
        )

        sut.presentLoadedData(response: response)

        // Then
        let displayedSections = listChannelsDisplayLogicSpy.viewModel.sections
        displayedSections.forEach { section in
            XCTAssertEqual(section.imageUrl?.absoluteString, nil, "Presenting fetched category should properly format image url")
            XCTAssertEqual(section.title, "Browse by categories", "Presenting fetched category should properly format title")
            XCTAssertEqual(section.subTitle, nil, "Presenting fetched category should properly format subtitle")
            XCTAssertEqual(section.items.count, 5, "Presenting fetched category should properly format items")
            XCTAssertEqual(section.isSeriesType, false, "Presenting fetched category should properly format series type")
        }
    }

    func testPresentFetchedCategoryShouldAskViewControllerToDisplayFetchedData() {
        // Given
        let listChannelsDisplayLogicSpy = ListChannelsDisplayLogicSpy()
        sut.viewController = listChannelsDisplayLogicSpy

        // When
        let newEpisodeData = makeNewEpisode()
        let channelData = makeChannel()
        let categoryData = makeCategory()
        let response = ListChannel.LoadData.Response(
            newEpisodeData: newEpisodeData,
            channelData: channelData,
            categoryData: categoryData
        )

        sut.presentLoadedData(response: response)

        // Then
        XCTAssert(listChannelsDisplayLogicSpy.displayFetchedDataCalled, "Presenting fetched data should ask view controller to display them")
    }

}

// MARK: - Helpers
private extension ListChannelsPresenterTests {
    func makeNewEpisode() -> NewEpisode {
        let coverAsset = NewEpisode.CoverAsset(url: "newEpisodeCoverAssetUrl")
        let channel = NewEpisode.Channel(title: "")
        let media = [
            NewEpisode.Media(type: "", title: "", coverAsset: coverAsset, channel: channel),
            NewEpisode.Media(type: "", title: "", coverAsset: coverAsset, channel: channel),
            NewEpisode.Media(type: "", title: "", coverAsset: coverAsset, channel: channel),
            NewEpisode.Media(type: "", title: "", coverAsset: coverAsset, channel: channel),
        ]
        let data = NewEpisode.Data(media: media)
        let newEpisode = NewEpisode(data: data)
        return newEpisode
    }

    func makeChannel() -> Channel {
        let iconAsset = Channel.IconAsset(thumbnailUrl: "")
        let coverAsset = Channel.CoverAsset(url: "channelSectionImageUrl")
        let series = [
            Channel.Series(title: "", coverAsset: coverAsset)
        ]
        let mediaCoverAsset = Channel.CoverAsset(url: "channelSectionImageUrl")
        let latestMedia = [
            Channel.LatestMedia(type: "", title: "", coverAsset: mediaCoverAsset),
            Channel.LatestMedia(type: "", title: "", coverAsset: mediaCoverAsset),
            Channel.LatestMedia(type: "", title: "", coverAsset: mediaCoverAsset),
            Channel.LatestMedia(type: "", title: "", coverAsset: mediaCoverAsset),
        ]
        let channels = [
            Channel.Channel(
                title: "channelSectionTitle",
                series: series,
                mediaCount: 55,
                latestMedia: latestMedia,
                id: "",
                iconAsset: iconAsset,
                coverAsset: coverAsset
            ),
        ]
        let data = Channel.Data(channels: channels)
        let channel = Channel(data: data)
        return channel
    }

    func makeCategory() -> mindvalleyassessment.Category {
        let categories = [
            Category.Category(name: "categoryName"),
            Category.Category(name: "categoryName"),
            Category.Category(name: "categoryName"),
            Category.Category(name: "categoryName"),
            Category.Category(name: "categoryName"),
        ]
        let data = Category.Data(categories: categories)
        let category = Category(data: data)
        return category
    }
}

// MARK: - Classes
private extension ListChannelsPresenterTests {
    class ListChannelsDisplayLogicSpy: ListChannelDisplayLogic
    {
        // MARK: Method call expectations

        var displayFetchedDataCalled = false

        // MARK: Argument expectations

        var viewModel: ListChannel.LoadData.ViewModel!

        // MARK: Spied methods

        func displayLoadedData(viewModel: ListChannel.LoadData.ViewModel) {
            displayFetchedDataCalled = true
            self.viewModel = viewModel
        }
    }
}
