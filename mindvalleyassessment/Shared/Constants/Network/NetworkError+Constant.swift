//
//  NetworkError+Constant.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
    case unableToComplete
    case statusCodeNotSuccess
    case jsonDecodeFailure
}
