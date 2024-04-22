//
//  BaseCoordinator.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import UIKit

protocol Coordinator {
    var parentNavigationController: UINavigationController? { get }
    var parentWindow: UIWindow? { get }
    func setup() -> UIViewController
}

public class BaseCoordinator: Coordinator {
    weak var parentNavigationController: UINavigationController?
    weak var parentWindow: UIWindow?
    weak var currentNavigationController: UINavigationController?

     public init(_ navigationController: UINavigationController? = nil, window: UIWindow? = nil) {
        self.parentNavigationController = navigationController
        self.parentWindow = window
    }

    func setup() -> UIViewController {
        // Override in subclass
        fatalError("This function MUST be overridden in subclasses")
    }
    
    func start() { }
    func close() { }
}
