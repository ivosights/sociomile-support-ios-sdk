//
//  ExtColor.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import UIKit

extension UIColor {
    convenience init?(hexaRGB: String, alpha: CGFloat = 1) {
        var chars = Array(hexaRGB.hasPrefix("#") ? hexaRGB.dropFirst() : hexaRGB[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }
        case 6: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                alpha: alpha)
    }

    convenience init?(hexaRGBA: String) {
        var chars = Array(hexaRGBA.hasPrefix("#") ? hexaRGBA.dropFirst() : hexaRGBA[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars.append(contentsOf: ["F", "F"])
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                alpha: .init(strtoul(String(chars[6...7]), nil, 16)) / 255)
    }

    convenience init?(hexaARGB: String) {
        var chars = Array(hexaARGB.hasPrefix("#") ? hexaARGB.dropFirst() : hexaARGB[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars.append(contentsOf: ["F", "F"])
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[6...7]), nil, 16)) / 255,
                alpha: .init(strtoul(String(chars[0...1]), nil, 16)) / 255)
    }
    
    class func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat? = nil) -> UIColor {
        if let alp = alpha {
            return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alp)
        } else {
            return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
        }
    }
    
    class func color(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat? = nil) -> UIColor {
        if let alp = alpha {
            return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alp)
        } else {
            return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
        }
    }
    
    // MARK: - Chart Colors
    
    static func btnChartColors() -> [UIColor] {
        return [
            UIColor.init(hexaRGB: "6219CF") ?? .blue,
            UIColor.init(hexaRGB: "FDC908") ?? .blue,
            UIColor.init(hexaRGB: "597EFC") ?? .blue,
            UIColor.init(hexaRGB: "FE9836") ?? .blue,
            UIColor.init(hexaRGB: "FF5E5E") ?? .blue
       ]
    }
    
    // MARK: - Additional - NORMAL GREEN
    static let btnGreenBase         = #colorLiteral(red: 0.3411764706, green: 0.7176470588, blue: 0.4901960784, alpha: 1)
    
    // MARK: - Additional - WHITE
    static let btnWhite100          = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    // MARK: - Additional - BLACK
    static let btnBlack80           = #colorLiteral(red: 0.2156862745, green: 0.2509803922, blue: 0.3843137255, alpha: 1)
    
    // MARK: - Additional - YELLOW
    static let btnWarning            = #colorLiteral(red: 1, green: 0.4352941176, blue: 0.4352941176, alpha: 1)
    
    // MARK: - Additional - YELLOW
    static let btnGray               = #colorLiteral(red: 0.737254902, green: 0.7843137255, blue: 0.9058823529, alpha: 1)
    
    // MARK: - Additional - YELLOW
    static let btnBlueMedium         = #colorLiteral(red: 0.737254902, green: 0.7843137255, blue: 0.9058823529, alpha: 1)

    // MARK: - Additional - GRAY
    static let selectedGray = #colorLiteral(red: 0.8196074367, green: 0.8196083307, blue: 0.8411096334, alpha: 1)
    
    // MARK: - Primary - Blue
    static let primaryBlue = #colorLiteral(red: 0, green: 0.3803921569, blue: 0.6549019608, alpha: 1)
    
    static let headerColor = #colorLiteral(red: 0.462745098, green: 0.462745098, blue: 0.462745098, alpha: 1)
    
    static let iconDefault = #colorLiteral(red: 0.431372549, green: 0.5215686275, blue: 0.5921568627, alpha: 1)
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        // swiftlint:disable identifier_name
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

