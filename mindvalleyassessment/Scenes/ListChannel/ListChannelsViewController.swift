//
//  ListChannelsViewController.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - ListChannelsDisplayLogic Protocol
protocol ListChannelsDisplayLogic: AnyObject {
    func displayLoadedData(viewModel: ListChannels.LoadData.ViewModel)
}

// MARK: - ListChannelsViewController Class
final class ListChannelsViewController: UICollectionViewController {
    // MARK: - Declarations

    typealias CompositionalLayout = UICollectionViewCompositionalLayout

    typealias Section = ListChannels.Section

    typealias Item = ListChannels.Section.Item

    typealias DataSource = EmptyableUICollectionViewDiffableDataSource<Section, Item>

    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    var interactor: ListChannelsBusinessLogic?

    var router: (ListChannelsRoutingLogic & ListChannelsDataPassing)?

    private let ListChannelsDefaultCellId = ListChannelsDefaultCell.cellId

    private let ListChannelsSeriesCellId = ListChannelsSeriesCell.cellId

    private let ListChannelsCategoryCellId = ListChannelsCategoryCell.cellId

    private let elementKindSectionHeader = UICollectionView.elementKindSectionHeader

    private(set) lazy var dataSource = makeDataSource()

    private let notificationCenter = NotificationCenter.default

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
        print("Deinit ListChannelsViewController")
        notificationCenter.removeObserver(self, name: NotificationName.refreshNotification, object: nil)
    }

    // MARK: - View Lifecycle

    override func loadView() {
        super.loadView()
        configureUI()
        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, kind, indexPath) in
            let defaultHeaderView = UICollectionReusableView()

            let snapshot = self.dataSource.snapshot()

            let sections = snapshot.sectionIdentifiers

            let sectionIndex = indexPath.section

            let section = sections[sectionIndex]

            let lastSectionIndex = sections.count - 1

            let isFirstSection = sectionIndex == 0

            let isLastSection = sectionIndex == lastSectionIndex

            if isFirstSection {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ListChannelsTextHeaderView.headerId,
                    for: indexPath
                ) as? ListChannelsTextHeaderView else {
                    return defaultHeaderView
                }
                headerView.configure(section: section, isSeparatorHidden: true)
                return headerView
            } else if isLastSection {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ListChannelsTextHeaderView.headerId,
                    for: indexPath
                ) as? ListChannelsTextHeaderView else {
                    return defaultHeaderView
                }
                headerView.configure(section: section)
                return headerView
            } else {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ListChannelsIconTextHeaderView.headerId,
                    for: indexPath
                ) as? ListChannelsIconTextHeaderView else {
                    return defaultHeaderView
                }
                headerView.configure(section: section)
                return headerView
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addRefreshNotificationObserver()
        loadData()
    }

    // MARK: - Override Parent Methods

    // MARK: - Setup

    private func setUp() {
        let viewController = self
        let interactor = ListChannelsInteractor()
        let presenter = ListChannelsPresenter()
        let router = ListChannelsRouter()

        viewController.interactor = interactor
        viewController.router = router

        interactor.presenter = presenter
        presenter.viewController = viewController

        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - Interator Logic

    private func loadData() {
        collectionView.startLoading()

        let request = ListChannels.LoadData.Request()
        interactor?.loadData(request: request)
    }

    func refreshData() {
        collectionView.startLoading()

        let request = ListChannels.RefreshData.Request()
        interactor?.refreshData(request: request)
    }

    // MARK: - Helpers

    private func makeDataSource() -> DataSource {
        let emptyStateView = EmptyStateView(frame: collectionView.bounds)

        let dataSource = DataSource(collectionView: collectionView, emptyStateView: emptyStateView) { [unowned self] collectionView, indexPath, item in
            let defaultCell = UICollectionViewCell()

            let snapshot = self.dataSource.snapshot()

            guard let section = snapshot.sectionIdentifier(containingItem: item) else {
                return defaultCell
            }

            let sectionIndex = indexPath.section

            let lastSectionIndex = snapshot.sectionIdentifiers.count - 1

            let isFirstSection = sectionIndex == 0

            let isLastSection = sectionIndex == lastSectionIndex

            let isSectionSeriesType = section.isSeriesType

            if isFirstSection {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ListChannelsDefaultCellId,
                    for: indexPath
                ) as? ListChannelsDefaultCell else {
                    return defaultCell
                }
                cell.configure(item: item)
                return cell
            } else if isLastSection {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ListChannelsCategoryCellId,
                    for: indexPath
                ) as? ListChannelsCategoryCell else {
                    return defaultCell
                }
                cell.configure(item: item)
                return cell
            } else {
                if isSectionSeriesType {
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ListChannelsSeriesCellId,
                        for: indexPath
                    ) as? ListChannelsSeriesCell else {
                        return defaultCell
                    }
                    cell.configure(item: item)
                    return cell
                } else {
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ListChannelsDefaultCellId,
                        for: indexPath
                    ) as? ListChannelsDefaultCell else {
                        return defaultCell
                    }
                    cell.configure(item: item)
                    return cell
                }
            }
        }

        return dataSource
    }

    private func resetSnapshot(snapshot: inout Snapshot, newSections: [ListChannels.Section]) {
        let currentSections = snapshot.sectionIdentifiers
        guard currentSections.isNotEmpty && newSections.isNotEmpty else { return }
        snapshot.deleteAllItems()
    }

    private func addRefreshNotificationObserver() {
        notificationCenter.addObserver(
            self,
            selector: #selector(handleRefresh),
            name: NotificationName.refreshNotification,
            object: nil
        )
    }

    // MARK: - Objc Helpers

    @objc private func handleRefresh() {
        collectionView.backgroundView = nil
        refreshData()
    }
}

