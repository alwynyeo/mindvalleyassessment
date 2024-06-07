//
//  ChannelRouter.swift
//  mindvalleyassessment
//
//  Created by Alwyn Yeo on 6/7/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

// MARK: - ChannelRoutingLogic Protocol
protocol ChannelRoutingLogic {
    //  func routeToSomewhere(segue: UIStoryboardSegue?)
}

// MARK: - ChannelDataPassing Protocol
protocol ChannelDataPassing {
    var dataStore: ChannelDataStore? { get }
}

// MARK: - ChannelRouter Class
final class ChannelRouter {
    // MARK: - Declarations
    
    weak var viewController: ChannelViewController?
    
    var dataStore: ChannelDataStore?

    // MARK: - Passing Data

//    private func passDataToSomewhere(source: ChannelDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }

    // MARK: - Navigation

//    private func navigateToSomewhere(source: ChannelViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }
}

// MARK: - ChannelRoutingLogic Extension
extension ChannelRouter: ChannelRoutingLogic {
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

// MARK: - ChannelDataPassing Extension
extension ChannelRouter: ChannelDataPassing {}
