//
//  AppSetting.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import Foundation
import Alamofire
import UIKit

class AppSetting {
    
    static let shared = AppSetting()
//    static let gmapsApiKey = "\(Environment.gmapsApiKey)"
//    static let gmapsAPI = "\(Environment.gmapsApi)"
//    
//    let encryptionKey:String = "\(Environment.aesKey)";
//    let encryptionIV:String = "\(Environment.aesIV)";
    
    fileprivate init() {}
    
    let kUserDefaults = UserDefaults.standard
    
    // MARK: Session variabel
    
    var email = ""
    var phoneNumber = ""
    var secretToken = ""
    var sessionToken = ""
    var appTimer = 300.0
    var isAfterLogin: Bool = false
    
    // MARK: Local Storage
    
    /// Check if user uses Bahasa language or not
    /// - Parameter isBahasa: a callback, true if user uses Bahasa language
    func isBahasaLanguage(isBahasa: (Bool) -> Void) {
        let locale = Locale.current.languageCode
        isBahasa(locale == "id")
    }
    
    func isBahasa() -> Bool {
        var value = false
        self.isBahasaLanguage { isBahasa in
            value = isBahasa
        }
        return value
    }
    
    var isBahasaSaved: Bool {
        get {
            return kUserDefaults.value(forKey: "isBahasa") as? Bool ?? isBahasa()
        }
        set(_isBahasa) {
            kUserDefaults.set(_isBahasa, forKey: "isBahasa")
            kUserDefaults.synchronize()
        }
    }
    var deviceID: String {
        get {
            return kUserDefaults.string(forKey: "deviceID") as String? ?? ""
        }
        set(_deviceID) {
            kUserDefaults.set(_deviceID, forKey: "deviceID")
            kUserDefaults.synchronize()
        }
    }
    
    var isFirstTime: Bool {
        get {
            return kUserDefaults.value(forKey: "isFirstTime") as? Bool ?? true
        }
        set(_isNewDevice) {
            kUserDefaults.set(_isNewDevice, forKey: "isFirstTime")
            kUserDefaults.synchronize()
        }
    }
    
    var cityLocation: String{
        get {
            return kUserDefaults.string(forKey: "city") as String? ?? ""
        }
        set(value) {
            kUserDefaults.set(value, forKey: "city")
            kUserDefaults.synchronize()
        }
    }
    
    var countryLocation: String{
        get {
            return kUserDefaults.string(forKey: "country") as String? ?? ""
        }
        set(value) {
            kUserDefaults.set(value, forKey: "country")
            kUserDefaults.synchronize()
        }
    }
    
    var fcmToken: String {
        get {
            return kUserDefaults.value(forKey: "fcmToken") as? String ?? ""
        }
        set(newSessionToken) {
            kUserDefaults.set(newSessionToken, forKey: "fcmToken")
            kUserDefaults.synchronize()
        }
    }
    
    var userId: String {
        get {
            return kUserDefaults.value(forKey: "userId") as? String ?? ""
        }
        set(newSessionToken) {
            kUserDefaults.set(newSessionToken, forKey: "userId")
            kUserDefaults.synchronize()
        }
    }
    
    var userName: String {
        get {
            return kUserDefaults.value(forKey: "userName") as? String ?? ""
        }
        set(newSessionToken) {
            kUserDefaults.set(newSessionToken, forKey: "userName")
            kUserDefaults.synchronize()
        }
    }
    
    var clientName: String {
        get {
            return kUserDefaults.value(forKey: "clientName") as? String ?? ""
        }
        set(value) {
            kUserDefaults.set(value, forKey: "clientName")
            kUserDefaults.synchronize()
        }
    }
    
    var clientKey: String {
        get {
            return kUserDefaults.value(forKey: "clientKey") as? String ?? ""
        }
        set(value) {
            kUserDefaults.set(value, forKey: "clientKey")
            kUserDefaults.synchronize()
        }
    }
    // MARK: HTTP Header
    
    func prepareHeader(withAuth: Bool) -> HTTPHeaders {
        // swiftlint:disable:next syntactic_sugar
        var header = Dictionary<String, String>()
        header.updateValue(Constants.ContentType.json.rawValue, forKey: Constants.HTTPHeaderField.acceptType.rawValue)
        header.updateValue(Constants.ContentType.json.rawValue, forKey: Constants.HTTPHeaderField.contentType.rawValue)
        if withAuth {
            let userToken = "Bearer " + sessionToken
            header.updateValue(userToken, forKey: "Authorization")
            header.updateValue(AppSetting.shared.deviceID, forKey: "device_id")
            header.updateValue(UIDevice.current.model, forKey: "phone_type")
            header.updateValue("iPhone", forKey: "phone_brand")
            header.updateValue(UIDevice.current.systemVersion, forKey: "OS")
        }
        return HTTPHeaders(header)
    }
    
}
