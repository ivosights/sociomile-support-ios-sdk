//
//  ExtNavigationController.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import UIKit

extension UINavigationController {
    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
}
