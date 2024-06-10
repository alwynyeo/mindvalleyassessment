//
//  ListChannelPresenter.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

// MARK: - ListChannelPresentationLogic Protocol
protocol ListChannelPresentationLogic {
    func presentSomething(response: ListChannel.Something.Response)
}

// MARK: - ListChannelPresenter Class
final class ListChannelPresenter {
    // MARK: - Declarations

    weak var viewController: ListChannelDisplayLogic?

    // MARK: - Object Lifecycle

    init() {}
}

// MARK: - ListChannelPresentationLogic Extension
extension ListChannelPresenter: ListChannelPresentationLogic {
    func presentSomething(response: ListChannel.Something.Response) {
        let viewModel = ListChannel.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
