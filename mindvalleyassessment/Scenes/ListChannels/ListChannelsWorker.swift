//
//  ListChannelsWorker.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

// MARK: - ListChannelsServiceProtocol Protocol
protocol ListChannelsServiceProtocol {
    func getNewEpisode(completion: @escaping (NewEpisodeResultType) -> Void)
    func getChannel(completion: @escaping (ChannelResultType) -> Void)
    func getCategory(completion: @escaping (CategoryResultType) -> Void)
}

// MARK: - ListChannelsWorkerLogic Protocol
protocol ListChannelsWorkerLogic {
    func getLocalNewEpisode(completion: @escaping (NewEpisodeResultType) -> Void)
    func getLocalChannel(completion: @escaping (ChannelResultType) -> Void)
    func getLocalCategory(completion: @escaping (CategoryResultType) -> Void)

    func getCloudNewEpisode(completion: @escaping (NewEpisodeResultType) -> Void)
    func getCloudChannel(completion: @escaping (ChannelResultType) -> Void)
    func getCloudCategory(completion: @escaping (CategoryResultType) -> Void)
}

// MARK: - ListChannelsWorker Class
final class ListChannelsWorker {
    // MARK: - Declarations

    private let networkService: ListChannelsServiceProtocol

    private let persistenceService: ListChannelsServiceProtocol

    // MARK: - Object Lifecycle

    init(
        networkService: ListChannelsServiceProtocol,
        persistenceService: ListChannelsServiceProtocol
    ) {
        self.networkService = networkService
        self.persistenceService = persistenceService
    }

    // MARK: - Private Helpers

    private func persistNewEpisode(data: NewEpisode) {
        DispatchQueue.main.async {
            PersistenceService.shared.persist(newEpisode: data)
        }
    }

    private func persistChannel(data: Channel) {
        DispatchQueue.main.async {
            PersistenceService.shared.persist(channel: data)
        }
    }

    private func persistCategory(data: Category) {
        DispatchQueue.main.async {
            PersistenceService.shared.persist(category: data)
        }
    }

    // MARK: - Helpers
}

// MARK: - ListChannelsWorkerProtocol
extension ListChannelsWorker: ListChannelsWorkerLogic {
    // MARK: Get Local Data Helper

    func getLocalNewEpisode(completion: @escaping (NewEpisodeResultType) -> Void) {
        persistenceService.getNewEpisode { result in
            switch result {
                case .success(let data):
                    let result = NewEpisodeResultType.success(data)
                    completion(result)
                case .failure(let error):
                    let result = NewEpisodeResultType.failure(error)
                    completion(result)
            }
        }
    }

    func getLocalChannel(completion: @escaping (ChannelResultType) -> Void) {
        persistenceService.getChannel { result in
            switch result {
                case .success(let data):
                    let result = ChannelResultType.success(data)
                    completion(result)
                case .failure(let error):
                    let result = ChannelResultType.failure(error)
                    completion(result)
            }
        }
    }

    func getLocalCategory(completion: @escaping (CategoryResultType) -> Void) {
        persistenceService.getCategory { result in
            switch result {
                case .success(let data):
                    let result = CategoryResultType.success(data)
                    completion(result)
                case .failure(let error):
                    let result = CategoryResultType.failure(error)
                    completion(result)
            }
        }
    }

    // MARK: Get Cloud Data Helper

    func getCloudNewEpisode(completion: @escaping (NewEpisodeResultType) -> Void) {
        networkService.getNewEpisode { [weak self] result in
            guard let self else {
                print("self is nil under \(#function) at line \(#line) in \(#fileID) file.")
                return
            }
            switch result {
                case .success(let data):
                    persistNewEpisode(data: data)
                    let result = NewEpisodeResultType.success(data)
                    completion(result)
                case .failure(let error):
                    let result = NewEpisodeResultType.failure(error)
                    completion(result)
            }
        }
    }

    func getCloudChannel(completion: @escaping (ChannelResultType) -> Void) {
        networkService.getChannel { [weak self] result in
            guard let self else {
                print("self is nil under \(#function) at line \(#line) in \(#fileID) file.")
                return
            }
            switch result {
                case .success(let data):
                    persistChannel(data: data)
                    let result = ChannelResultType.success(data)
                    completion(result)
                case .failure(let error):
                    let result = ChannelResultType.failure(error)
                    completion(result)
            }
        }
    }

    func getCloudCategory(completion: @escaping (CategoryResultType) -> Void) {
        networkService.getCategory { [weak self] result in
            guard let self else {
                print("self is nil under \(#function) at line \(#line) in \(#fileID) file.")
                return
            }

            switch result {
                case .success(let data):
                    persistCategory(data: data)
                    let result = CategoryResultType.success(data)
                    completion(result)
                case .failure(let error):
                    let result = CategoryResultType.failure(error)
                    completion(result)
            }
        }
    }
}
