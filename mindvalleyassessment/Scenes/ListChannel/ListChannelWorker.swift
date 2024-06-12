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
    func getNewEpisodes(from url: URL, completion: @escaping (NewEpisodeResultType) -> Void)
    func getChannels(from url: URL, completion: @escaping (ChannelResultType) -> Void)
    func getCategories(from url: URL, completion: @escaping (CategoryResultType) -> Void)
}

// MARK: - ListChannelWorker Class
final class ListChannelWorker {
    // MARK: - Declarations

    private let service: ListChannelServiceProtocol

    private var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "pastebin.com"
        return components
    }()

    // MARK: - Object Lifecycle

    init(service: ListChannelServiceProtocol) {
        self.service = service
    }

    // MARK: - Helpers

    func getEpisodes(completion: @escaping (NewEpisodeResultType) -> Void) {
        urlComponents.path = "/raw/z5AExTtw"

        guard let url = urlComponents.url else {
            completion(NewEpisodeResultType.failure(NetworkError.invalidUrl))
            return
        }

        service.getNewEpisodes(from: url) { result in
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

    func getChannels(completion: @escaping (ChannelResultType) -> Void) {
        urlComponents.path = "/raw/Xt12uVhM"

        guard let url = urlComponents.url else {
            completion(ChannelResultType.failure(NetworkError.invalidUrl))
            return
        }

        service.getChannels(from: url) { result in
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

    func getCategories(completion: @escaping (CategoryResultType) -> Void) {
        urlComponents.path = "/raw/A0CgArX3"

        guard let url = urlComponents.url else {
            completion(CategoryResultType.failure(NetworkError.invalidUrl))
            return
        }

        service.getCategories(from: url) { result in
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
