//
//  CustomHelper.swift
//  SociomileIosSDKLibrary
//
//  Created by Meynisa on 26/03/24.
//

import Foundation
import UIKit

public class CustomHelper: ObservableObject{
    
    @Published private(set) var colorConnectivity: String = "C03232"
    @Published private(set) var lblColorConnectivity: String = "FFFFFF"
    
    @Published private(set) var colorBackBtn: String = "FFFFFF"
    @Published private(set) var bgAppbar: String = "424242"
    @Published private(set) var colorAppbar: String = "FFFFFF"
    
    @Published private(set) var lblColorMsgHeader: String = "FFFFFF"
    @Published private(set) var lblColorDateMsg: String = "B5B8B5"
    @Published private(set) var bgScreen: String = "5E5E5E"
    
    @Published private(set) var colorBgIconDefault: String = "6E8597"
    @Published private(set) var colorIconDefault: String = "6E8597"
    @Published private(set) var lblColorThemeDefault: String = "FFFFFF"
    @Published private(set) var bgTextContainer: String = "C0C0C0"
    
    @Published private(set) var lblColorMsgSender: String = "FFFFFF"
    @Published private(set) var lblColorMsgReceiver: String = "FFFFFF"
    
    @Published private(set) var bgColorSender: String = "BCC8E7"
    @Published private(set) var bgColorReceiver: String = "57B77D"
    
    public func appBarColorTheme(iconColor: String = "FFFFFF", bgColor: String = "424242", labelColor: String = "FFFFFF"){
        self.colorBackBtn = iconColor
        self.bgAppbar = bgColor
        self.colorAppbar = labelColor
    }
    
    public func contentColorTheme(labelHeaderColor: String = "FFFFFF", labelDateColor: String = "B5B8B5", bgColor: String = "5E5E5E"){
        self.lblColorMsgHeader = labelHeaderColor
        self.lblColorDateMsg = labelDateColor
        self.bgScreen = bgColor
    }
    
    public func bubbleBgColorTheme(receiverColor: String = "57B77D", senderColor: String = "BCC8E7") {
        self.bgColorReceiver = receiverColor
        self.bgColorSender = senderColor
    }
    
    public func bubbleLabelColorTheme(receiverColor: String = "FFFFFF", senderColor: String = "FFFFFF") {
        self.lblColorMsgReceiver = receiverColor
        self.lblColorMsgSender = senderColor
    }
    
    public func defaultColorTheme(backgroundColor: String = "6E8597", tintColor: String = "6E8597", labelColor: String = "FFFFFF", bgColorTextContainer: String = "C0C0C0"){
        self.colorBgIconDefault = backgroundColor
        self.colorIconDefault = tintColor
        self.lblColorThemeDefault = labelColor
        self.bgTextContainer = bgColorTextContainer
    }
    
    public func connectivityColorTheme(backgroundColor: String = "C03232", labelColor: String = "FFFFFF"){
        self.lblColorConnectivity = labelColor
        self.colorConnectivity = backgroundColor
    }
}

extension CustomHelper{
    public static let shared = mockModel()
    
    public static func mockModel() -> CustomHelper{
        return CustomHelper()
    }
}
