//
//  ListChannelRouter.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/10/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

// MARK: - ListChannelRoutingLogic Protocol
protocol ListChannelRoutingLogic {
    //  func routeToSomewhere(segue: UIStoryboardSegue?)
}

// MARK: - ListChannelDataPassing Protocol
protocol ListChannelDataPassing {
    var dataStore: ListChannelDataStore? { get }
}

// MARK: - ListChannelRouter Class
final class ListChannelRouter {
    // MARK: - Declarations
    
    weak var viewController: ListChannelViewController?
    
    var dataStore: ListChannelDataStore?

    // MARK: - Passing Data

//    private func passDataToSomewhere(source: ListChannelDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }

    // MARK: - Navigation

//    private func navigateToSomewhere(source: ListChannelViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }
}

// MARK: - ListChannelRoutingLogic Extension
extension ListChannelRouter: ListChannelRoutingLogic {
//    func routeToSomewhere(segue: UIStoryboardSegue?) {
//        if let segue = segue {
//            let destinationVC = segue.destination as! SomewhereViewController
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToSomewhere(source: dataStore!, destination: &destinationDS)
//        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
//            var destinationDS = destinationVC.router!.dataStore!
//            passDataToSomewhere(source: dataStore!, destination: &destinationDS)
//            navigateToSomewhere(source: viewController!, destination: destinationVC)
//        }
//    }
}

// MARK: - ListChannelDataPassing Extension
extension ListChannelRouter: ListChannelDataPassing {}
