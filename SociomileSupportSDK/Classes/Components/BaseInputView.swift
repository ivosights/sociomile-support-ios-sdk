//
//  BaseInputView.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import Foundation
import UIKit

protocol BaseInputViewDelegate: AnyObject{
    func inputView(_ view: BaseInputView, wantUploadMessage message: String)
    func inputViewAttach(_ view: BaseInputView)
}

class BaseInputView: UIView{
    let inputTextView = InputTextView()
    
    weak var delegate: BaseInputViewDelegate?
    
    private let postBackgroundColor: BaseImageView = {
        let tapGesture = UITapGestureRecognizer(target: BaseInputView.self, action: #selector(handlePostButton))
        let backgroundView = BaseImageView(width: 40, height: 40, backgroundColor: UIColor(hexString: CustomHelper.shared.colorBgIconDefault), cornerRadius: 20)
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.isHidden = true
        return backgroundView
    }()
    
    private lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        if #available(iOS 13.0, *) {
            button.setBackgroundImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        }
        button.tintColor = UIColor(hexString: CustomHelper.shared.colorIconDefault)
        button.addTarget(self, action: #selector(handlePostButton), for: .touchUpInside)
        button.setDimensions(height: 28, width: 28)
        button.isHidden = true
        return button
    }()
    
    private let attachmentBackgroundColor: BaseImageView = {
        let tapGesture = UITapGestureRecognizer(target: BaseInputView.self, action: #selector(handleAttachmentButton))
        let backgroundView = BaseImageView(width: 40, height: 40, cornerRadius: 20)
        
        backgroundView.backgroundColor = UIColor(hexString: CustomHelper.shared.colorBgIconDefault)
        
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(tapGesture)
        return backgroundView
    }()
    
    private lazy var attachmentButton: UIButton = {
        let button = UIButton(type: .system)
        if #available(iOS 13.0, *) {
            button.setBackgroundImage(UIImage(systemName: "paperclip"), for: .normal)
            
        }
        button.tintColor = UIColor(hexString: CustomHelper.shared.colorIconDefault)
        button.addTarget(self, action: #selector(handleAttachmentButton), for: .touchUpInside)
        button.setDimensions(height: 28, width: 28)
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hexString: CustomHelper.shared.bgAppbar)
        autoresizingMask = .flexibleHeight
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingLeft: 5, paddingRight: 5)
        
        addSubview(postButton)
        postButton.center(inView: postBackgroundColor)
        
        addSubview(attachmentButton)
        attachmentButton.center(inView: attachmentBackgroundColor)
        
        inputTextView.anchor(top: topAnchor, left: attachmentBackgroundColor.rightAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: postBackgroundColor.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = UIColor(hexString: CustomHelper.shared.bgTextContainer)
        addSubview(dividerView)
        dividerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: InputTextView.textDidChangeNotification, object: nil)
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [attachmentBackgroundColor, inputTextView, postBackgroundColor])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{ return .zero }
    
    @objc func handlePostButton(){
        delegate?.inputView(self, wantUploadMessage: inputTextView.text)
    }
    
    @objc func handleAttachmentButton(){
        delegate?.inputViewAttach(self)
    }
    
    func clearTextView(){
        inputTextView.text = ""
        inputTextView.placeholderLabel.isHidden = false
        postButton.isHidden = true
        postBackgroundColor.isHidden = true
    }
    
    @objc func handleTextDidChange(){
        let isTextEmpty = inputTextView.text.isEmpty
        
        postButton.isHidden = isTextEmpty
        postBackgroundColor.isHidden = isTextEmpty
    }
}
