//
//  ListChannelsRouter.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

// MARK: - ListChannelsRoutingLogic Protocol
protocol ListChannelsRoutingLogic {}

// MARK: - ListChannelsDataPassing Protocol
protocol ListChannelsDataPassing {
    var dataStore: ListChannelsDataStore? { get }
}

// MARK: - ListChannelsRouter Class
final class ListChannelsRouter {
    // MARK: - Declarations
    
    weak var viewController: ListChannelsViewController?
    
    var dataStore: ListChannelsDataStore?

    // MARK: - Passing Data

//    private func passDataToSomewhere(source: ListChannelsDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }

    // MARK: - Navigation

//    private func navigateToSomewhere(source: ListChannelsViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }
}

// MARK: - ListChannelsRoutingLogic Extension
extension ListChannelsRouter: ListChannelsRoutingLogic {}

// MARK: - ListChannelsDataPassing Extension
extension ListChannelsRouter: ListChannelsDataPassing {}
