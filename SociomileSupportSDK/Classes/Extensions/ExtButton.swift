//
//  ExtButton.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import UIKit

extension UIButton{
    func attributedText(firstString: String, secondString: String){
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.7), .font: UIFont.systemFont(ofSize: 16)]
        let attributeTitle = NSMutableAttributedString(string: "\(firstString)", attributes: atts)
        
        let secondAtts: [NSAttributedString.Key: Any] = [.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.88), .font: UIFont.boldSystemFont(ofSize: 16)]
        attributeTitle.append(NSAttributedString(string: secondString, attributes: secondAtts))
        
        setAttributedTitle(attributeTitle, for: .normal)
    }
}

extension UIAlertAction {
    var titleTextColor: UIColor? {
        get {
            return self.value(forKey: "titleTextColor") as? UIColor
        } set {
            self.setValue(newValue, forKey: "titleTextColor")
        }
    }
}
