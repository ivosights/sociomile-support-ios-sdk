//
//  ViewController.swift
//  SociomileSupportSDK
//
//  Created by Meynisa on 04/19/2024.
//  Copyright (c) 2024 Meynisa. All rights reserved.
//
import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class ProfileRouter: BaseCoordinator{
    init(_ navigationController: UINavigationController?) {
        super.init(navigationController)
    }
    
    override func setup() -> UIViewController {
        let view = ProfileViewController()
        self.currentNavigationController = view.navigationController
        return view
    }
    
    override func start() {
        let viewController = self.setup()
        self.parentNavigationController?.pushViewController(viewController, animated: true)
    }
}
