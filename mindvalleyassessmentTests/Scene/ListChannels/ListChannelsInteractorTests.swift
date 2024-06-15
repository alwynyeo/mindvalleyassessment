//
//  ListChannelsInteractorTests.swift
//  mindvalleyassessmentTests
//
//  Created by Alwyn Yeo on 6/14/24.
//

import XCTest

@testable import mindvalleyassessment
final class ListChannelsInteractorTests: XCTestCase {

    // MARK: - Subject Under Test

    var sut: ListChannelInteractor!

    var window: UIWindow!

    // MARK: - Test Cycle

    override func setUpWithError() throws {
        try super.setUpWithError()

        window = UIWindow()
        setupListChannelsInteractor()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        window = nil
        sut = nil
    }

    // MARK: - Test Setup

    func setupListChannelsInteractor() {
        sut = ListChannelInteractor()
    }

    // MARK: - Tests

    func testFetchDataShouldAskListChannelsWorkerToFetchDataAndPresenterToFormatResult() {
        // Given
        let listChannelsPresentationLogicSpy = ListChannelsPresentationLogicSpy()
        sut.presenter = listChannelsPresentationLogicSpy
        let listChannelsWorkerSpy = ListChannelsWorkerSpy()
        sut.worker = listChannelsWorkerSpy

        // When
        let request = ListChannel.LoadData.Request()
        sut.loadData(request: request)

        // Then
        XCTAssert(listChannelsWorkerSpy.getLocalNewEpisodeCalled, "loadData() should ask ListChannelsWorker to load NewEpisode")
        XCTAssert(listChannelsWorkerSpy.getLocalChannelCalled, "loadData() should ask ListChannelsWorker to load Channel")
        XCTAssert(listChannelsWorkerSpy.getLocalCategoryCalled, "loadData() should ask ListChannelsWorker to load Category")

        let exp = expectation(description: "Wait for DispatchGroup")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssert(listChannelsPresentationLogicSpy.presentLoadedDataCalled, "loadData() should ask presenter to format loaded data")
            XCTAssert(listChannelsWorkerSpy.getCloudNewEpisodeCalled, "loadData() should ask ListChannelsWorker to load NewEpisode")
            XCTAssert(listChannelsWorkerSpy.getCloudChannelCalled, "loadData() should ask ListChannelsWorker to load Channel")
            XCTAssert(listChannelsWorkerSpy.getCloudCategoryCalled, "loadData() should ask ListChannelsWorker to load Category")
            let exp = expectation(description: "Wait for DispatchGroup")
            let result = XCTWaiter.wait(for: [exp], timeout: 0.1)
            if result == XCTWaiter.Result.timedOut {
                XCTAssert(listChannelsPresentationLogicSpy.presentLoadedDataCalled, "loadData() should ask presenter to format loaded data")
            } else {
                XCTFail("Delay interrupted")
            }
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testFetchLocalDataShouldAskListChannelsWorkerToFetchLocalDataAndPresenterToFormatResult() {
        // Given
        let listChannelsPresentationLogicSpy = ListChannelsPresentationLogicSpy()
        sut.presenter = listChannelsPresentationLogicSpy
        let listChannelsWorkerSpy = ListChannelsWorkerSpy()
        sut.worker = listChannelsWorkerSpy

        // When
        let request = ListChannel.LoadData.Request()
        sut.loadData(request: request) // Refresh Data directly fetches data from the cloud

        // Then
        XCTAssert(listChannelsWorkerSpy.getLocalNewEpisodeCalled, "loadData() should ask ListChannelsWorker to load NewEpisode")
        XCTAssert(listChannelsWorkerSpy.getLocalChannelCalled, "loadData() should ask ListChannelsWorker to load Channel")
        XCTAssert(listChannelsWorkerSpy.getLocalCategoryCalled, "loadData() should ask ListChannelsWorker to load Category")
        let exp = expectation(description: "Wait for DispatchGroup")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssert(listChannelsPresentationLogicSpy.presentLoadedDataCalled, "loadData() should ask presenter to format loaded data")
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testFetchCloudDataShouldAskListChannelsWorkerToFetchCloudDataAndPresenterToFormatResult() {
        // Given
        let listChannelsPresentationLogicSpy = ListChannelsPresentationLogicSpy()
        sut.presenter = listChannelsPresentationLogicSpy
        let listChannelsWorkerSpy = ListChannelsWorkerSpy()
        sut.worker = listChannelsWorkerSpy

        // When
        let request = ListChannel.RefreshData.Request()
        sut.refreshData(request: request) // Refresh Data directly fetches data from the cloud

        // Then
        XCTAssert(listChannelsWorkerSpy.getCloudNewEpisodeCalled, "loadData() should ask ListChannelsWorker to load NewEpisode")
        XCTAssert(listChannelsWorkerSpy.getCloudChannelCalled, "loadData() should ask ListChannelsWorker to load Channel")
        XCTAssert(listChannelsWorkerSpy.getCloudCategoryCalled, "loadData() should ask ListChannelsWorker to load Category")
        let exp = expectation(description: "Wait for DispatchGroup")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.1)
        if result == XCTWaiter.Result.timedOut {
            XCTAssert(listChannelsPresentationLogicSpy.presentLoadedDataCalled, "loadData() should ask presenter to format loaded data")
        } else {
            XCTFail("Delay interrupted")
        }
    }
}

// MARK: - Classes
private extension ListChannelsInteractorTests {
    class ListChannelsPresentationLogicSpy: ListChannelPresentationLogic {
        // MARK: Method call expectations

