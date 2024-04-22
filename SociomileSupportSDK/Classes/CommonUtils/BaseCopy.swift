//
//  BaseCopy.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import UIKit

class Copy {
    
    private var parent: UIView
    private var inProgress = false

    private let container: UIView = {
        let container = UIView()
        container.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.65)
        container.layer.cornerRadius = 24
        container.isHidden = true
        container.alpha = 0.3
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private let checkIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(imageLiteralResourceName: "icon_check")
        icon.frame = CGRect(origin: .zero, size: CGSize(width: 48, height: 48))
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    private let iconLabel: UILabel = {
        let label = UILabel()
        label.text = .localized("common.copy")
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 16)
        return label
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(on parent: UIView) {
        self.parent = parent
    }
    
    func show(labelWording: String = .localized("common.copy")) {
        guard !inProgress else { return }
        inProgress.toggle()
        iconLabel.text = labelWording
        contentStack.addArrangedSubview(checkIcon)
        contentStack.addArrangedSubview(iconLabel)
        parent.addSubview(container)
        container.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 160),
            container.heightAnchor.constraint(equalToConstant: 110),
            container.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
            
            contentStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        animate()
    }
    
    private func animate() {
        container.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        let animationStart = UIViewPropertyAnimator(
            duration: 0.3,
            dampingRatio: 0.5) { [weak self] () in
                self?.container.isHidden = false
                self?.container.alpha = 1
                self?.container.transform = .identity
            }
        
        let animationEnd = UIViewPropertyAnimator(
            duration: 0.1,
            curve: .easeInOut) { [weak self] in
                self?.container.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                self?.container.alpha = 0
            }

        animationStart.addCompletion { _ in
            animationEnd.startAnimation(afterDelay: 0.5)
        }
        
        animationEnd.addCompletion { [weak self] _ in
            self?.inProgress.toggle()
            self?.container.removeFromSuperview()
        }
        
        animationStart.startAnimation()
    }

}
