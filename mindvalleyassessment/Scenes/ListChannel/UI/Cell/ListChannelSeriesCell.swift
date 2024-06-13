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
    private let coverImageViewContainerView = UIView()

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

    private func clearCache() {
        coverImageView.image = nil
        titleLabel.text = nil
    }

    private func shrink(isHighlighted: Bool) {
        let scale: CGFloat = 0.99
        shrink(by: scale, isPressed: isHighlighted)
    }
}

// MARK: - Programmatic UI Configuration
private extension ListChannelSeriesCell {
    func configureUI() {
        coverImageView.backgroundColor = Color.imageViewBackground
        coverImageView.contentMode = UIView.ContentMode.scaleAspectFill
        coverImageView.layer.cornerRadius = 8
        coverImageView.clipsToBounds = true
        coverImageView.translatesAutoresizingMaskIntoConstraints = false

        coverImageViewContainerView.layer.cornerRadius = 8
        coverImageViewContainerView.clipsToBounds = false
        coverImageViewContainerView.layer.shadowColor = Color.shadow
        coverImageViewContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        coverImageViewContainerView.layer.shadowOpacity = 0.4
        coverImageViewContainerView.layer.shadowRadius = 10.0
        let renderRect = CGRect(x: 0, y: 0, width: contentView.bounds.width - 20, height: 172)
        coverImageViewContainerView.layer.shadowPath = UIBezierPath(roundedRect: renderRect, cornerRadius: 8).cgPath
        coverImageViewContainerView.translatesAutoresizingMaskIntoConstraints = false

        coverImageViewContainerView.addSubview(coverImageView)

        titleLabel.textColor = Color.whiteText
        titleLabel.font = Font.sectionItemTitle
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.vertical)

        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 11
        stackView.alignment = UIStackView.Alignment.fill
        stackView.distribution = UIStackView.Distribution.fill
        stackView.addArrangedSubview(coverImageViewContainerView)
        stackView.addArrangedSubview(titleLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: coverImageViewContainerView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: coverImageViewContainerView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: coverImageViewContainerView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: coverImageViewContainerView.bottomAnchor),

            coverImageViewContainerView.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 20),
            coverImageViewContainerView.heightAnchor.constraint(equalToConstant: 172),

            stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
    }
}
