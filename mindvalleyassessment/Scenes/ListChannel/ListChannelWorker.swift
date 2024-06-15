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
    func getNewEpisode(completion: @escaping (NewEpisodeResultType) -> Void)
    func getChannel(completion: @escaping (ChannelResultType) -> Void)
    func getCategory(completion: @escaping (CategoryResultType) -> Void)
}

protocol ListChannelWorkerProtocol {
    func getLocalNewEpisode(completion: @escaping (NewEpisodeResultType) -> Void)
    func getLocalChannel(completion: @escaping (ChannelResultType) -> Void)
    func getLocalCategory(completion: @escaping (CategoryResultType) -> Void)

    func getCloudNewEpisode(completion: @escaping (NewEpisodeResultType) -> Void)
    func getCloudChannel(completion: @escaping (ChannelResultType) -> Void)
    func getCloudCategory(completion: @escaping (CategoryResultType) -> Void)
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

// MARK: - ListChannelWorkerProtocol
extension ListChannelWorker: ListChannelWorkerProtocol {
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
