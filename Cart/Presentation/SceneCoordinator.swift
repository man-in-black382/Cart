//
//  SceneCoordinator.swift
//  Cart
//
//  Created by Pavlo Muratov on 28.09.17.
//  Copyright © 2017 MPO. All rights reserved.
//

import UIKit

enum SceneCoordinationError: Error {
    case pushFailure(String)
    case popFailure(String)
}

class SceneCoordinator {
    
    // MARK: - Properties
    
    fileprivate var window: UIWindow
    fileprivate var currentViewController: UIViewController
    
    // MARK: - Lifecycle
    
    required init(window: UIWindow) {
        self.window = window
        currentViewController = window.rootViewController!
    }
    
    // MARK: - Private
    
    private static func actualViewController(for viewController: UIViewController) -> UIViewController {
        if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.first!
        } else {
            return viewController
        }
    }
    
    // MARK: - Public
    
    func transition(to scene: Scene, type: SceneTransitionType) throws {
        let viewController = scene.viewController()
        switch type {
        case .root:
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
            window.rootViewController = viewController
            
        case .push:
            guard let navigationController = currentViewController.navigationController else {
                throw SceneCoordinationError.pushFailure("Can't push a view controller without a current navigation controller")
            }
            navigationController.pushViewController(viewController, animated: true)
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
            
        case .modal:
            currentViewController.present(viewController, animated: true)
            currentViewController = SceneCoordinator.actualViewController(for: viewController)
        }
    }
    
    func pop(animated: Bool = true) throws {
        if let presenter = currentViewController.presentingViewController {
            currentViewController.dismiss(animated: animated) {
                self.currentViewController = SceneCoordinator.actualViewController(for: presenter)
            }
        } else if let navigationController = currentViewController.navigationController {
            guard navigationController.popViewController(animated: animated) != nil else {
                throw SceneCoordinationError.popFailure("Can't navigate back in navigation stack from \(currentViewController)")
            }
            currentViewController = SceneCoordinator.actualViewController(for: navigationController.viewControllers.last!)
        } else {
            throw SceneCoordinationError.popFailure("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
        }
    }
}
