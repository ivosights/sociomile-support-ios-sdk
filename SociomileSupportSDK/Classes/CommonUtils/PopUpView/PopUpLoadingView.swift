//
//  PopUpLoadingView.swift
//  SociomileIosSDK
//
//  Created by Meynisa on 15/02/24.
//

import UIKit

class PopUpLoading {
    
    private let widthHeight: CGFloat = 80
    private var parentView: UIView
    private var loadingGif = UIImage.gifImageWithName("img_ripple")
    private var animationView: UIImageView
    private var backgroundCover: UIView
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexaRGB: "#0061A7")
        label.font = UIFont(name: "Futura", size: 15.0)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    init(on view: UIView) {
        let frameworkBundle = Bundle(for: PopUpLoading.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("SociomileSupportSDK.bundle")
        let resourceBundle = Bundle(url: bundleURL!)

        let image = UIImage(named: "img_ripple", in: resourceBundle, compatibleWith: nil)
        print("BUNDLE: \(image)")
        
        self.parentView = view
        animationView = UIImageView()
        animationView.image = loadingGif
        animationView.alpha = 0.3
        animationView.isHidden = true
        self.backgroundCover = UIView()
        self.backgroundCover.backgroundColor = .clear
        self.label.text = "Loading..."
    }
    
    deinit {
        if #available(iOS 13.0, *) {
            NotificationCenter.default.removeObserver(self, name: UIScene.willEnterForegroundNotification, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    
    private func animateView() {
        animationView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIViewPropertyAnimator(
            duration: 0.3,
            dampingRatio: 0.6) { [weak self] () in
                guard let self = self else { return }
                self.animationView.isHidden = false
                self.animationView.alpha = 1
                self.animationView.transform = .identity
            } .startAnimation()
    }
    
    func show() {
        // swiftlint:disable line_length
        if #available(iOS 13.0, *) {
            NotificationCenter.default.removeObserver(self, name: UIScene.willEnterForegroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(reloadAnimation), name: UIScene.willEnterForegroundNotification, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(reloadAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
        // swiftlint:enable line_length
        backgroundCover.backgroundColor = UIColor(hexaRGB: "#BCC8E7", alpha: 0.3)
        animationView.contentMode = .scaleAspectFit
//        animationView.loopMode = .loop
//        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        backgroundCover.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints =  false
        parentView.addSubview(backgroundCover)
        backgroundCover.addSubview(animationView)
        backgroundCover.addSubview(label)
        if let header = parentView.viewWithTag(99) {
            parentView.bringSubviewToFront(header)
        }
        NSLayoutConstraint.activate([
            backgroundCover.topAnchor.constraint(equalTo: parentView.topAnchor),
            backgroundCover.leftAnchor.constraint(equalTo: parentView.leftAnchor),
            backgroundCover.rightAnchor.constraint(equalTo: parentView.rightAnchor),
            backgroundCover.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            animationView.widthAnchor.constraint(equalToConstant: widthHeight),
            animationView.heightAnchor.constraint(equalToConstant: widthHeight),
            animationView.centerXAnchor.constraint(equalTo: backgroundCover.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: backgroundCover.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: backgroundCover.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 22)
        ])
        animateView()
    }
    
    func dismissAfter1() {
        if #available(iOS 13.0, *) {
            NotificationCenter.default.removeObserver(self, name: UIScene.willEnterForegroundNotification, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] () in
            guard let self = self else { return }
            self.animationView.removeFromSuperview()
            self.backgroundCover.removeFromSuperview()
//            self.animationView.stop()
        }
    }
    
    func dismissImmediately() {
        if #available(iOS 13.0, *) {
            NotificationCenter.default.removeObserver(self, name: UIScene.willEnterForegroundNotification, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        }
        DispatchQueue.main.async { [weak self] () in
            guard let self = self else { return }
            self.animationView.removeFromSuperview()
            self.backgroundCover.removeFromSuperview()
//            self.animationView.stop()
        }
    }
    
    @objc func reloadAnimation() {
//        animationView.play()
    }

}
