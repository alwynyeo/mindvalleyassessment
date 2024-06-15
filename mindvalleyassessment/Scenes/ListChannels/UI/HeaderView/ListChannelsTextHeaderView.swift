//
//  ListChannelsTextHeaderView.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/8/24.
//

import UIKit

final class ListChannelsTextHeaderView: UICollectionReusableView {

    // MARK: - Declarations

    private var section: ListChannels.Section? {
        didSet { configureSection() }
    }

    static let headerId = "ListChannelsTextHeaderView"

    private let titleLabel = UILabel()
    private let titleLabelContainerView = UIView()
    private let separatorView = UIView()
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

    func configure(section: ListChannels.Section, isSeparatorHidden: Bool = false) {
        self.section = section
        separatorView.isHidden = isSeparatorHidden
    }

    private func configureSection() {
        guard let section = section else { return }
        let title = section.title

        titleLabel.text = title
    }
}

// MARK: - Programmatic UI Configuration
private extension ListChannelsTextHeaderView {
    func configureUI() {
        configureSeparatorView()
        configureTitleLabelContainerView()
        configureTitleLabel()
        configureStackView()
    }

    func configureSeparatorView() {
        separatorView.backgroundColor = Color.separator
        separatorView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureTitleLabelContainerView() {
        titleLabelContainerView.addSubview(titleLabel)
    }

    func configureTitleLabel() {
        titleLabel.textColor = Color.grayText
        titleLabel.font = Font.textSectionTitle
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: titleLabelContainerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleLabelContainerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: titleLabelContainerView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: titleLabelContainerView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureStackView() {
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 30
        stackView.alignment = UIStackView.Alignment.fill
        stackView.distribution = UIStackView.Distribution.fill
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(titleLabelContainerView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        let constraints = [
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
