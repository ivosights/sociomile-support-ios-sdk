//
//  ChatHeaderCell.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 07/03/24.
//

import UIKit

class ChatHeaderCell: UICollectionReusableView{
    var dateValue: String?{
        didSet{
            configure()
        }
    }
    private let dateLabel: BaseLabel = {
        let label = BaseLabel(text: "10/10/2020", labelFont: .systemFont(ofSize: 16), labelColor: UIColor(hexString: CustomHelper.shared.lblColorMsgHeader))
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dateLabel)
        dateLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        guard let dateValue = dateValue else { return }
        dateLabel.text = dateValue
    }
}
