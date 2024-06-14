//
//  ListChannelRouter.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

// MARK: - ListChannelRoutingLogic Protocol
protocol ListChannelRoutingLogic {}

// MARK: - ListChannelDataPassing Protocol
protocol ListChannelDataPassing {
    var dataStore: ListChannelDataStore? { get }
}

// MARK: - ListChannelRouter Class
final class ListChannelRouter {
    // MARK: - Declarations
    
    weak var viewController: ListChannelsViewController?
    
    var dataStore: ListChannelDataStore?

    // MARK: - Passing Data

//    private func passDataToSomewhere(source: ListChannelDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }

    // MARK: - Navigation

//    private func navigateToSomewhere(source: ListChannelsViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }
}

// MARK: - ListChannelRoutingLogic Extension
extension ListChannelRouter: ListChannelRoutingLogic {}

// MARK: - ListChannelDataPassing Extension
extension ListChannelRouter: ListChannelDataPassing {}
