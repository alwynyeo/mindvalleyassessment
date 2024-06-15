//
//  EmptyableCollectionViewDiffableDataSource+Class.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/14/24.
//

import UIKit

class EmptyableUICollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier>: UICollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier> where SectionIdentifier: Hashable, ItemIdentifier: Hashable {
    // MARK: - Declarations

    private var collectionView: UICollectionView!
    private var emptyStateView: UIView?
    private var emptyStateViewConstraints: [NSLayoutConstraint] = []

    // MARK: - Object Lifecycle

    override init(collectionView: UICollectionView, cellProvider: @escaping UICollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier>.CellProvider) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
    }

    convenience init(
        collectionView: UICollectionView,
        emptyStateView: UIView? = nil,
        cellProvider: @escaping UICollectionViewDiffableDataSource<SectionIdentifier, ItemIdentifier>.CellProvider
    ) {
        self.init(collectionView: collectionView, cellProvider: cellProvider)
        self.collectionView = collectionView
        self.emptyStateView = emptyStateView
    }

    override func apply(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifier, ItemIdentifier>, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        super.apply(snapshot, animatingDifferences:animatingDifferences, completion: completion)

        guard let emptyStateView = emptyStateView else {
            return
        }

        if snapshot.itemIdentifiers.isEmpty {
            addEmptyStateView(emptyStateView: emptyStateView)
        } else {
            removeEmptyStateView(emptyStateView: emptyStateView)
        }
    }
}

// MARK: - Helpers
private extension EmptyableUICollectionViewDiffableDataSource {
    func addEmptyStateView(emptyStateView: UIView) {
        collectionView.backgroundView = emptyStateView
        collectionView.isScrollEnabled = false
    }

    func removeEmptyStateView(emptyStateView: UIView) {
        collectionView.backgroundView = nil
        collectionView.isScrollEnabled = true
    }
}
