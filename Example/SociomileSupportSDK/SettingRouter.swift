//
//  SecondViewController.swift
//  SociomileSupportSDK_Example
//
//  Created by Meynisa on 14/05/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class SettingRouter: BaseCoordinator{
    public init(window: UIWindow? = nil) {
        super.init(window: window)
    }
    
    override func setup() -> UIViewController {
        let view = SettingViewController()
        self.currentNavigationController = view.navigationController
        return view
    }
    
    public override func start() {
        let viewController = self.setup()
        
        let navigationController = UINavigationController(rootViewController: viewController)
        self.currentNavigationController = navigationController
        
        
        self.parentWindow?.rootViewController = navigationController
        self.parentWindow?.makeKeyAndVisible()
    }
}

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
