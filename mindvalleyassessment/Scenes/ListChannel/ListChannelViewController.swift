//
//  ListChannelViewController.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - ListChannelDisplayLogic Protocol
protocol ListChannelDisplayLogic: AnyObject {
    func displaySomething(viewModel: ListChannel.Something.ViewModel)
}

// MARK: - ListChannelViewController Class
final class ListChannelViewController: UICollectionViewController {
    // MARK: - Declarations
    
    private var interactor: ListChannelBusinessLogic?

    private var router: (ListChannelRoutingLogic & ListChannelDataPassing)?

    private struct Section: Hashable {
        let id: String
    }

    private struct Item: Hashable {
        let id: String
        let title: String
    }

    private let listChannelDefaultCellId = ListChannelDefaultCell.cellId

    private let listChannelSeriesCellId = ListChannelSeriesCell.cellId

    private let listChannelCategoryCellId = ListChannelCategoryCell.cellId

    private let elementKindSectionHeader = UICollectionView.elementKindSectionHeader

    private lazy var dataSource = makeDataSource()

    // MARK: - Object Lifecycle

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    convenience init() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        self.init(collectionViewLayout: collectionViewLayout)
    }

    deinit {
        print("Deinit ListChannelViewController")
    }

    // MARK: - View Lifecycle

    override func loadView() {
        super.loadView()
        configureUI()
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let defaultHeaderView = UICollectionReusableView()

//            guard let listChannelTextHeaderView = collectionView.dequeueReusableSupplementaryView(
//                ofKind: kind,
//                withReuseIdentifier: ListChannelTextHeaderView.headerId,
//                for: indexPath
//            ) as? ListChannelTextHeaderView else {
//                return defaultHeaderView
//            }
//
//            return listChannelTextHeaderView

            guard let listChannelIconTextHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ListChannelIconTextHeaderView.headerId,
                for: indexPath
            ) as? ListChannelIconTextHeaderView else {
                return defaultHeaderView
            }

            return listChannelIconTextHeaderView
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
        print("width::", collectionView.frame.width)
        print("height::", collectionView.frame.height)
        var snapshot = dataSource.snapshot()
        var sections: [Section] = []
        var sectionAItems: [Item] = []
        var sectionBItems: [Item] = []
        var sectionCItems: [Item] = []
        var sectionDItems: [Item] = []
        var sectionEItems: [Item] = []
        for _ in 0..<5 {
            let section = Section(id: UUID().uuidString)
            sections.append(section)
        }
        for index in 0..<10 {
            let item = Item(id: UUID().uuidString, title: "Title\(index+1)")
            sectionAItems.append(item)
        }
        for index in 0..<10 {
            let item = Item(id: UUID().uuidString, title: "Title\(index+1)")
            sectionBItems.append(item)
        }
        for index in 0..<10 {
            let item = Item(id: UUID().uuidString, title: "Title\(index+1)")
            sectionCItems.append(item)
        }
        for index in 0..<10 {
            let item = Item(id: UUID().uuidString, title: "Title\(index+1)")
            sectionDItems.append(item)
        }
        for index in 0..<10 {
            let item = Item(id: UUID().uuidString, title: "Title\(index+1)")
            sectionEItems.append(item)
        }
        snapshot.appendSections(sections)
        snapshot.appendItems(sectionAItems, toSection: sections[0])
        snapshot.appendItems(sectionBItems, toSection: sections[1])
        snapshot.appendItems(sectionCItems, toSection: sections[2])
        snapshot.appendItems(sectionDItems, toSection: sections[3])
        snapshot.appendItems(sectionEItems, toSection: sections[4])
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - Override Parent Methods

    // MARK: - Setup

    private func setUp() {
        let viewController = self
        let interactor = ListChannelInteractor()
        let presenter = ListChannelPresenter()
        let router = ListChannelRouter()

        viewController.interactor = interactor
        viewController.router = router

        interactor.presenter = presenter
        presenter.viewController = viewController

        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - Interator Logic

    private func doSomething() {
        let request = ListChannel.Something.Request()
        interactor?.doSomething(request: request)
    }

    // MARK: - Helpers

    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, AnyHashable> {
        let dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) { [unowned self] collectionView, indexPath, item in
            let defaultCell = UICollectionViewCell()

//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listChannelDefaultCellId, for: indexPath) as? ListChannelDefaultCell else {
//                return defaultCell
//            }

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listChannelCategoryCellId, for: indexPath) as? ListChannelCategoryCell else {
                return defaultCell
            }

            return cell
        }

        return dataSource
    }
}

// MARK: - ListChannelDisplayLogic Extension
extension ListChannelViewController: ListChannelDisplayLogic {
    func displaySomething(viewModel: ListChannel.Something.ViewModel) {}
}

