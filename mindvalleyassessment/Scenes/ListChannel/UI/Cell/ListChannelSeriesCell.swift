//
//  ListChannelSeriesCell.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//

import UIKit

final class ListChannelSeriesCell: UICollectionViewCell {

    // MARK: - Declarations

    private var item: ListChannel.Section.Item? {
        didSet { configureItem() }
    }

    static let cellId = "ListChannelSeriesCell"

    private let coverImageView = UIImageView()
    private let titleLabel = UILabel()
    private let stackView = UIStackView()

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

        if let imageUrl = item.imageUrl {
            coverImageView.setImage(with: imageUrl)
        }
    }
}

// MARK: - Programmatic UI Configuration
private extension ListChannelSeriesCell {
    func configureUI() {
        coverImageView.contentMode = UIView.ContentMode.scaleAspectFill
        coverImageView.layer.cornerRadius = 8
        coverImageView.clipsToBounds = true
        coverImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = Color.whiteText
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.vertical)

        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 11
        stackView.alignment = UIStackView.Alignment.fill
        stackView.distribution = UIStackView.Distribution.fill
        stackView.addArrangedSubview(coverImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            coverImageView.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 20),
            coverImageView.heightAnchor.constraint(equalToConstant: 172),

            stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ])
    }
}
