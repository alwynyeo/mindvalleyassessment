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
    func getChannels()
    func getCategories()
}

// MARK: - ListChannelWorker Class
final class ListChannelWorker {
    // MARK: - Declarations

    private let service: ListChannelServiceProtocol

    // MARK: - Object Lifecycle

    init(service: ListChannelServiceProtocol) {
        self.service = service
    }

    // MARK: - Helpers
    func getEpisodes(completion: @escaping (NewEpisodeResultType) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "pastebin.com"
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

    func getChannels() {
        
    }

    func getCategories() {}
}
