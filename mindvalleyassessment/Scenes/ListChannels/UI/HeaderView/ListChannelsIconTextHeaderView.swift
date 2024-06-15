//
//  ListChannelsIconTextHeaderView.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/8/24.
//

import UIKit

final class ListChannelsIconTextHeaderView: UICollectionReusableView {
    
    // MARK: - Declarations
    
    private var section: ListChannels.Section? {
        didSet { configureSection() }
    }
    
    static let headerId = "ListChannelsIconTextHeaderView"
    
    private let channelIconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let separatorView = UIView()
    private let labelStackView = UIStackView()
    private let horizontalStackView = UIStackView()
    private let horizontalStackViewContainerView = UIView()
    private let verticalStackView = UIStackView()
    
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
    
    func configure(section: ListChannels.Section) {
        self.section = section
    }
    
    private func configureSection() {
        guard let section = section else { return }
        let title = section.title
        let subTitle = section.subTitle
        
        titleLabel.text = title
        subTitleLabel.text = subTitle
        
        if let imageUrl = section.imageUrl {
            channelIconImageView.setImage(with: imageUrl)
        }
    }
}

// MARK: - Programmatic UI Configuration
private extension ListChannelsIconTextHeaderView {
    func configureUI() {
        configureVerticalStackView()
        configureHorizontalStackViewContainerView()
        configureHorizontalStackView()
        configureLabelStackView()
        configureSubTitleLabel()
        configureTitleLabel()
        configureChannelIconImageView()
        configureSeparatorView()
    }
    
    func configureSeparatorView() {
        separatorView.backgroundColor = Color.separator
    }
    
    func configureTitleLabel() {
        titleLabel.textColor = Color.whiteText
        titleLabel.font = Font.iconTextSectionTitle
        titleLabel.setContentHuggingPriority(
            UILayoutPriority.defaultLow,
            for: NSLayoutConstraint.Axis.vertical
        )
    }
    
    func configureSubTitleLabel() {
        subTitleLabel.textColor = Color.grayText
        subTitleLabel.font = Font.iconTextSectionSubtitle
        subTitleLabel.setContentHuggingPriority(
            UILayoutPriority.defaultHigh,
            for: NSLayoutConstraint.Axis.vertical
        )
    }
    
    func configureLabelStackView() {
        labelStackView.axis = NSLayoutConstraint.Axis.vertical
        labelStackView.spacing = 0
        labelStackView.alignment = UIStackView.Alignment.fill
        labelStackView.distribution = UIStackView.Distribution.fill
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subTitleLabel)
    }
    
    func configureChannelIconImageView() {
        channelIconImageView.contentMode = UIView.ContentMode.scaleAspectFill
        channelIconImageView.clipsToBounds = true
        channelIconImageView.layer.cornerRadius = 25
        channelIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            channelIconImageView.widthAnchor.constraint(equalToConstant: 50),
            channelIconImageView.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configureHorizontalStackView() {
        horizontalStackView.axis = NSLayoutConstraint.Axis.horizontal
        horizontalStackView.spacing = 14
        horizontalStackView.alignment = UIStackView.Alignment.center
        horizontalStackView.distribution = UIStackView.Distribution.fill
        horizontalStackView.addArrangedSubview(channelIconImageView)
        horizontalStackView.addArrangedSubview(labelStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            horizontalStackView.topAnchor.constraint(equalTo: horizontalStackViewContainerView.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: horizontalStackViewContainerView.leadingAnchor, constant: 10),
            horizontalStackView.trailingAnchor.constraint(equalTo: horizontalStackViewContainerView.trailingAnchor, constant: -10),
            horizontalStackView.bottomAnchor.constraint(equalTo: horizontalStackViewContainerView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configureHorizontalStackViewContainerView() {
        horizontalStackViewContainerView.addSubview(horizontalStackView)
    }
    
    func configureVerticalStackView() {
        verticalStackView.axis = NSLayoutConstraint.Axis.vertical
        verticalStackView.spacing = 20
        verticalStackView.alignment = UIStackView.Alignment.fill
        verticalStackView.distribution = UIStackView.Distribution.fill
        verticalStackView.addArrangedSubview(separatorView)
        verticalStackView.addArrangedSubview(horizontalStackViewContainerView)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(verticalStackView)
        
        let constraints = [
            verticalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
