//
//  ViewController.swift
//  SociomileSupportSDK
//
//  Created by Meynisa on 04/19/2024.
//  Copyright (c) 2024 Meynisa. All rights reserved.
//
import UIKit
import SociomileSupportSDK
import Alamofire
import AlamofireImage
import RxSwift
import ImageSlideshow
import RxCocoa

class ViewController: UIViewController {
    
    var window: UIWindow?
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func handleButton(_ sender: UIButton) {
        let userId: String = "6281288682850"
        let userName: String = "Zafran"
        let clientName: String = "AAA"
        let clientKey: String = "BBB"
        
        SocioDataModel.shared.initialize(clientKey: clientKey, clientName: clientName, userId: userId, userName: userName)
        
        CustomHelper.shared.defaultColorTheme(backgroundColor: "FFFFFF", tintColor: "FF8AD8")
        CustomHelper.shared.bubbleBgColorTheme(receiverColor: "374062", senderColor: "FF6F6F")
        CustomHelper.shared.bubbleLabelColorTheme(receiverColor: "FFFFFF", senderColor: "FFFFFF")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        ChatRouter(window: self.window).start()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
