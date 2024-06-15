//
//  ListChannelsDefaultCell.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/8/24.
//

import UIKit

final class ListChannelsDefaultCell: UICollectionViewCell {

    // MARK: - Declarations

    private var item: ListChannels.Section.Item? {
        didSet { configureItem() }
    }

    static let cellId = "ListChannelsDefaultCell"

    private let coverImageView = UIImageView()
    private let titleLabel = UILabel()
    private let channelTitleLabel = UILabel()
    private let labelStackView = UIStackView()
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

    func configure(item: ListChannels.Section.Item) {
        self.item = item
    }

    private func configureItem() {
        guard let item = item else { return }
        let title = item.title

        titleLabel.text = title

        if let subTitle = item.subTitle {
            channelTitleLabel.text = subTitle.uppercased()
            labelStackView.addArrangedSubview(channelTitleLabel)
        }

        if let imageUrl = item.imageUrl {
            coverImageView.setImage(with: imageUrl)
        }
    }

    private func clearCache() {
        coverImageView.image = nil
        titleLabel.text = nil
        channelTitleLabel.text = nil
    }

    private func shrink(isHighlighted: Bool) {
        let scale: CGFloat = 0.99
        shrink(by: scale, isPressed: isHighlighted)
    }
}

// MARK: - Programmatic UI Configuration
private extension ListChannelsDefaultCell {
    func configureUI() {
        coverImageView.backgroundColor = Color.imageViewBackground
        coverImageView.contentMode = UIView.ContentMode.scaleAspectFill
        coverImageView.layer.cornerRadius = 12
        coverImageView.clipsToBounds = true
        coverImageView.translatesAutoresizingMaskIntoConstraints = false

        coverImageViewContainerView.layer.cornerRadius = 12
        coverImageViewContainerView.clipsToBounds = false
        coverImageViewContainerView.layer.shadowColor = Color.shadow
        coverImageViewContainerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        coverImageViewContainerView.layer.shadowOpacity = 0.4
        coverImageViewContainerView.layer.shadowRadius = 10.0
        let renderRect = CGRect(x: 0, y: 0, width: contentView.bounds.width - 20, height: 228)
        coverImageViewContainerView.layer.shadowPath = UIBezierPath(roundedRect: renderRect, cornerRadius: 12).cgPath
        coverImageViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        coverImageViewContainerView.addSubview(coverImageView)

        titleLabel.textColor = Color.whiteText
        titleLabel.font = Font.sectionItemTitle
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.vertical)

        channelTitleLabel.textColor = Color.grayText
        channelTitleLabel.font = Font.sectionItemSubTitle
        channelTitleLabel.numberOfLines = 0
        channelTitleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.vertical)

        labelStackView.axis = NSLayoutConstraint.Axis.vertical
        labelStackView.spacing = 12
        labelStackView.alignment = UIStackView.Alignment.fill
        labelStackView.distribution = UIStackView.Distribution.fill
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(coverImageViewContainerView)
        contentView.addSubview(labelStackView)

        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: coverImageViewContainerView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: coverImageViewContainerView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: coverImageViewContainerView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: coverImageViewContainerView.bottomAnchor),

            coverImageViewContainerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            coverImageViewContainerView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            coverImageViewContainerView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            coverImageViewContainerView.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 20),
            coverImageViewContainerView.heightAnchor.constraint(equalToConstant: 228.0),

            labelStackView.topAnchor.constraint(equalTo: coverImageViewContainerView.bottomAnchor, constant: 12),
            labelStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            labelStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
    }
}
