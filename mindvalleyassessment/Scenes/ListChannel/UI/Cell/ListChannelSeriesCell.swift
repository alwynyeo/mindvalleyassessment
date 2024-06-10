//
//  ListChannelSeriesCell.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//

import UIKit

final class ListChannelSeriesCell: UICollectionViewCell {

    // MARK: - Declarations

    static let cellId = "ListChannelDefaultCell"

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
}

// MARK: - Programmatic UI Configuration
private extension ListChannelSeriesCell {
    func configureUI() {
        coverImageView.backgroundColor = UIColor.black
        coverImageView.layer.cornerRadius = 8
        coverImageView.clipsToBounds = true

        titleLabel.text = "The Cure For Loneliness"
        titleLabel.textColor = Color.whiteText
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: NSLayoutConstraint.Axis.vertical)

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
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
