//
//  TextViewCell.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 14/03/24.
//

import Foundation
import UIKit

class TextViewCell: UICollectionViewCell{
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var fileBtn: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    weak var delegate: ChatCellDelegate?
    
    var viewModel: MessageViewModel?{
        didSet{
//            configure()
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