        var presentLoadedDataCalled = false

        // MARK: Spied methods

        func presentLoadedData(response: ListChannel.LoadData.Response) {
            presentLoadedDataCalled = true
        }
    }

    class ListChannelsWorkerSpy: ListChannelWorkerProtocol {
        // MARK: Method call expectations

        var getLocalNewEpisodeCalled = false

        var getLocalChannelCalled = false

        var getLocalCategoryCalled = false

        var getCloudNewEpisodeCalled = false

        var getCloudChannelCalled = false

        var getCloudCategoryCalled = false

        // MARK: Spied methods

        func getLocalNewEpisode(completion: @escaping (NewEpisodeResultType) -> Void) {
            getLocalNewEpisodeCalled = true
            let newEpisode = makeNewEpisode()
            let successResult = NewEpisodeResultType.success(newEpisode)
            completion(successResult)
        }

        func getLocalChannel(completion: @escaping (ChannelResultType) -> Void) {
            getLocalChannelCalled = true
            let channel = makeChannel()
            let successResult = ChannelResultType.success(channel)
            completion(successResult)
        }

        func getLocalCategory(completion: @escaping (CategoryResultType) -> Void) {
            getLocalCategoryCalled = true
            let category = makeCategory()
            let successResult = CategoryResultType.success(category)
            completion(successResult)
        }

        func getCloudNewEpisode(completion: @escaping (NewEpisodeResultType) -> Void) {
            getCloudNewEpisodeCalled = true
            let newEpisode = makeNewEpisode()
            let successResult = NewEpisodeResultType.success(newEpisode)
            completion(successResult)
        }

        func getCloudChannel(completion: @escaping (ChannelResultType) -> Void) {
            getCloudChannelCalled = true
            let channel = makeChannel()
            let successResult = ChannelResultType.success(channel)
            completion(successResult)
        }

        func getCloudCategory(completion: @escaping (CategoryResultType) -> Void) {
            getCloudCategoryCalled = true
            let category = makeCategory()
            let successResult = CategoryResultType.success(category)
            completion(successResult)
        }

        private func makeNewEpisode() -> NewEpisode {
            let coverAsset = NewEpisode.CoverAsset(url: "")
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
            let coverAsset = Channel.CoverAsset(url: "")
            let series = [
                Channel.Series(title: "", coverAsset: coverAsset)
            ]
            let latestMedia = [
                Channel.LatestMedia(type: "", title: "", coverAsset: coverAsset),
                Channel.LatestMedia(type: "", title: "", coverAsset: coverAsset),
                Channel.LatestMedia(type: "", title: "", coverAsset: coverAsset),
                Channel.LatestMedia(type: "", title: "", coverAsset: coverAsset),
            ]
            let channels = [
                Channel.Channel(
                    title: "",
                    series: series,
                    mediaCount: 5,
                    latestMedia: latestMedia,
                    id: "",
                    iconAsset: iconAsset,
                    coverAsset: coverAsset
                ),
                Channel.Channel(
                    title: "",
                    series: series,
                    mediaCount: 45,
                    latestMedia: latestMedia,
                    id: "",
                    iconAsset: iconAsset,
                    coverAsset: coverAsset
                ),
                Channel.Channel(
                    title: "",
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
                Category.Category(name: ""),
                Category.Category(name: ""),
                Category.Category(name: ""),
                Category.Category(name: ""),
                Category.Category(name: ""),
            ]
            let data = Category.Data(categories: categories)
            let category = Category(data: data)
            return category
        }
    }
}
