//
//  ChannelNetworkService.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//

import Foundation

final class NetworkService: ListChannelServiceProtocol {
    // MARK: - Declarations

    static let shared = NetworkService()

    private let urlSession = URLSession.shared

    private let decoder = JSONDecoder()

    // MARK: - Object Lifecycle

    private init() {}

    // MARK: - Methods

    func getNewEpisodes(from url: URL, completion: @escaping (NewEpisodeResultType) -> Void) {
        let task = urlSession.dataTask(with: url) { [unowned self] data, response, error in
            let result: NewEpisodeResultType

            defer {
                completion(result)
            }

            guard error == nil else {
                result = NewEpisodeResultType.failure(NetworkError.unableToComplete)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                result = NewEpisodeResultType.failure(NetworkError.invalidResponse)
                return
            }

            let statusCode = response.statusCode

            guard statusCode == NetworkStatusCode.success.rawValue else {
                result = NewEpisodeResultType.failure(NetworkError.statusCodeNotSuccess)
                return
            }

            guard let data = data else {
                result = NewEpisodeResultType.failure(NetworkError.invalidData)
                return
            }

            do {
                let decodedData = try decoder.decode(NewEpisode.self, from: data)
                result = NewEpisodeResultType.success(decodedData)
            } catch {
                result = NewEpisodeResultType.failure(NetworkError.jsonDecodeFailure)
            }
        }

        task.resume()
    }

    func getChannels() {
        print(2)
    }
    
    func getCategories() {
        print(3)
    }
}
