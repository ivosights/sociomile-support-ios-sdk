//
//  ChatCell.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import UIKit

protocol ChatCellDelegate: AnyObject{
    func cell(playTheVideo cell: ChatCell, videoUrl: URL?)
    func cell(showTheImage cell: ChatCell, imageUrl: URL?)
    func cell(showTheFile cell: ChatCell, fileUrl: URL?)
}

class ChatCell: UICollectionViewCell{
    
    weak var delegate: ChatCellDelegate?
    
    var viewModel: MessageViewModel?{
        didSet{
            configure()
        }
    }
    
    private let dateLabel = BaseLabel(text: "10/02/2024", labelColor: UIColor(hexString: CustomHelper.shared.lblColorDateMsg))
    
    private let bubbleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.btnGreenBase
        return view
    }()
    
    var bubbleRightAnchor: NSLayoutConstraint!
    var bubbleLeftAnchor: NSLayoutConstraint!
    
    var dateRightAnchor: NSLayoutConstraint!
    var dateLeftAnchor: NSLayoutConstraint!
    
    var textTopAnchor: NSLayoutConstraint!
    
    private let textView: UITextView = {
        let textview = UITextView()
        textview.backgroundColor = .clear
        textview.isEditable = false
        textview.isScrollEnabled = false
        textview.text = "Sample"
        textview.font = .systemFont(ofSize: 16)
        textview.textColor = .white
        return textview
    }()
    
    private lazy var image: BaseImageView = {
        let img = BaseImageView()
        img.isHidden = true
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.roundCorners([.topLeft, .topRight], radius: 12)
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(handleImageButton))
        img.addGestureRecognizer(tapImage)
        img.isUserInteractionEnabled = true
        return img
    }()
    
    private lazy var video: UIButton = {
        let btn = UIButton(type: .system)
        if #available(iOS 13.0, *) {
            btn.setImage(UIImage(systemName: "play.circle"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        btn.tintColor = .white
        btn.isHidden = true
        btn.setTitle("Play Video", for: .normal)
        btn.addTarget(self, action: #selector(handleVideoButton), for: .touchUpInside)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        return btn
    }()
    
    private lazy var document: UIButton = {
        let btn = UIButton(type: .system)
        if #available(iOS 13.0, *) {
            btn.setImage(UIImage(systemName: "newspaper.circle"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        btn.tintColor = .white
        btn.isHidden = true
        btn.setTitle("File", for: .normal)
        btn.addTarget(self, action: #selector(handleDocumentButton), for: .touchUpInside)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.anchor(top: topAnchor)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleContainer.addSubview(textView)
        textView.anchor(left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
        textTopAnchor = textView.topAnchor.constraint(equalTo: bubbleContainer.topAnchor)
        textTopAnchor.isActive = true
        
        bubbleContainer.addSubview(document)
        document.anchor(left: bubbleContainer.leftAnchor, bottom: textView.topAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
        document.contentHorizontalAlignment = .left
        
        bubbleContainer.addSubview(video)
        video.anchor(left: bubbleContainer.leftAnchor, bottom: document.topAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
        video.contentHorizontalAlignment = .left
        
        bubbleContainer.addSubview(image)
        image.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: video.topAnchor, right: bubbleContainer.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 12)
        bubbleLeftAnchor.isActive = false
        
        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        bubbleRightAnchor.isActive = false
        
        addSubview(dateLabel)
        dateLeftAnchor = dateLabel.leftAnchor.constraint(equalTo: bubbleContainer.leftAnchor, constant: 0)
        dateLeftAnchor.isActive = false
        
        dateRightAnchor = dateLabel.rightAnchor.constraint(equalTo: bubbleContainer.rightAnchor, constant: 0)
        dateRightAnchor.isActive = false
        
        bubbleContainer.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.anchor(top: bubbleContainer.bottomAnchor, bottom: bottomAnchor, paddingTop: 5, paddingBottom: 5)
    }
    
    func configure(){
        guard let viewModel = viewModel else { return }
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        textView.text = viewModel.messageText
        textView.textColor = viewModel.messageColor
        
        bubbleRightAnchor.isActive = viewModel.rightAnchorActive
        dateRightAnchor.isActive = viewModel.rightAnchorActive
        
        bubbleContainer.layer.maskedCorners = viewModel.rightAnchorActive ? [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner] : [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        bubbleLeftAnchor.isActive = viewModel.leftAnchorActive
        dateLeftAnchor.isActive = viewModel.leftAnchorActive
        
        guard let timeStampString = viewModel.message.timeString else { return }
        dateLabel.text = timeStampString.convertDateWithFormat(format: "HH:mm")
        
        if viewModel.message.attachmentURL != "" && (viewModel.message.isImage != nil){
            image.loadFrom(URLAddress: viewModel.message.attachmentURL ?? "https://i0.wp.com/sigmamaleimage.com/wp-content/uploads/2023/03/placeholder-1-1.png?ssl=1")
        }
        if viewModel.message.rawData != nil{
            image.image = FileUploader.based64ToImage(base64String: viewModel.message.rawData ?? "")
        }
        
        image.isHidden = !(viewModel.message.isImage ?? false)
        video.isHidden = !(viewModel.message.isVideo ?? false)
        document.isHidden = !(viewModel.message.isFile ?? false)
        
        if viewModel.message.isImage!{
            textTopAnchor.isActive = false
            image.setHeight(200)
        }else if viewModel.message.isVideo!{
            textTopAnchor.isActive = false
            image.setHeight(1)
            video.setHeight(50)
        }
        else if viewModel.message.isFile!{
            textTopAnchor.isActive = false
            image.setHeight(1)
            video.setHeight(1)
            document.setHeight(50)
        }else{
            textTopAnchor.isActive = true
        }
    }
    
    @objc func handleImageButton(){
        guard let viewModel = viewModel else { return }
        delegate?.cell(showTheImage: self, imageUrl: viewModel.attachmentURL)
    }
    
    @objc func handleVideoButton(){
        guard let viewModel = viewModel else { return }
        delegate?.cell(playTheVideo: self, videoUrl: viewModel.attachmentURL)
    }
    
    @objc func handleDocumentButton(){
        guard let viewModel = viewModel else { return }
        delegate?.cell(showTheFile: self, fileUrl: viewModel.attachmentURL)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
