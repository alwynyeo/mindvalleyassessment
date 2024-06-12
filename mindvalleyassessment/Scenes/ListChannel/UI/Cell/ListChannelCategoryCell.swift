//
//  ListChannelCategoryCell.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//

import UIKit

final class ListChannelCategoryCell: UICollectionViewCell {
    
    // MARK: - Declarations

    private var item: ListChannel.Section.Item? {
        didSet { configureItem() }
    }

    static let cellId = "ListChannelCategoryCell"

    private let titleLabel = UILabel()

    // MARK: - Object Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    // MARK: - Helpers

    func configure(item: ListChannel.Section.Item) {
        self.item = item
    }

    private func configureItem() {
        guard let item = item else { return }
        let title = item.title

        titleLabel.text = title
    }
}

// MARK: - Programmatic UI Configuration
private extension ListChannelCategoryCell {
    func configureUI() {
        contentView.backgroundColor = Color.grayBackground
        contentView.layer.cornerRadius = 32

        titleLabel.textColor = Color.whiteText
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
}
