//
//  Helper.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 14/03/24.
//

import Foundation
import UIKit

class Helper{
    static let shared = Helper()
    
    func randomAlphanumericString(_ length: Int) -> String {
       let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
       let len = UInt32(letters.count)
       var random = SystemRandomNumberGenerator()
       var randomString = ""
       for _ in 0..<length {
          let randomIndex = Int(random.next(upperBound: len))
          let randomCharacter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
          randomString.append(randomCharacter)
       }
       return randomString
    }
}
