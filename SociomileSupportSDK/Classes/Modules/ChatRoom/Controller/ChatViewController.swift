//
//  ChatViewController.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import UIKit
import Combine

class ChatViewController: BaseCollectionViewController{
    
    var presentr: ChatPresentr
    
    private let reuseIdentifier = "ChatCell"
    private let headerReuseIdentifier = "ChatHeaderCell"
    private let emptyLabel = BaseLabel(text: "No Data Available")
    lazy var imageView: UIImageView = UIImageView()
    private let refreshControl = UIRefreshControl()
    
    init(presentr: ChatPresentr) {
        self.presentr = presentr
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ChatHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var inputAccessoryView: UIView?{
        get{return baseInputView}
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    private lazy var baseInputView: BaseInputView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let iv = BaseInputView(frame: frame)
        iv.delegate = self
        return iv
    }()
    
    lazy var imagePicker: UIImagePickerController = {
       let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        return picker
    }()
    
    private lazy var attachAlertDialog: UIAlertController = {
        let alert = UIAlertController(title: "Attach File", message: "Select the menu you want to attach from", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {_ in self.handleCamera()}))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {_ in self.handleGallery()}))
        alert.addAction(UIAlertAction(title: "File", style: .default, handler: {_ in if #available(iOS 14.0, *) {
            self.handleFile()
        }}))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.titleTextColor = .red
        alert.addAction(cancelAction)
        
        return alert
    }()
    
     lazy var fileAlertDialog: UIAlertController = {
         let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
         
         imageView.frame = CGRect(x: (alert.view.frame.width/2) - (alert.view.frame.width/4), y: 100, width: alert.view.frame.width/4, height: alert.view.frame.width/4)
         
         imageView.contentMode = .scaleToFill
         imageView.layer.cornerRadius = 8
         imageView.clipsToBounds = true

         alert.view.addSubview(imageView)
         
         let height = NSLayoutConstraint(item: alert.view as Any, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: (view.frame.width/4) + 170)
         alert.view.addConstraint(height)
         
         alert.addTextField{ textfield in
             textfield.placeholder = "Add caption..."
         }
         
         alert.addAction(UIAlertAction(title: "Send", style: .default, handler: {_ in self.sendData()}))
         
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
         cancelAction.titleTextColor = .red
         alert.addAction(cancelAction)
        
         return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindPresentr()
        superView()
        configDataSource()
        setupNotif()
    }
    
    func superView(){
        view.addSubview(emptyLabel)
        emptyLabel.center(inView: view)
        
        if #available(iOS 13.0, *) {
            let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: .none, action: #selector(backButton))
            leftBarButton.tintColor = UIColor(hexString: CustomHelper.shared.colorBackBtn)
            navigationItem.leftBarButtonItem = leftBarButton
            
            navigationItem.title = "CS"
            
            let navigationAppearance = UINavigationBarAppearance()
            navigationAppearance.configureWithOpaqueBackground()
            navigationAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor(hexString: CustomHelper.shared.colorAppbar)
                ]
            navigationAppearance.backgroundColor = UIColor(hexString: CustomHelper.shared.bgAppbar)
            UINavigationBar.appearance().standardAppearance = navigationAppearance
            UINavigationBar.appearance().compactAppearance = navigationAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        }
        
        collectionView.refreshControl = refreshControl
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            presentr.page = presentr.page + 1
            if presentr.page <= presentr.pageTotal{
                getMessages()
            }
            self.refreshControl.endRefreshing()
        }).disposed(by: disposeBag)
    }
    
    func getMessages(){
        presentr.getMessages().subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(let data):
                presentr.processingData(data: data)
                if presentr.page == 1 {
                    presentr.messages.removeAll()
                    presentr.page = 1
                }
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            case .failure(let error):
                self.onFailedGetTaskList(error: error)
            }
        }).disposed(by: disposeBag)
    }
    
    func onFailedGetTaskList(error: ApiError) {
        handleError(error: error)
        if presentr.page == 1 {
            presentr.messages.removeAll()
        }
        collectionView.isHidden = true
        self.emptyLabel.isHidden = false
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func configDataSource(){
        collectionView.backgroundColor = UIColor(hexString: CustomHelper.shared.bgScreen)
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
    }
    
    private func bindPresentr(){
        let vtp = ChatPresentr.VTP(didLoadTrigger: .just(()))
        
        let ptv = presentr.bind(vtp: vtp)
        
        ptv.componentOutput.drive(onNext: { [ weak self] components in
            guard let self = self else { return }
            self.emptyLabel.isHidden = !components.data!.isEmpty
            collectionView.reloadData()
            self.collectionView.scrollToLastItem()
            loadingIndicator.dismissAfter1()
        }).disposed(by: disposeBag)
        
        ptv.dataFailed.drive(onNext: { [ weak self ] error in
            guard let self = self else { return }
            loadingIndicator.dismissAfter1()
            self.emptyLabel.isHidden = false
            handleError(error: error)
        }).disposed(by: disposeBag)
        
        ptv.isLoading.drive(onNext: { [weak self] isLoading in
            self?.loadingIndicator.show()
        }).disposed(by: disposeBag)
    }
}

extension ChatViewController: BaseInputViewDelegate{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presentr.messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader{
            guard let firstMessage = presentr.messages[indexPath.section].first else { return UICollectionReusableView() }
            
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! ChatHeaderCell
            cell.dateValue = firstMessage.timeString?.convertDateWithFormat(format: "dd/MM/yyy")
                    
            return cell
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentr.messages[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCell
        
        let data = presentr.messages[indexPath.section][indexPath.row]
        cell.viewModel = MessageViewModel(message: data)
        cell.delegate = self
        
        return cell
    }
    
    func inputView(_ view: BaseInputView, wantUploadMessage message: String) {
        var timeString: Date?
        if #available(iOS 15, *) {
            timeString =  Date.now
        }
        presentr.messages[presentr.messages.count - 1].append(ConversationsData(content: message, isReply: false, timeString: timeString))
        
        self.presentr.sendParam = SendParam(user: SendUser(id: AppSetting.shared.userId, name: AppSetting.shared.userName), content: SendContent(id: Helper.shared.randomAlphanumericString(26), type: "text", text: DataContent(body: message)))
        
        sendMessage()
        view.clearTextView()
        collectionView.reloadData()
    }
    
    func inputViewAttach(_ view: BaseInputView) {
        present(attachAlertDialog, animated: true)
    }
}

extension ChatViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 15, left: 0, bottom: 50, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame  = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cell = ChatCell(frame: frame)
        
        let data = presentr.messages[indexPath.section][indexPath.row]
        cell.viewModel = MessageViewModel(message: data)
        
        cell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimateSize = cell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: view.frame.width, height: estimateSize.height)
    }
}