// MARK: - ListChannelsDisplayLogic Extension
extension ListChannelsViewController: ListChannelsDisplayLogic {
    func displayLoadedData(viewModel: ListChannels.LoadData.ViewModel) {
        var snapshot = dataSource.snapshot()
        let newSections = viewModel.sections

        resetSnapshot(snapshot: &snapshot, newSections: newSections)

        snapshot.appendSections(newSections)

        newSections.forEach { section in
            let items = section.items
            snapshot.appendItems(items, toSection: section)
        }

        dataSource.apply(snapshot, animatingDifferences: false)
        print("display loaded data")
        collectionView.stopLoading()
    }
}

// MARK: - Programmatic UI Configuration
private extension ListChannelsViewController {
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
        collectionView.contentInset.top = 24
        collectionView.backgroundColor = Color.screenBackgroundColor
        collectionView.alwaysBounceVertical = true
        collectionView.alwaysBounceHorizontal = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(ListChannelsDefaultCell.self, forCellWithReuseIdentifier: ListChannelsDefaultCellId)
        collectionView.register(ListChannelsSeriesCell.self, forCellWithReuseIdentifier: ListChannelsSeriesCellId)
        collectionView.register(ListChannelsCategoryCell.self, forCellWithReuseIdentifier: ListChannelsCategoryCellId)
        collectionView.register(
            ListChannelsTextHeaderView.self,
            forSupplementaryViewOfKind: elementKindSectionHeader,
            withReuseIdentifier: ListChannelsTextHeaderView.headerId
        )
        collectionView.register(
            ListChannelsIconTextHeaderView.self,
            forSupplementaryViewOfKind: elementKindSectionHeader,
            withReuseIdentifier: ListChannelsIconTextHeaderView.headerId
        )
    }

    func makeCompositionalLayout() -> CompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()

        configuration.scrollDirection = UICollectionView.ScrollDirection.vertical

        let layout = CompositionalLayout(sectionProvider: { [unowned self] sectionIndex, environment in
            let snapshot = dataSource.snapshot()
            let sections = snapshot.sectionIdentifiers
            let section = sections[sectionIndex]
            let lastSectionIndex = sections.count - 1

            let isFirstSection = sectionIndex == 0
            let isLastSection = sectionIndex == lastSectionIndex
            let isSectionSeriesType = section.isSeriesType

            let layoutSection: NSCollectionLayoutSection

            if isFirstSection {
                layoutSection = makeNewEpisodeLayoutSection()
            } else if isLastSection {
                layoutSection = makeCategoryLayoutSection()
            } else {
                layoutSection = isSectionSeriesType ? makeSeriesLayoutSection() : makeCourseLayoutSection()
            }

            return layoutSection

        }, configuration: configuration)

        return layout
    }

    func makeNewEpisodeLayoutSection() -> NSCollectionLayoutSection {
        let itemWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        let itemHeight: NSCollectionLayoutDimension
        if #available(iOS 17.0, *) {
            itemHeight = NSCollectionLayoutDimension.uniformAcrossSiblings(estimate: 354.0)
        } else {
            itemHeight = NSCollectionLayoutDimension.estimated(354.0)
        }
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupWidth = NSCollectionLayoutDimension.fractionalWidth(0.46)
        let groupHeight = itemHeight
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let headerWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        let headerHeight = NSCollectionLayoutDimension.estimated(24.0)
        let headerSize = NSCollectionLayoutSize(widthDimension: headerWidth, heightDimension: headerHeight)
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: elementKindSectionHeader,
            alignment: NSRectAlignment.top
        )
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 10)
        section.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPaging

        return section
    }

    func makeCourseLayoutSection() -> NSCollectionLayoutSection {
        let itemWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        let itemHeight: NSCollectionLayoutDimension
        if #available(iOS 17.0, *) {
            itemHeight = NSCollectionLayoutDimension.uniformAcrossSiblings(estimate: 354.0)
        } else {
            itemHeight = NSCollectionLayoutDimension.estimated(354.0)
        }
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupWidth = NSCollectionLayoutDimension.fractionalWidth(0.46)
        let groupHeight = itemHeight
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let headerWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        let headerHeight = NSCollectionLayoutDimension.absolute(73.0)
        let headerSize = NSCollectionLayoutSize(widthDimension: headerWidth, heightDimension: headerHeight)
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: elementKindSectionHeader,
            alignment: NSRectAlignment.top
        )
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 10, bottom: 0, trailing: 10)
        section.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPaging

        return section
    }

    func makeSeriesLayoutSection() -> NSCollectionLayoutSection {
        let itemWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        let itemHeight: NSCollectionLayoutDimension
        if #available(iOS 17.0, *) {
            itemHeight = NSCollectionLayoutDimension.uniformAcrossSiblings(estimate: 235.0)
        } else {
            itemHeight = NSCollectionLayoutDimension.estimated(235.0)
        }
        let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupWidth = NSCollectionLayoutDimension.fractionalWidth(0.91)
        let groupHeight = itemHeight
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let headerWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        let headerHeight = NSCollectionLayoutDimension.absolute(73.0)
        let headerSize = NSCollectionLayoutSize(widthDimension: headerWidth, heightDimension: headerHeight)
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: elementKindSectionHeader,
            alignment: NSRectAlignment.top
        )
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 10, bottom: 0, trailing: 10)
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
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

        let section = NSCollectionLayoutSection(group: group)
        let headerWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        let headerHeight = NSCollectionLayoutDimension.absolute(56.0)
        let headerSize = NSCollectionLayoutSize(widthDimension: headerWidth, heightDimension: headerHeight)
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: elementKindSectionHeader,
            alignment: NSRectAlignment.top
        )
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 19, leading: 10, bottom: 46, trailing: 10)
        section.interGroupSpacing = 16

        return section
    }
}
