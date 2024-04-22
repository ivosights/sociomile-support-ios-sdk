//
//  BaseButton.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import Foundation
import UIKit

class BaseButton: UIButton {
    static let height = 40
    
    lazy var originalButtonText: String? = self.titleLabel?.text
    var activityIndicator: UIActivityIndicatorView!
    
    enum Style {
        // swiftlint:disable:next nesting
        enum Color {
            case primary
            case secondary
            
            var background: UIColor? {
                switch self {
                case .primary:
                    return UIColor(hexaRGB: "#0061A7")
                case .secondary:
                    return UIColor(hexaRGB: "#F4F7FB")
                }
            }
            
            var text: UIColor? {
                switch self {
                case .primary:
                    return UIColor(hexaRGB: "#FFFFFF")
                case .secondary:
                    return UIColor(hexaRGB: "#0061A7")
                }
            }
        }
        
        case fill(Color = .primary)
        case text(Color = .primary)
        case border(Color = .primary)
    }
    
    var image: UIImage? {
        didSet {
            setImage(image, for: .normal)
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            configLoading()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(title: titleLabel?.text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(title: titleLabel?.text)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setup(type: Style = .fill(.primary), title: String? = nil) {
        var titleColor: UIColor? = .white
        switch type {
        case let .fill(color):
            backgroundColor = color.background
            titleColor = color.text
        case let .text(color):
            backgroundColor = .clear
            titleColor = color.background
        case let .border(color):
            backgroundColor = .white
            titleColor = color.background
            layer.borderColor = color.background?.cgColor
            layer.borderWidth = 1
        }
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        layer.cornerRadius = 8
        layer.masksToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }

    private func configLoading() {
        if isLoading {
            showLoading()
        } else {
            hideLoading()
        }
    }
    
    func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)
        
        if activityIndicator == nil {
            activityIndicator = createActivityIndicator()
        }

        showSpinning()
        self.isEnabled = false
    }

    func hideLoading() {
        self.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
        self.isEnabled = true
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.lightGray
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    // swiftlint:disable line_length
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
    // swiftlint:enable line_length
}
