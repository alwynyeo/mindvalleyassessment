//
//  ListChannelsViewControllerTests.swift
//  mindvalleyassessmentTests
//
//  Created by Alwyn Yeo on 6/14/24.
//

import XCTest

@testable import mindvalleyassessment
final class ListChannelsViewControllerTests: XCTestCase {

    // MARK: - Subject Under Test

    var sut: ListChannelsViewController!

    var window: UIWindow!

    // MARK: - Test Cycle

    override func setUpWithError() throws {
        try super.setUpWithError()

        window = UIWindow()
        setupListChannelsViewController()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        window = nil
        sut = nil
    }

    // MARK: - Test Setup

    func setupListChannelsViewController() {
        let viewController = ListChannelsViewController()
        sut = viewController
    }

    func loadView() {
        let date = Date()
        window.addSubview(sut.view)
        RunLoop.current.run(until: date)
    }

    // MARK: - Tests

    func testShouldFetchLocalChannelsWhenViewDidLoad() {
        // Given
        let listChannelsBusinessLogicSpy = ListChannelsBusinessLogicSpy()
        sut.interactor = listChannelsBusinessLogicSpy
        loadView()

        // When
        sut.viewDidLoad()

        // Then
        XCTAssert(listChannelsBusinessLogicSpy.fetchLocalChannelsCalled, "Should fetch channels from the local right after the view did load")
    }


    func testShouldFetchCloudChannelsWhenRefresh() {
        // Given
        let listChannelsBusinessLogicSpy = ListChannelsBusinessLogicSpy()
        sut.interactor = listChannelsBusinessLogicSpy

        // When
        let request = ListChannel.RefreshData.Request()
        sut.interactor?.refreshData(request: request)

        // Then
        XCTAssert(listChannelsBusinessLogicSpy.fetchCloudChannelsCalled, "Should fetch channels from the cloud right after the refresh")
    }

    func testShouldDisplayFetchedChannels() {
        // Given
        let collectionViewSpy = CollectionViewSpy()
        sut.collectionView = collectionViewSpy

        // When
        let sections = makeSections()
        let viewModel = ListChannel.LoadData.ViewModel(sections: sections)

        sut.displayLoadedData(viewModel: viewModel)

        // Then
        XCTAssert(collectionViewSpy.reloadDataCalled, "Displaying fetched channels should reload the table view")
    }

    func testNumberOfSectionsShouldEqualToNumberOfSectionsToDisplay() {
        // Given
        let dataSource = sut.dataSource
        let sections = makeSections()

        // When
        let viewModel = ListChannel.LoadData.ViewModel(sections: sections)

        sut.displayLoadedData(viewModel: viewModel)

        let numberOfSections = dataSource.snapshot().sectionIdentifiers.count

        // Then
        XCTAssertEqual(
            numberOfSections,
            sections.count,
            "The number of collection view sections should always be equal to the number of channels to display"
        )
    }

    func testNumberOfSectionItemsShouldEqualToNumberOfSectionItemsInFirstSectionToDisplay() {
        // Given
        let sections = makeSections()

        // When
        let viewModel = ListChannel.LoadData.ViewModel(sections: sections)

        sut.displayLoadedData(viewModel: viewModel)

        let firstSection = sut.dataSource.snapshot().sectionIdentifiers[0]

        let dataSourceNumberOfFirstSectionItems = firstSection.items.count

        let actualNumberOfFirstSectionItems = sections[0].items.count

        // Then
        XCTAssertEqual(
            dataSourceNumberOfFirstSectionItems,
            actualNumberOfFirstSectionItems,
            "The number of section items should always be equal to the number of items in the first section to display"
        )
    }

    func testNumberOfAllSectionItemsShouldEqualToNumberOfAllSectionItemsToDisplay() {
        // Given
        let sections = makeSections()

        // When
        let viewModel = ListChannel.LoadData.ViewModel(sections: sections)

        sut.displayLoadedData(viewModel: viewModel)

        let dataSourceNumberOfSectionItems =  sut.dataSource.snapshot().sectionIdentifiers.reduce(0) { partialResult, section in
            partialResult + section.items.count
        }

        let actualNumberOfAllSectionItems = sections.reduce(0) { (partialResult, section) in
            partialResult + section.items.count
        }

        // Then
        XCTAssertEqual(
            dataSourceNumberOfSectionItems,
            actualNumberOfAllSectionItems,
            "The number of section items should always be equal to the number of section items to display"
        )
    }
}

// MARK: - Helpers
private extension ListChannelsViewControllerTests {
    func makeSections() -> [ListChannel.Section] {
        let testDisplayedSectionAItems = [
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 1"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 2", subTitle: "SubTitle 1"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 3"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 4", subTitle: "SubTitle 2"),
        ]

        let testDisplayedSectionBItems = [
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 1"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 2", subTitle: "SubTitle 1"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 3"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 4", subTitle: "SubTitle 1"),
        ]

        let testDisplayedSections = [
            ListChannel.Section(
                imageUrl: URL(string: ""),
                title: "Section 1",
                subTitle: "Section subtitle 1",
                items: testDisplayedSectionAItems
            ),
            ListChannel.Section(
                imageUrl: URL(string: ""),
                title: "Section 2",
                subTitle: "Section subtitle 2",
                items: testDisplayedSectionBItems,
                isSeriesType: true
            ),
        ]

        return testDisplayedSections
    }
}

// MARK: - Classes
private extension ListChannelsViewControllerTests {
    class ListChannelsBusinessLogicSpy: ListChannelBusinessLogic {
        // MARK: Method call expectations

        var fetchLocalChannelsCalled = false

        var fetchCloudChannelsCalled = false

        // MARK: Spied methods

        func loadData(request: mindvalleyassessment.ListChannel.LoadData.Request) {
            fetchLocalChannelsCalled = true
        }

        func refreshData(request: mindvalleyassessment.ListChannel.RefreshData.Request) {
            fetchCloudChannelsCalled = true
        }
    }

    class CollectionViewSpy: UICollectionView {
        // MARK: Method call expectations

        var reloadDataCalled = false

        // MARK: - Init

        override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
            super.init(frame: frame, collectionViewLayout: layout)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        convenience init() {
            let layout = UICollectionViewFlowLayout()
            self.init(frame: CGRect.zero, collectionViewLayout: layout)
        }

        // MARK: Spied methods

        override func reloadData() {
            reloadDataCalled = true
        }
    }
}
