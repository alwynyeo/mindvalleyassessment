//
//  ChannelPresenter.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/7/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

// MARK: - ChannelPresentationLogic Protocol
protocol ChannelPresentationLogic {
    func presentSomething(response: Channel.Something.Response)
}

// MARK: - ChannelPresenter Class
final class ChannelPresenter {
    // MARK: - Declarations

    weak var viewController: ChannelDisplayLogic?

    // MARK: - Object Lifecycle

    init() {}
}

// MARK: - ChannelPresentationLogic Extension
extension ChannelPresenter: ChannelPresentationLogic {
    func presentSomething(response: Channel.Something.Response) {
        let viewModel = Channel.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
