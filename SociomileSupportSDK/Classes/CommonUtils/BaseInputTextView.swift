//
//  BaseInputTextView.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import UIKit

class InputTextView: UITextView{
    let placeholderLabel = BaseLabel(text: "  Write something to reply", labelColor: UIColor(hexString: CustomHelper.shared.lblColorThemeDefault))
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = UIColor(hexString: CustomHelper.shared.bgTextContainer)
        layer.cornerRadius = 20
        isScrollEnabled = false
        font = .systemFont(ofSize: 16)
        autocorrectionType = .no
        spellCheckingType  = .no
        
        addSubview(placeholderLabel)
        placeholderLabel.centerY(inView: self, leftAnchor: leftAnchor, rightAnchor: rightAnchor, paddingLeft: 8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
        paddingView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTextDidChange(){
        placeholderLabel.isHidden = !text.isEmpty
    }
}

extension UITextView{
    func paddingView(){
        self.textContainerInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
    }
}
