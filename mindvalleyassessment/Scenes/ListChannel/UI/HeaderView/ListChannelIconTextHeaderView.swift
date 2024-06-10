//
//  ListChannelIconTextHeaderView.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/8/24.
//

import UIKit

final class ListChannelIconTextHeaderView: UICollectionReusableView {

    // MARK: - Declarations

    static let headerId = "ListChannelIconTextHeaderView"

    private let channelIconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let labelStackView = UIStackView()
    private let mainStackView = UIStackView()
    private let separatorView = UIView()

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
private extension ListChannelIconTextHeaderView {
    func configureUI() {
        titleLabel.text = "Mindvalley Mentoring"
        titleLabel.textColor = Color.whiteText
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)

        subTitleLabel.text = "78 episodes"
        subTitleLabel.textColor = Color.grayText
        subTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        subTitleLabel.setContentHuggingPriority(UILayoutPriority.fittingSizeLevel, for: .vertical)

        labelStackView.axis = NSLayoutConstraint.Axis.vertical
        labelStackView.spacing = 0
        labelStackView.alignment = UIStackView.Alignment.fill
        labelStackView.distribution = UIStackView.Distribution.fill
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subTitleLabel)

        channelIconImageView.backgroundColor = UIColor.black
        channelIconImageView.layer.cornerRadius = 25
        channelIconImageView.contentMode = UIView.ContentMode.scaleToFill
        channelIconImageView.translatesAutoresizingMaskIntoConstraints = false

        mainStackView.axis = NSLayoutConstraint.Axis.horizontal
        mainStackView.spacing = 14
        mainStackView.alignment = UIStackView.Alignment.fill
        mainStackView.distribution = UIStackView.Distribution.fill
        mainStackView.addArrangedSubview(channelIconImageView)
        mainStackView.addArrangedSubview(labelStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        separatorView.backgroundColor = Color.separator
        separatorView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(separatorView)
        addSubview(mainStackView)

        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            channelIconImageView.widthAnchor.constraint(equalToConstant: 50),
            channelIconImageView.heightAnchor.constraint(equalToConstant: 50),

            mainStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
