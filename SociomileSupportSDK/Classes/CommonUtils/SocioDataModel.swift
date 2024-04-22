//
//  SocioDataModel.swift
//  SociomileIosSDKLibrary
//
//  Created by Meynisa on 25/03/24.
//

import Foundation
import UIKit
import Combine

//@available(iOS 13.0, *)
public class SocioDataModel: ObservableObject {
    @Published private(set) var notif: NSDictionary?
    @Published private(set) var token: String?

    @Published private(set) var clientKey: String?
    @Published private(set) var clientId: String?
    @Published private(set) var userId: String?
    @Published private(set) var userName: String?

    @Published private(set) var logger: Bool? = false
    @Published private(set) var darkMode: Bool? = false
   
    /// Sending data notification from firebase cloud messaging FCM to Sociomile SDK
    public func notification(_ data: NSDictionary) {
        self.notif = data
        logger ?? false ? print("NOTIF: ",self.notif!) : nil
        NotificationCenter.default.post(name: SystemNotification.newEvent, object: nil, userInfo: data as? [AnyHashable : Any])
    }
    
    /// Token that you get from firebase cloud messaging (FCM) that send a message to a specific device
    public func fcmToken(_ data: String) {
        self.token = data
        AppSetting.shared.fcmToken = data
    }

    /// Initialize user authentication before the SDK activity called
    /// - Parameters:
    ///   - clientKey: A developer ID that can be obtain from Admin of Sociomile by contacting via WA or email
    ///   - clientId: A developer secret key that can be obtain from Admin of Sociomile by contacting via WA or email
    ///   - userId: An unique ID that can be obtain from user profile
    ///   - userName: An username that can be obtain from user profile
    public func initialize(clientKey: String, clientName: String, userId: String, userName: String){
        self.clientKey = clientKey
        self.clientId = clientName
        self.userId = userId
        self.userName = userName
        
        AppSetting.shared.userId = userId
        AppSetting.shared.userName = userName
        AppSetting.shared.clientName = clientName
        AppSetting.shared.clientKey = clientKey
    }

    /// Activate logger in console
    ///  - Description:
    ///  Logging is enable by default in debug mode and automatically disable in production mode. You can either enable and disable it
    public func setLog(_ logger: Bool){
        self.logger = logger
    }

    /// Activate dark mode UI SDK
    /// - Description:
    /// If you choose false even though dark mode from mobile system activated, UI SDK not change to dark mode/ not influenced by mobile theme mode. But if you choose true, then when dark mode from mobile system activated, UI SDK change to dark mode. Dark Mode already have custom UI
    public func setDarkMode(_ darkMode: Bool){
        self.darkMode = darkMode
    }
    
}

//@available(iOS 13.0, *)
extension SocioDataModel {
    public static let shared = mockModel()

    public static func mockModel() -> SocioDataModel {
    let socioModel = SocioDataModel()
    return socioModel
  }
}
