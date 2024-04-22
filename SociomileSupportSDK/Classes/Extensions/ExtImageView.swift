//
//  ExtImageView.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 13/03/24.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = tintedImage
        self.tintColor = color
    }
    
    func blur() {
        let  blurRadius: CGFloat = 3
        UIGraphicsBeginImageContext(bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setDefaults()
        let imageToBlur = CIImage(cgImage: (image?.cgImage)!)
        blurFilter?.setValue(imageToBlur, forKey: kCIInputImageKey)
        blurFilter?.setValue(blurRadius, forKey: "inputRadius")
        let outputImage: CIImage? = blurFilter?.outputImage
        let context = CIContext(options: nil)
        let cgimg = context.createCGImage(outputImage!, from: (outputImage?.extent)!)
        layer.contents = cgimg!
    }
    
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let imageData = data else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.image = UIImage(data: imageData)
//                if let imageData = try? Data(contentsOf: url) {
//                    if let loadedImage = UIImage(data: imageData) {
//                        self?.image = loadedImage
//                    }
//                }
            }
        }.resume()
    }
    
    func makeRoundedImg() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
    
    func makeRoundedCell() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        // swiftlint:disable:next line_length
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
