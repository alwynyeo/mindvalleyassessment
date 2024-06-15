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
    func refreshData(request: ListChannel.RefreshData.Request)
}

// MARK: - ListChannelDataStore Protocol
protocol ListChannelDataStore {}

// MARK: - ListChannelInteractor Class
final class ListChannelInteractor {
    // MARK: - Declarations

    var presenter: ListChannelPresentationLogic?

    var worker: ListChannelWorkerProtocol?

    private var newEpisodeData: NewEpisode?

    private var channelData: Channel?

    private var categoryData: Category?

    private let localDataDispatchGroup: DispatchGroup

    private let cloudDataDispatchGroup: DispatchGroup

    // MARK: - Object Lifecycle

    init() {
        let networkService = NetworkService.shared
        let persistenceService = PersistenceService.shared
        let worker = ListChannelWorker(
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

            let response = ListChannel.LoadData.Response(
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

            let response = ListChannel.LoadData.Response(
                newEpisodeData: newEpisodeData,
                channelData: channelData,
                categoryData: categoryData
            )

            print("format cloud data")
            presenter?.presentLoadedData(response: response)
        }
    }
}

// MARK: - ListChannelBusinessLogic Extension
extension ListChannelInteractor: ListChannelBusinessLogic {
    func loadData(request: ListChannel.LoadData.Request) {
        loadLocalData()
    }

    func refreshData(request: ListChannel.RefreshData.Request) {
        loadCloudData()
    }
}

// MARK: - ListChannelDataStore Extension
extension ListChannelInteractor: ListChannelDataStore {}

// MARK: - Load Local Respective Data Helpers
private extension ListChannelInteractor {
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
private extension ListChannelInteractor {
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
