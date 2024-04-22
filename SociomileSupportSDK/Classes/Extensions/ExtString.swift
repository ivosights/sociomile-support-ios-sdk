//
//  ExtString.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import UIKit

extension String {
    
    static func localized(_ string: String) -> String {
        return NSLocalizedString(string, comment: "")
    }
    
    func withBoldText(boldPartsOfString: [String], font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        let nonBoldFontAttribute = [NSAttributedString.Key.font: font!]
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont!]
        let boldString = NSMutableAttributedString(string: self as String, attributes: nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: (self as NSString).range(of: boldPartsOfString[i] as String))
        }
        return boldString
    }
    
    func containsIgnoringCase(_ anotherString: String) -> Bool {
        return self.range(of: anotherString, options: NSString.CompareOptions.caseInsensitive) != nil
    }
    
    var isNotEmpty: Bool {
        !self.isEmpty
    }
    
    func convertToDate(to newFormat: String) -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = newFormat
        return formatter.date(from: self)
    }
    
    func convertDateFormat(to newFormat: String) -> String {
        let formatter = DateFormatter()
        let date = self.convertToDate(to: DateFormat.ymd)
        formatter.dateFormat = newFormat
        let resultString = formatter.string(from: date ?? Date())
        return resultString
    }
    
    var urlQueryValueEscaped: String {
        let urlQueryValueAllowed = CharacterSet.urlQueryAllowed.subtracting(CharacterSet(charactersIn: "+/="))
        return self.addingPercentEncoding(withAllowedCharacters: urlQueryValueAllowed)!
            .replacingOccurrences(of: " ", with: "+")
    }
    
    func hexStringToUIColor() -> UIColor {
        var cString: String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

