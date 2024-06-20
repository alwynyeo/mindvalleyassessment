//
//  ListChannelsInteractor.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

// MARK: - ListChannelsBusinessLogic Protocol
protocol ListChannelsBusinessLogic {
    func loadData(request: ListChannels.LoadData.Request)
    func refreshData(request: ListChannels.RefreshData.Request)
}

// MARK: - ListChannelsDataStore Protocol
protocol ListChannelsDataStore {}

// MARK: - ListChannelsInteractor Class
final class ListChannelsInteractor {
    // MARK: - Declarations

    var presenter: ListChannelsPresentationLogic?

    var worker: ListChannelsWorkerLogic?

    private var newEpisodeData: NewEpisode?

    private var channelData: Channel?

    private var categoryData: Category?

    private let localDataDispatchGroup: DispatchGroup

    private let cloudDataDispatchGroup: DispatchGroup

    // MARK: - Object Lifecycle

    init() {
        let networkService = NetworkService.shared
        let persistenceService = PersistenceService.shared
        let worker = ListChannelsWorker(
            networkService: networkService,
            persistenceService: persistenceService
        )
        let localDataDispatchGroup = DispatchGroup()
        let cloudDataDispatchGroup = DispatchGroup()
        self.worker = worker
        self.localDataDispatchGroup = localDataDispatchGroup
        self.cloudDataDispatchGroup = cloudDataDispatchGroup
    }

    // MARK: - Helpers

    private func loadLocalData() {
        print("run data from core data")
        loadLocalNewEpisodes()
        loadLocalChannels()
        loadLocalCategories()

        localDataDispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self else {
                print("self is nil under \(#function) at line \(#line) in \(#fileID) file.")
                return
            }

            let response = ListChannels.LoadData.Response(
                newEpisodeData: newEpisodeData,
                channelData: channelData,
                categoryData: categoryData
            )

            print("format local data")
            presenter?.presentLoadedData(response: response)

            // MARK: Load the latest data from the cloud
            loadCloudData()
        }
    }

    private func loadCloudData() {
        print("run data from network")
        loadCloudNewEpisodes()
        loadCloudChannels()
        loadCloudCategories()

        cloudDataDispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self else {
                print("self is nil under \(#function) at line \(#line) in \(#fileID) file.")
                return
            }

            let response = ListChannels.LoadData.Response(
                newEpisodeData: newEpisodeData,
                channelData: channelData,
                categoryData: categoryData
            )

            print("format cloud data")
            presenter?.presentLoadedData(response: response)
        }
    }
}

// MARK: - ListChannelsBusinessLogic Extension
extension ListChannelsInteractor: ListChannelsBusinessLogic {
    func loadData(request: ListChannels.LoadData.Request) {
        loadLocalData()
    }

    func refreshData(request: ListChannels.RefreshData.Request) {
        loadCloudData()
    }
}

// MARK: - ListChannelsDataStore Extension
extension ListChannelsInteractor: ListChannelsDataStore {}

// MARK: - Load Local Respective Data Helpers
private extension ListChannelsInteractor {
    func loadLocalNewEpisodes() {
        localDataDispatchGroup.enter()

        worker?.getLocalNewEpisode { [weak self] result in
            guard let self else {
                print("self is nil under \(#function) at line \(#line) in \(#fileID) file.")
                return
            }

            switch result {
                case .success(let data):
                    newEpisodeData = data
                case .failure(let error):
                    print("Worker LocalGetNewEpisodes Error::", error.localizedDescription)
            }

            localDataDispatchGroup.leave()
        }
    }

    func loadLocalChannels() {
        localDataDispatchGroup.enter()

        worker?.getLocalChannel { [weak self] result in
            guard let self else {
                print("self is nil under \(#function) at line \(#line) in \(#fileID) file.")
                return
            }

            switch result {
                case .success(let data):
                    channelData = data
                case .failure(let error):
                    print("Worker LocalGetChannels Error::", error.localizedDescription)
            }

            localDataDispatchGroup.leave()
        }
    }

    func loadLocalCategories() {
        localDataDispatchGroup.enter()

        worker?.getLocalCategory { [weak self] result in
            guard let self else {
                print("self is nil under \(#function) at line \(#line) in \(#fileID) file.")
                return
            }

            switch result {
                case .success(let data):
                    categoryData = data
                case .failure(let error):
                    print("Worker LocalGetCategories Error::", error.localizedDescription)
            }

            localDataDispatchGroup.leave()
        }
    }
}

// MARK: - Load Cloud Data Related Helpers
private extension ListChannelsInteractor {
    func loadCloudNewEpisodes() {
        cloudDataDispatchGroup.enter()

        worker?.getCloudNewEpisode { [weak self] result in
            guard let self else {
                print("self is nil under \(#function) at line \(#line) in \(#fileID) file.")
                return
            }

            switch result {
                case .success(let data):
                    newEpisodeData = data
                case .failure(let error):
                    print("Worker CloudGetNewEpisodes Error::", error.localizedDescription)
            }

            cloudDataDispatchGroup.leave()
        }
    }

    func loadCloudChannels() {
        cloudDataDispatchGroup.enter()

        worker?.getCloudChannel { [weak self] result in
            guard let self else {
                print("self is nil under \(#function) at line \(#line) in \(#fileID) file.")
                return
            }

            switch result {
                case .success(let data):
                    channelData = data
                case .failure(let error):
                    print("Worker CloudGetChannels Error::", error.localizedDescription)
            }

            cloudDataDispatchGroup.leave()
        }
    }

    func loadCloudCategories() {
        cloudDataDispatchGroup.enter()

        worker?.getCloudCategory { [weak self] result in
            guard let self else {
                print("self is nil under \(#function) at line \(#line) in \(#fileID) file.")
                return
            }

            switch result {
                case .success(let data):
                    categoryData = data
                case .failure(let error):
                    print("Worker GetCategories Error::", error.localizedDescription)
            }

            cloudDataDispatchGroup.leave()
        }
    }
}
