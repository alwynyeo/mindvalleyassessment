//
//  ListChannelViewControllerTests.swift
//  mindvalleyassessmentTests
//
//  Created by Alwyn Yeo on 6/14/24.
//

import XCTest

@testable import mindvalleyassessment
final class ListChannelViewControllerTests: XCTestCase {

    // MARK: - Subject Under Test

    var sut: ListChannelsViewController!

    var window: UIWindow!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        try super.setUpWithError()

        window = UIWindow()
        setupListChannelViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

        try super.tearDownWithError()

        window = nil
        sut = nil
    }

    // MARK: - Test Setup

    func setupListChannelViewController() {
        let viewController = ListChannelsViewController()
        sut = viewController
    }

    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }

    func testShouldDisplayFetchedChannels() {
        // Given
        let collectionViewSpy = CollectionViewSpy()
        sut.collectionView = collectionViewSpy

        // When
        let items = [
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 1"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 2", subTitle: "SubTitle 1"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 3", subTitle: "SubTitle 2"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 4", subTitle: "SubTitle 3")
        ]

        let sections = [
            ListChannel.Section(imageUrl: URL(string: ""), title: "Section 1", subTitle: "section subtitle 1", items: items),
            ListChannel.Section(imageUrl: URL(string: ""), title: "Section 2", subTitle: "section subtitle 2", items: items),
            ListChannel.Section(imageUrl: URL(string: ""), title: "Section 2", subTitle: "section subtitle 2", items: items, isSeriesType: true),
            ListChannel.Section(imageUrl: URL(string: ""), title: "Section 2", subTitle: "section subtitle 2", items: items)
        ]

        let viewModel = ListChannel.LoadData.ViewModel(sections: sections)

        sut.displayLoadedData(viewModel: viewModel)

        // Then
        XCTAssert(collectionViewSpy.reloadDataCalled, "Displaying fetched channels should reload the table view")
    }

    func testNumberOfSectionsShouldEqualToNumberOfSectionsToDisplay() {
        // Given
        let dataSource = sut.dataSource
        let testDisplayedSectionItems = [
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 1"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 2", subTitle: "SubTitle 1"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 3", subTitle: "SubTitle 2"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 4", subTitle: "SubTitle 3")
        ]

        let testDisplayedSections = [
            ListChannel.Section(imageUrl: URL(string: ""), title: "Section 1", subTitle: "section subtitle 1", items: testDisplayedSectionItems),
            ListChannel.Section(imageUrl: URL(string: ""), title: "Section 2", subTitle: "section subtitle 2", items: testDisplayedSectionItems),
            ListChannel.Section(imageUrl: URL(string: ""), title: "Section 2", subTitle: "section subtitle 2", items: testDisplayedSectionItems, isSeriesType: true),
            ListChannel.Section(imageUrl: URL(string: ""), title: "Section 2", subTitle: "section subtitle 2", items: testDisplayedSectionItems)
        ]

        // When
        let viewModel = ListChannel.LoadData.ViewModel(sections: testDisplayedSections)

        sut.displayLoadedData(viewModel: viewModel)

        let numberOfSections = dataSource.snapshot().sectionIdentifiers.count

        // Then
        XCTAssertEqual(
            numberOfSections,
            testDisplayedSections.count,
            "The number of collection view sections should always be equal to the number of channels to display"
        )
    }

    func testNumberOfSectionItemsShouldEqualToNumberOfSectionItemsInFirstSectionToDisplay() {
        // Given
        let testDisplayedFirstSectionItems = [
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 1"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 2", subTitle: "SubTitle 1"),
        ]

        let testDisplayedSectionItems = [
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 1"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 2", subTitle: "SubTitle 1"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 3", subTitle: "SubTitle 2"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 4", subTitle: "SubTitle 3"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 1"),
        ]

        let testDisplayedSections = [
            ListChannel.Section(imageUrl: URL(string: ""), title: "Section 1", subTitle: "section subtitle 1", items: testDisplayedFirstSectionItems),
            ListChannel.Section(imageUrl: URL(string: ""), title: "Section 2", subTitle: "section subtitle 2", items: testDisplayedSectionItems),
            ListChannel.Section(imageUrl: URL(string: ""), title: "Section 2", subTitle: "section subtitle 2", items: testDisplayedSectionItems, isSeriesType: true),
            ListChannel.Section(imageUrl: URL(string: ""), title: "Section 2", subTitle: "section subtitle 2", items: testDisplayedSectionItems)
        ]

        // When
        let viewModel = ListChannel.LoadData.ViewModel(sections: testDisplayedSections)

        sut.displayLoadedData(viewModel: viewModel)

        let firstSection = sut.dataSource.snapshot().sectionIdentifiers[0]

        let dataSourceNumberOfFirstSectionItems = firstSection.items.count

        let actualNumberOfFirstSectionItems = testDisplayedSections[0].items.count

        // Then
        XCTAssertEqual(
            dataSourceNumberOfFirstSectionItems,
            actualNumberOfFirstSectionItems,
            "The number of section items should always be equal to the number of items in the first section to display"
        )
    }

    func testNumberOfAllSectionItemsShouldEqualToNumberOfAllSectionItemsToDisplay() {
        // Given
        let testDisplayedFirstSectionItems = [
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 1"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 2", subTitle: "SubTitle 1"),
        ]

        let testDisplayedSectionItems = [
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 1"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 2", subTitle: "SubTitle 1"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 3", subTitle: "SubTitle 2"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 4", subTitle: "SubTitle 3"),
            ListChannel.Section.Item(imageUrl: URL(string: ""), title: "Item 1"),
        ]

        let testDisplayedSections = [
            ListChannel.Section(imageUrl: URL(string: ""), title: "Section 1", subTitle: "section subtitle 1", items: testDisplayedFirstSectionItems),
            ListChannel.Section(imageUrl: URL(string: ""), title: "Section 2", subTitle: "section subtitle 2", items: testDisplayedSectionItems),
            ListChannel.Section(imageUrl: URL(string: ""), title: "Section 2", subTitle: "section subtitle 2", items: testDisplayedSectionItems, isSeriesType: true),
            ListChannel.Section(imageUrl: URL(string: ""), title: "Section 2", subTitle: "section subtitle 2", items: testDisplayedSectionItems)
        ]

        // When
        let viewModel = ListChannel.LoadData.ViewModel(sections: testDisplayedSections)

        sut.displayLoadedData(viewModel: viewModel)

        let dataSourceNumberOfSectionItems =  sut.dataSource.snapshot().sectionIdentifiers.reduce(0) { partialResult, section in
            partialResult + section.items.count
        }

        let actualNumberOfAllSectionItems = testDisplayedSections.reduce(0) { (partialResult, section) in
            partialResult + section.items.count
        }

        print("testNumberOfAllItemsShouldEqualToNumberOfAllChannelItemsToDisplay:", dataSourceNumberOfSectionItems, actualNumberOfAllSectionItems)

        // Then
        XCTAssertEqual(
            dataSourceNumberOfSectionItems,
            actualNumberOfAllSectionItems,
            "The number of section items should always be equal to the number of section items to display"
        )
    }
}

private extension ListChannelViewControllerTests {
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
