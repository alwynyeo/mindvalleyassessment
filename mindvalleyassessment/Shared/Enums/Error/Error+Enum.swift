//
//  NetworkError+Enum.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//

enum AppError: Error {
    case weakReference
}

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
    case unableToComplete
    case statusCodeNotSuccess
    case jsonDecodeFailure
}
