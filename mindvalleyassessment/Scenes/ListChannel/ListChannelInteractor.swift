//
//  ListChannelInteractor.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

// MARK: - ListChannelBusinessLogic Protocol
protocol ListChannelBusinessLogic {
    func doSomething(request: ListChannel.Something.Request)
}

// MARK: - ListChannelDataStore Protocol
protocol ListChannelDataStore {
    //  var name: String { get set }
}

// MARK: - ListChannelInteractor Class
final class ListChannelInteractor {
    // MARK: - Declarations

    var presenter: ListChannelPresentationLogic?
    
    var worker: ListChannelWorker?
    //  var name: String = ""

    // MARK: - Object Lifecycle

    init() {
        let service = ChannelNetworkService()
        worker = ListChannelWorker(service: service)
    }
}

// MARK: - ListChannelBusinessLogic Extension
extension ListChannelInteractor: ListChannelBusinessLogic {
    func doSomething(request: ListChannel.Something.Request) {
        worker?.getEpisodes { result in
            switch result {
                case .success(let success):
                    print("New Episodes", success)
                case .failure(let error):
                    print("Error::", error.localizedDescription)
            }
        }
//        let response = ListChannel.Something.Response()
//        presenter?.presentSomething(response: response)
    }
}

// MARK: - ListChannelDataStore Extension
extension ListChannelInteractor: ListChannelDataStore {}
