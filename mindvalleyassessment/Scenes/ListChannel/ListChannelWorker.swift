//
//  ListChannelWorker.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

// MARK: - ListChannelServiceProtocol Protocol
protocol ListChannelServiceProtocol {
    func getNewEpisodes(completion: @escaping (NewEpisodeResultType) -> Void)
    func getChannels(completion: @escaping (ChannelResultType) -> Void)
    func getCategories(completion: @escaping (CategoryResultType) -> Void)
}

// MARK: - ListChannelWorker Class
final class ListChannelWorker {
    // MARK: - Declarations

    private let networkService: ListChannelServiceProtocol

    private let persistenceService: ListChannelServiceProtocol

    // MARK: - Object Lifecycle

    init(
        networkService: ListChannelServiceProtocol,
        persistenceService: ListChannelServiceProtocol
    ) {
        self.networkService = networkService
        self.persistenceService = persistenceService
    }

    // MARK: - Helpers

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
}

// MARK: - Local Data Related Helpers
extension ListChannelWorker {
    func getLocalNewEpisodes(completion: @escaping (NewEpisodeResultType) -> Void) {
        persistenceService.getNewEpisodes { result in
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

    func getLocalChannels(completion: @escaping (ChannelResultType) -> Void) {
        persistenceService.getChannels { result in
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

    func getLocalCategories(completion: @escaping (CategoryResultType) -> Void) {
        persistenceService.getCategories { result in
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
}

// MARK: - Cloud Data Related Helpers
extension ListChannelWorker {
    func getCloudNewEpisodes(completion: @escaping (NewEpisodeResultType) -> Void) {
        networkService.getNewEpisodes { [weak self] result in
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

    func getCloudChannels(completion: @escaping (ChannelResultType) -> Void) {
        networkService.getChannels { [weak self] result in
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

    func getCloudCategories(completion: @escaping (CategoryResultType) -> Void) {
        networkService.getCategories { [weak self] result in
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
