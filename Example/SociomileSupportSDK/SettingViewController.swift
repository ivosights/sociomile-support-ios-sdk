//
//  SettingViewController.swift
//  SociomileSupportSDK_Example
//
//  Created by Meynisa on 14/05/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import SociomileSupportSDK
import Alamofire
import AlamofireImage
import RxSwift
import ImageSlideshow
import RxCocoa

class SettingViewController: UIViewController{
    
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var qnaButton: UIButton!
    @IBOutlet weak var liveChatButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Setting"
        profileLabel.text = "Hello, John Doe..."
    }
    
    @IBAction func handleHelpButton(_ sender: UIButton) {
        let userId: String = "6281288682850"
        let userName: String = "Zafran"
        let clientName: String = "AAA"
        let clientKey: String = "BBB"
        
        SocioDataModel.shared.initialize(clientKey: clientKey, clientName: clientName, userId: userId, userName: userName)
        
        CustomHelper.shared.defaultColorTheme(backgroundColor: "FFFFFF", tintColor: "FF8AD8")
        CustomHelper.shared.bubbleBgColorTheme(receiverColor: "374062", senderColor: "FF6F6F")
        CustomHelper.shared.bubbleLabelColorTheme(receiverColor: "FFFFFF", senderColor: "FFFFFF")
        
//        self.window = UIWindow(frame: UIScreen.main.bounds)
        ChatRouter(self.navigationController).start()
    }
    
    @IBAction func handleQnQ(_ sender: UIButton) {
        ProfileRouter(self.navigationController).start()
    }
    
    @IBAction func handleLiveChatButton(_ sender: UIButton) {
        LiveChatRouter(self.navigationController).start()
    }
    
}
