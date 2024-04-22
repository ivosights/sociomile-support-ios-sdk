//
//  ExtInt.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 07/03/24.
//

import Foundation

extension Int {
    
    func convertToCurrency(symbol: String = "Rp ", identifier: String = "id_ID", groupingSeparator: String = ".", suffix: String = ",00") -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: identifier)
        formatter.groupingSeparator = groupingSeparator
        formatter.numberStyle = .decimal
        if let formattedTipAmount = formatter.string(from: self as NSNumber) {
            return "\(symbol)\(formattedTipAmount)\(suffix)"
        }
        return ""
    }

    func idnCurrencyComma() -> String {
        let largeNumber = self
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: largeNumber)) ?? ""
    }
        /// Convert int to string
        /// ```
        /// let db: Int = 12
        /// let str = db.string -> // "12"
        /// ```
    
    func currencyFormatting() -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        let amountInteger = self
        
        number = NSNumber(value: (amountInteger))
        guard number != 0 as NSNumber else {
            return number == 0 ? "0" : ""
        }
        if let amount = formatter.string(from: number) {
            return amount
        } else {
            return ""
        }
    }
    
    var string: String {
        return String(self)
    }
    
    var float: Float {
        return Float(self)
    }
    
    var double: Double {
        return Double(self)
    }
    
    func convertToDate() -> Date{
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return date
    }
    
    func convertToGMT() -> Date{
        let currentDate = Date()
        let timezoneOffset = TimeZone.current.secondsFromGMT()
        let epochDate = currentDate.timeIntervalSince1970
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        let timezoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
        return timezoneOffsetDate
    }
}
