//
//  ChatRoom.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import UIKit

@available(iOS 12, *)
public class ChatRouter: BaseCoordinator{
    
    public init(window: UIWindow? = nil) {
        super.init(window: window)
    }
    
    override func setup() -> UIViewController {
        let interactor = ChatInteractor()
        let presentr = ChatPresentr(interactor: interactor, router: self)
        let view = ChatViewController(presentr: presentr)
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