// MARK: - Programmatic UI Configuration
private extension ListChannelViewController {
    func configureUI() {
        title = "Channels"

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Color.screenBackgroundColor
        appearance.titleTextAttributes = [.foregroundColor: Color.navigationBarTitleColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: Color.navigationBarTitleColor]

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance // For iPhone small navigation bar in landscape.

        navigationController?.navigationBar.prefersLargeTitles = true

        collectionView.collectionViewLayout = makeCompositionalLayout()
        //        collectionView.contentInset.bottom = 46
        collectionView.backgroundColor = Color.screenBackgroundColor
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = true
//        collectionView.register(ListChannelDefaultCell.self, forCellWithReuseIdentifier: listChannelDefaultCellId)
//        collectionView.register(ListChannelSeriesCell.self, forCellWithReuseIdentifier: listChannelSeriesCellId)
        collectionView.register(ListChannelCategoryCell.self, forCellWithReuseIdentifier: listChannelCategoryCellId)
//        collectionView.register(ListChannelTextHeaderView.self, forSupplementaryViewOfKind: elementKindSectionHeader, withReuseIdentifier: ListChannelTextHeaderView.headerId)
        collectionView.register(
            ListChannelIconTextHeaderView.self,
            forSupplementaryViewOfKind: elementKindSectionHeader,
            withReuseIdentifier: ListChannelIconTextHeaderView.headerId
        )
    }

    func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        //        let layout = UICollectionViewCompositionalLayout(
        //        UICollectionViewCompositionalLayoutConfiguration().
        print("UICollectionViewCompositionalLayout")
        let layout = UICollectionViewCompositionalLayout { [unowned self] sectionIndex, environment in
            if sectionIndex == 0 {
                let newEpisodeSection = makeNewEpisodeLayoutSection()
                return newEpisodeSection
            } else if sectionIndex == 2 {
                let seriesSection = makeSeriesLayoutSection()
                return seriesSection
            } else if sectionIndex == 4 {
                let categorySection = makeCategoryLayoutSection()
                return categorySection
            } else {
                let courseSection = makeCourseLayoutSection()
                return courseSection
            }
        }

        return layout
    }

    func makeNewEpisodeLayoutSection() -> NSCollectionLayoutSection {
        let itemWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        let itemHeight = NSCollectionLayoutDimension.fractionalHeight(1.0)
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupWidth = NSCollectionLayoutDimension.fractionalWidth(0.46)
        let groupFractionalHeight = 354.0 / collectionView.frame.height
        let groupHeight = NSCollectionLayoutDimension.fractionalHeight(groupFractionalHeight)
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let headerWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        let headerHeight = NSCollectionLayoutDimension.absolute(51.0)
        let headerSize = NSCollectionLayoutSize(widthDimension: headerWidth, heightDimension: headerHeight)
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: elementKindSectionHeader,
            alignment: NSRectAlignment.topLeading
        )
        section.boundarySupplementaryItems = [header]
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPaging

        return section
    }

    func makeCourseLayoutSection() -> NSCollectionLayoutSection {
        let itemWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        let itemHeight = NSCollectionLayoutDimension.fractionalHeight(1.0)
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupWidth = NSCollectionLayoutDimension.fractionalWidth(0.46)
        let groupFractionalHeight = 304.0 / collectionView.frame.height
        let groupHeight = NSCollectionLayoutDimension.fractionalHeight(groupFractionalHeight)
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let headerWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        let headerHeight = NSCollectionLayoutDimension.absolute(51.0)
        let headerSize = NSCollectionLayoutSize(widthDimension: headerWidth, heightDimension: headerHeight)
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: elementKindSectionHeader,
            alignment: NSRectAlignment.topLeading
        )
        section.boundarySupplementaryItems = [header]
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPaging

        return section
    }

    func makeSeriesLayoutSection() -> NSCollectionLayoutSection {
        let itemWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        let itemHeight = NSCollectionLayoutDimension.fractionalHeight(1.0)
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupWidth = NSCollectionLayoutDimension.fractionalWidth(0.90)
        let groupHeight = NSCollectionLayoutDimension.absolute(218.0)
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let headerWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        let headerHeight = NSCollectionLayoutDimension.absolute(51.0)
        let headerSize = NSCollectionLayoutSize(widthDimension: headerWidth, heightDimension: headerHeight)
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: elementKindSectionHeader,
            alignment: NSRectAlignment.topLeading
        )
        section.boundarySupplementaryItems = [header]
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPaging

        return section
    }

    func makeCategoryLayoutSection() -> NSCollectionLayoutSection {
        let itemWidth = NSCollectionLayoutDimension.fractionalWidth(0.5)
        let itemHeight = NSCollectionLayoutDimension.fractionalHeight(1.0)
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        let groupHeight = NSCollectionLayoutDimension.absolute(60.0)
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(15.0)

        let section = NSCollectionLayoutSection(group: group)
        let headerWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        let headerHeight = NSCollectionLayoutDimension.absolute(51.0)
        let headerSize = NSCollectionLayoutSize(widthDimension: headerWidth, heightDimension: headerHeight)
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: elementKindSectionHeader,
            alignment: NSRectAlignment.topLeading
        )
        section.boundarySupplementaryItems = [header]
        section.interGroupSpacing = 16
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

        return section
    }
}
