//
//  BaseToast.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import UIKit

class BaseToast: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "Futura", size: 13.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var message: String = "" {
        didSet {
            label.text = message
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        isUserInteractionEnabled = true
        layer.cornerRadius = 8
        layer.backgroundColor = UIColor(hexaRGB: "#7B87AF")?.cgColor
        
        self.addSubview(label)
    }
}

extension UIViewController {
    func showCustomToast(message: String) {
        let customToast = BaseToast()
        customToast.isUserInteractionEnabled = true
        customToast.message = message
        customToast.alpha = 1.0
        self.view.addSubview(customToast)
        
        UIView.animate(withDuration: 2.0, delay: 2.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            customToast.alpha = 0.1
        }, completion: {(_) in
            customToast.removeFromSuperview()
        })
    }
}
