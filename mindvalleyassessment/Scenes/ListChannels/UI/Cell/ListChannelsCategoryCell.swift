//
//  ListChannelsCategoryCell.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//

import UIKit

final class ListChannelsCategoryCell: UICollectionViewCell {
    
    // MARK: - Declarations

    private var item: ListChannels.Section.Item? {
        didSet { configureItem() }
    }

    static let cellId = "ListChannelsCategoryCell"

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

    // MARK: - Override Parent Properties

    override var isHighlighted: Bool {
        didSet { shrink(isHighlighted: isHighlighted) }
    }

    // MARK: - Override Parent Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearCache()
    }

    // MARK: - Helpers

    func configure(item: ListChannels.Section.Item) {
        self.item = item
    }

    private func configureItem() {
        guard let item = item else { return }
        let title = item.title

        titleLabel.text = title
    }

    private func clearCache() {
        titleLabel.text = nil
    }

    private func shrink(isHighlighted: Bool) {
        let scale: CGFloat = 0.95
        shrink(by: scale, isPressed: isHighlighted)
    }
}

// MARK: - Programmatic UI Configuration
private extension ListChannelsCategoryCell {
    func configureUI() {
        configureContentView()
        configureTitleLabel()
    }

    func configureContentView() {
        contentView.backgroundColor = Color.grayBackground
        contentView.layer.cornerRadius = 32
    }

    func configureTitleLabel() {
        titleLabel.textColor = Color.whiteText
        titleLabel.font = Font.categoryItemTitle
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)

        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
