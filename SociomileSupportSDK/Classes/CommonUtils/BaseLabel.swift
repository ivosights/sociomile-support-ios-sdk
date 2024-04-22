//
//  BaseLabel.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import UIKit

class BaseLabel: UILabel{
    init(text: String, labelFont: UIFont = .systemFont(ofSize: 14), labelColor: UIColor = .black) {
        super.init(frame: .zero)
        self.text = text
        font = labelFont
        textAlignment = .center
        numberOfLines = 0
        self.textColor = labelColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
