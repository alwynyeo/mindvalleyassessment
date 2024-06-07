//
//  ChannelInteractor.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/7/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

// MARK: - ChannelBusinessLogic Protocol
protocol ChannelBusinessLogic {
    func doSomething(request: Channel.Something.Request)
}

// MARK: - ChannelDataStore Protocol
protocol ChannelDataStore {
    //  var name: String { get set }
}

// MARK: - ChannelInteractor Class
final class ChannelInteractor {
    // MARK: - Declarations

    var presenter: ChannelPresentationLogic?
    
    var worker: ChannelWorker?
    //  var name: String = ""

    // MARK: - Object Lifecycle

    init() {}
}

// MARK: - ChannelBusinessLogic Extension
extension ChannelInteractor: ChannelBusinessLogic {
    func doSomething(request: Channel.Something.Request) {
        worker = ChannelWorker()
        worker?.doSomeWork()
        
        let response = Channel.Something.Response()
        presenter?.presentSomething(response: response)
    }
}

// MARK: - ChannelDataStore Extension
extension ChannelInteractor: ChannelDataStore {}
