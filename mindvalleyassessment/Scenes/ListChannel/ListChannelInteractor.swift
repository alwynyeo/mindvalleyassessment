//
//  ListChannelInteractor.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

// MARK: - ListChannelBusinessLogic Protocol
protocol ListChannelBusinessLogic {
    func loadData(request: ListChannel.LoadData.Request)
}

// MARK: - ListChannelDataStore Protocol
protocol ListChannelDataStore {
    //  var name: String { get set }
}

// MARK: - ListChannelInteractor Class
final class ListChannelInteractor {
    // MARK: - Declarations

    var presenter: ListChannelPresentationLogic?
    
    var worker: ListChannelWorker?

    private var newEpisodeData: NewEpisode?

    private var channelData: Channel?

    private var categoryData: Category?

    //  var name: String = ""

    // MARK: - Object Lifecycle

    init() {
        let service = NetworkService.shared
        worker = ListChannelWorker(service: service)
    }

    // MARK: - Helpers
}

// MARK: - ListChannelBusinessLogic Extension
extension ListChannelInteractor: ListChannelBusinessLogic {
    func loadData(request: ListChannel.LoadData.Request) {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()

        worker?.getEpisodes { [weak self] result in
            guard let self else { return }

            switch result {
                case .success(let data):
                    newEpisodeData = data
                case .failure(let error):
                    print("Worker GetEpisodes Error::", error.localizedDescription)
            }

            dispatchGroup.leave()
        }

        dispatchGroup.enter()

        worker?.getChannels { [weak self] result in
            guard let self else { return }

            switch result {
                case .success(let data):
                    channelData = data
                case .failure(let error):
                    print("Worker GetChannels Error::", error.localizedDescription)
            }

            dispatchGroup.leave()
        }

        dispatchGroup.enter()

        worker?.getCategories { [weak self] result in
            guard let self else { return }

            switch result {
                case .success(let data):
                    categoryData = data
                case .failure(let error):
                    print("Worker GetCategories Error::", error.localizedDescription)
            }

            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self else { return }

            let response = ListChannel.LoadData.Response(
                newEpisodeData: newEpisodeData,
                channelData: channelData,
                categoryData: categoryData
            )

            presenter?.presentLoadedData(response: response)
        }
    }
}

// MARK: - ListChannelDataStore Extension
extension ListChannelInteractor: ListChannelDataStore {}
