//
//  EmptyStateView.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/14/24.
//

import UIKit

final class EmptyStateView: UIView {

    // Declarations
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let refreshButton = UIButton()
    private let stackView = UIStackView()
    private let emptyStateView = UIView()

    private let notificationCenter = NotificationCenter.default

    // Object Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    @objc private func handleRefreshButton() {
        notificationCenter.post(name: NotificationName.refreshNotification, object: nil)
    }
}

// MARK: - Programmatic UI Configuration
private extension EmptyStateView {
    func configureUI() {
        configureEmptyStateView()
        configureTitleLabel()
        configureSubTitleLabel()
        configureRefreshButton()
        configureStackView()
    }

    func configureEmptyStateView() {
        emptyStateView.frame = bounds
        emptyStateView.backgroundColor = Color.screenBackgroundColor
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(emptyStateView)

        let constraints = [
            emptyStateView.topAnchor.constraint(equalTo: topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func configureTitleLabel() {
        titleLabel.text = "No channels"
        titleLabel.font = Font.boldTitle
        titleLabel.textColor = Color.emptyStateTitle
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.numberOfLines = 0
    }

    func configureSubTitleLabel() {
        subTitleLabel.text = "Channels will appear here when they are available."
        subTitleLabel.font = Font.emptyStateSubTitle
        subTitleLabel.textColor = Color.grayText
        subTitleLabel.textAlignment = NSTextAlignment.center
        subTitleLabel.numberOfLines = 0
    }

    func configureRefreshButton() {
        let image = UIImage(systemName: "arrow.clockwise.circle.fill")
        refreshButton.setImage(image, for: UIControl.State.normal)
        refreshButton.addTarget(self, action: #selector(handleRefreshButton), for: UIControl.Event.touchUpInside)
    }

    func configureStackView() {
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 8
        stackView.distribution = UIStackView.Distribution.fill
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        stackView.addArrangedSubview(refreshButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        let constraints = [
            stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
