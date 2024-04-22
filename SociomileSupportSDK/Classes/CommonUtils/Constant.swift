//
//  Constant.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import UIKit
// MARK: - API
struct Constants {
    
    // MARK: - API
    
    static let baseUrl = "http://bebas-sm.s45.in:810"//"\(Environment.baseURL)"
    // swiftlint:disable line_length
//    static let publicKey = "-----BEGIN PUBLIC KEY-----\n\(Environment.pbkOTP)\n-----END PUBLIC KEY-----"
//    static let publicKeyMpin = "-----BEGIN PUBLIC KEY-----\n\(Environment.pbkMpin)\n-----END PUBLIC KEY-----"
//    static let publicKeyPassword = "-----BEGIN PUBLIC KEY-----\n\(Environment.pbkPass)\n-----END PUBLIC KEY-----"
    // swiftlint:enable line_length
    enum HTTPHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }

    enum ContentType: String {
        case json = "application/json"
    }
    
    // MARK: - Other
    
    static let hiddenChar: Character = "*"
    
    static func getVersionNumber() -> String {
        var version: String
        if let versionDetail = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            let versionText = versionDetail.filter("0123456789.".contains)
            version = versionText
        } else {
            version = ""
        }
        return version
    }
    static let osName = UIDevice.current.systemVersion
    static let osType = "iOS"
    
    static let contactNumber = "1500278"
}

// MARK: - Color
struct AppColor {
    static let primaryBlueMedium = UIColor.init(hexaRGB: "#0061A7")
    static let primaryDarkMedium = UIColor.init(hexaRGB: "#374062")
    static let neutralGrayMedium = UIColor.init(hexaRGB: "#BCC8E7")
    static let neutralGraySoftMedium = UIColor.init(hexaRGB: "#B3C1E7")
    static let neutralGraySoft = UIColor.init(hexaRGB: "#DDEBF9")
    static let neutralGrayUltraSoft = UIColor.init(hexaRGB: "#F5FAFF")
    static let notifWarningMedium = UIColor.init(hexaRGB: "#FF6F6F")
    static let notifInfoMedium = UIColor.init(hexaRGB: "#66A3FF")
    static let warningYellow = UIColor.init(hexaRGB: "#FFC100")
    static let lightGreen = UIColor.init(hexaRGB: "#91E1BB")
    static let neutralDarkHard = UIColor.init(hexaRGB: "#44495B")
    static let textDark = UIColor.init(hexaRGB: "#2B2F3C")
    static let textDarkGray = UIColor.init(hexaRGB: "#727C98")
    static let neutralDarkMedium = UIColor.init(hexaRGB: "#7B87AF")
    static let aquaPrimary = UIColor.init(hexaRGB: "#E5F2FF")
    static let yellowPrimary = UIColor.init(hexaRGB: "#FFDD00")
    static let yellowSecondGradient = UIColor.init(hexaRGB: "#F7C945")
    static let primaryGreenLeave = UIColor.init(hexaRGB: "#E7FFDC")
    static let primaryGreenMedium = UIColor.init(hexaRGB: "#75D37F")
    static let primaryRedMedium = UIColor.init(hexaRGB: "#FF4E46")
    static let primaryRedAlert = UIColor.init(hexaRGB: "#FF6F6F")
    static let primaryRedHard = UIColor.init(hexaRGB: "#E41B23")
    static let neutralGreenHard = UIColor.init(hexaRGB: "#59AA61")
    static let neutralBlueMedium = UIColor.init(hexaRGB: "#0084F1")
    static let primaryBlueSoft = UIColor.init(hexaRGB: "#8EBBFF")
    static let notificationInfoSoft = UIColor.init(hexaRGB: "#EAF2FF")
    static let primaryRedUltraSoft = UIColor.init(hexaRGB: "#FFEDEB")
    static let primaryRedSemiHard = UIColor.init(hexaRGB: "#E31C23")
    static let primaryGreen = UIColor.init(hexaRGB: "#3ED44D")
    static let primaryGreenUltraSoft = UIColor.init(hexaRGB: "#DEFFE1")
    static let greenSuccess = UIColor.init(hexaRGB: "#3ED44D")
    static let primaryBlue = UIColor.init(hexaRGB: "#468BF3")
    static let primaryBlueDark = UIColor.init(hexaRGB: "#06377B")
    static let prioritasCoklat = UIColor.init(hexaRGB: "#6D6E72")
    static let prioritasLineCoklat = UIColor.init(hexaRGB: "#AD8F6B")
    static let yellowLabelPosition = UIColor.init(hexaRGB: "#FFD900")
    static let primaryGrayMedium = UIColor.init(hexaRGB: "#F5F7FB")
    static let neutralGraySoftPrimary = UIColor.init(hexaRGB: "#E6EAF3")
    static let blueSoftPrimary = UIColor.init(hexaRGB: "#E2E9FF")
    static let redSoftPrimary = UIColor.init(hexaRGB: "#FFE1E1")
    static let orangeSoftPrimary = UIColor.init(hexaRGB: "#FFF2E3")
    static let orangeSoftMedium = UIColor.init(hexaRGB: "#FFA24B")
    static let olive = UIColor.init(hexaRGB: "#57B77D")
    static let iconDefault = UIColor.init(hexaRGB: "#6E8597")

    // MARK: - For Gradient Chart Color
    static let greenGradient1 = UIColor.init(hexaRGB: "#03A700")
    static let greenGradient2 = UIColor.init(hexaRGB: "#49A700")
    
    static var placeholderText: UIColor {
      if #available(iOS 13.0, *) {
        return .placeholderText
      }
        return UIColor(red: 60, green: 60, blue: 67, alpha: 0.3)
    }
}

struct DateFormat {
    static let dmy = "dd/MM/yyyy"
    static let ydm = "yyyy-dd-MM"
    static let ymd = "yyyy-MM-dd"
    static let ddmmmmyy = "dd MMMM yyyy"
}
