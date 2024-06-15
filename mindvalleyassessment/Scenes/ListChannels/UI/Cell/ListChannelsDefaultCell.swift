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
    private let subTitleLabel = UILabel()
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
            subTitleLabel.text = subTitle.uppercased()
            labelStackView.addArrangedSubview(subTitleLabel)
        }

        if let imageUrl = item.imageUrl {
            coverImageView.setImage(with: imageUrl)
        }
    }

    private func clearCache() {
        coverImageView.image = nil
        titleLabel.text = nil
        subTitleLabel.text = nil
    }

    private func shrink(isHighlighted: Bool) {
        let scale: CGFloat = 0.99
        shrink(by: scale, isPressed: isHighlighted)
    }
}

// MARK: - Programmatic UI Configuration
private extension ListChannelsDefaultCell {
    func configureUI() {
        configureCoverImageViewContainerView()
        configureCoverImageView()
        configureTitleLabel()
        configureSubTitleLabel()
        configureLabelStackView()
    }

    func configureCoverImageViewContainerView() {
        let renderRect = CGRect(x: 0, y: 0, width: contentView.bounds.width - 20, height: 228)
        let shadowPath = UIBezierPath(roundedRect: renderRect, cornerRadius: 12).cgPath
        coverImageViewContainerView.layer.cornerRadius = 12
        coverImageViewContainerView.clipsToBounds = false
        coverImageViewContainerView.layer.shadowColor = Color.shadow
        coverImageViewContainerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        coverImageViewContainerView.layer.shadowOpacity = 0.4
        coverImageViewContainerView.layer.shadowRadius = 10.0
        coverImageViewContainerView.layer.shadowPath = shadowPath
        coverImageViewContainerView.translatesAutoresizingMaskIntoConstraints = false

        coverImageViewContainerView.addSubview(coverImageView)

        contentView.addSubview(coverImageViewContainerView)

        let constraints = [
            coverImageViewContainerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            coverImageViewContainerView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            coverImageViewContainerView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            coverImageViewContainerView.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 20),
            coverImageViewContainerView.heightAnchor.constraint(equalToConstant: 228.0)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureCoverImageView() {
        coverImageView.backgroundColor = Color.imageViewBackground
        coverImageView.contentMode = UIView.ContentMode.scaleAspectFill
        coverImageView.layer.cornerRadius = 12
        coverImageView.clipsToBounds = true
        coverImageView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            coverImageView.topAnchor.constraint(equalTo: coverImageViewContainerView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: coverImageViewContainerView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: coverImageViewContainerView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: coverImageViewContainerView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureTitleLabel() {
        titleLabel.textColor = Color.whiteText
        titleLabel.font = Font.sectionItemTitle
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(
            UILayoutPriority.defaultLow,
            for: NSLayoutConstraint.Axis.vertical
        )
    }

    func configureSubTitleLabel() {
        subTitleLabel.textColor = Color.grayText
        subTitleLabel.font = Font.sectionItemSubTitle
        subTitleLabel.numberOfLines = 0
        subTitleLabel.setContentHuggingPriority(
            UILayoutPriority.defaultHigh,
            for: NSLayoutConstraint.Axis.vertical
        )
    }

    func configureLabelStackView() {
        labelStackView.axis = NSLayoutConstraint.Axis.vertical
        labelStackView.spacing = 12
        labelStackView.alignment = UIStackView.Alignment.fill
        labelStackView.distribution = UIStackView.Distribution.fill
        labelStackView.translatesAutoresizingMaskIntoConstraints = false

        labelStackView.addArrangedSubview(titleLabel)

        contentView.addSubview(labelStackView)

        let constraints = [
            labelStackView.topAnchor.constraint(equalTo: coverImageViewContainerView.bottomAnchor, constant: 12),
            labelStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            labelStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
