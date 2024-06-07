//
//  ChannelViewController.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/7/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

// MARK: - ChannelDisplayLogic Protocol
protocol ChannelDisplayLogic: AnyObject {
    func displaySomething(viewModel: Channel.Something.ViewModel)
}

// MARK: - ChannelViewController Class
final class ChannelViewController: UICollectionViewController {
    // MARK: - Declarations
    
    private var interactor: ChannelBusinessLogic?

    private var router: (ChannelRoutingLogic & ChannelDataPassing)?

    // MARK: - Object Lifecycle

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    convenience init() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        self.init(collectionViewLayout: collectionViewLayout)
    }

    deinit {
        print("Deinit ChannelViewController")
    }

    // MARK: - View Lifecycle

    override func loadView() {
        super.loadView()
        configureUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
    }

    // MARK: - Override Parent Methods

    // MARK: - Setup

    private func setUp() {
        let viewController = self
        let interactor = ChannelInteractor()
        let presenter = ChannelPresenter()
        let router = ChannelRouter()

        viewController.interactor = interactor
        viewController.router = router

        interactor.presenter = presenter
        presenter.viewController = viewController

        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - Interator Logic

    private func doSomething() {
        let request = Channel.Something.Request()
        interactor?.doSomething(request: request)
    }

    // MARK: - Helpers
}

// MARK: - ChannelDisplayLogic Extension
extension ChannelViewController: ChannelDisplayLogic {
    func displaySomething(viewModel: Channel.Something.ViewModel) {}
}

// MARK: - Programmatic UI Configuration
private extension ChannelViewController {
    func configureUI() {
        navigationItem.title = "Channels"
        navigationController?.navigationBar.prefersLargeTitles = true

        collectionView.backgroundColor = .systemBlue
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = true
    }
}
