//
//  ChannelsNetworkService.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//

import Foundation

final class NetworkService {
    // MARK: - Declarations

    static let shared = NetworkService()

    private var urlSession: URLSession

    private let decoder: JSONDecoder

    private var urlComponents: URLComponents

    // MARK: - Object Lifecycle

    private init() {
        // URLSession
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.waitsForConnectivity = true
        urlSessionConfiguration.multipathServiceType = URLSessionConfiguration.MultipathServiceType.handover
        urlSessionConfiguration.allowsCellularAccess = true
        urlSessionConfiguration.timeoutIntervalForRequest = 30 // 30 seconds
        urlSessionConfiguration.timeoutIntervalForResource = 15 // 10 seconds
        urlSession = URLSession(configuration: urlSessionConfiguration)

        // JSONDecoder
        let decoder = JSONDecoder()
        self.decoder = decoder

        // URLComponents
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "pastebin.com"
        self.urlComponents = urlComponents
    }
}

// MARK: - ListChannelsServiceProtocol
extension NetworkService: ListChannelsServiceLogic {
    func getNewEpisode(completion: @escaping (NewEpisodeResultType) -> Void) {
        urlComponents.path = "/raw/z5AExTtw"

        guard let url = urlComponents.url else {
            completion(NewEpisodeResultType.failure(NetworkError.invalidUrl))
            return
        }

        let task = urlSession.dataTask(with: url) { [weak self] data, response, error in
            let result: NewEpisodeResultType

            defer {
                completion(result)
            }

            guard let self else {
                result = NewEpisodeResultType.failure(AppError.weakReference)
                return
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

    func getChannel(completion: @escaping (ChannelResultType) -> Void) {
        urlComponents.path = "/raw/Xt12uVhM"

        guard let url = urlComponents.url else {
            completion(ChannelResultType.failure(NetworkError.invalidUrl))
            return
        }

        let task = urlSession.dataTask(with: url) { [weak self] data, response, error in
            let result: ChannelResultType

            defer {
                completion(result)
            }

            guard let self else {
                result = ChannelResultType.failure(AppError.weakReference)
                return
            }

            guard error == nil else {
                result = ChannelResultType.failure(NetworkError.unableToComplete)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                result = ChannelResultType.failure(NetworkError.invalidResponse)
                return
            }

            let statusCode = response.statusCode

            guard statusCode == NetworkStatusCode.success.rawValue else {
                result = ChannelResultType.failure(NetworkError.statusCodeNotSuccess)
                return
            }

            guard let data = data else {
                result = ChannelResultType.failure(NetworkError.invalidData)
                return
            }

            do {
                let decodedData = try decoder.decode(Channel.self, from: data)
                result = ChannelResultType.success(decodedData)
            } catch {
                result = ChannelResultType.failure(NetworkError.jsonDecodeFailure)
            }
        }

        task.resume()
    }

    func getCategory(completion: @escaping (CategoryResultType) -> Void) {
        urlComponents.path = "/raw/A0CgArX3"

        guard let url = urlComponents.url else {
            completion(CategoryResultType.failure(NetworkError.invalidUrl))
            return
        }

        let task = urlSession.dataTask(with: url) { [weak self] data, response, error in
            let result: CategoryResultType

            defer {
                completion(result)
            }

            guard let self else {
                result = CategoryResultType.failure(AppError.weakReference)
                return
            }

            guard error == nil else {
                result = CategoryResultType.failure(NetworkError.unableToComplete)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                result = CategoryResultType.failure(NetworkError.invalidResponse)
                return
            }

            let statusCode = response.statusCode

            guard statusCode == NetworkStatusCode.success.rawValue else {
                result = CategoryResultType.failure(NetworkError.statusCodeNotSuccess)
                return
            }

            guard let data = data else {
                result = CategoryResultType.failure(NetworkError.invalidData)
                return
            }

            do {
                let decodedData = try decoder.decode(Category.self, from: data)
                result = CategoryResultType.success(decodedData)
            } catch {
                result = CategoryResultType.failure(NetworkError.jsonDecodeFailure)
            }
        }

        task.resume()
    }
}
