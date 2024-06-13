//
//  ListChannelDefaultCell.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/8/24.
//

import UIKit

final class ListChannelDefaultCell: UICollectionViewCell {

    // MARK: - Declarations

    private var item: ListChannel.Section.Item? {
        didSet { configureItem() }
    }

    static let cellId = "ListChannelDefaultCell"

    private let coverImageView = UIImageView()
    private let titleLabel = UILabel()
    private let channelTitleLabel = UILabel()
    private let labelStackView = UIStackView()

    // MARK: - Object Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
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
}

// MARK: - Programmatic UI Configuration
private extension ListChannelDefaultCell {
    func configureUI() {
        coverImageView.backgroundColor = Color.imageViewBackground
        coverImageView.contentMode = UIView.ContentMode.scaleAspectFill
        coverImageView.layer.cornerRadius = 12
        coverImageView.clipsToBounds = true
        coverImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = Color.whiteText
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)

        channelTitleLabel.textColor = Color.grayText
        channelTitleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        channelTitleLabel.numberOfLines = 0
        channelTitleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .vertical)

        labelStackView.axis = NSLayoutConstraint.Axis.vertical
        labelStackView.spacing = 12
        labelStackView.alignment = UIStackView.Alignment.fill
        labelStackView.distribution = UIStackView.Distribution.fill
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(coverImageView)
        contentView.addSubview(labelStackView)

        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            coverImageView.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 20),
            coverImageView.heightAnchor.constraint(equalToConstant: 228.0),

            labelStackView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 10),
            labelStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            labelStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ])
    }
}
