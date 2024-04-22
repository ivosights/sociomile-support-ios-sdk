//
//  ChatVCExt.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 08/03/24.
//

import UIKit
import AlamofireImage
import Alamofire
import ImageSlideshow

extension ChatViewController{
    
    @objc func backButton(){
        self.loadingIndicator.show()
        self.presentr.readMessage().subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            self.loadingIndicator.dismissAfter1()
            switch result{
            case .success(let data):
                print(data)
                navigationController?.popViewController(animated: true)
            case .failure(let error):
                handleError(error: error)
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func sendData(){
        if let text = fileAlertDialog.textFields?.first?.text{
            
            fileAlertDialog.textFields?.first?.text = ""
            
            if self.presentr.sendParam?.content?.type == "image"{
                self.presentr.sendParam?.content?.image?.caption = text
                let arrHeader = self.presentr.messages[self.presentr.messages.count - 1]
                presentr.messages[presentr.messages.count - 1][arrHeader.count - 1].content = text
            }else if self.presentr.sendParam?.content?.type == "video"{
                self.presentr.sendParam?.content?.video?.caption = text
                let arrHeader = self.presentr.messages[self.presentr.messages.count - 1]
                presentr.messages[presentr.messages.count - 1][arrHeader.count - 1].content = text
            }else if self.presentr.sendParam?.content?.type == "text"{
                self.presentr.sendParam?.content?.text?.body = text
                if #available(iOS 15, *) {
                    presentr.messages[presentr.messages.count - 1].append(ConversationsData(content: text, isReply: false, timeString: Date.now))
                }
            }else{
                self.presentr.sendParam?.content?.document?.caption = text
                let arrHeader = self.presentr.messages[self.presentr.messages.count - 1]
                presentr.messages[presentr.messages.count - 1][arrHeader.count - 1].content = text
            }
            
            sendMessage()
            collectionView.reloadData()
        }
    }
    
    func sendMessage(){
        self.loadingIndicator.show()
        self.presentr.sendMessage(param: self.presentr.sendParam!).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            self.loadingIndicator.dismissAfter1()
            switch result{
            case .success(let data):
                let groupMessage = Dictionary(grouping: presentr.messages.last ?? []){ (element) -> String in
                    var dateValue: Date = Date()
                    if #available(iOS 15, *) {
                        dateValue = element.timeString ?? Date.now
                    } else {
                        dateValue = element.timeString ?? Date()
                    }
                    return dateValue.convertDateWithFormat(format: "dd/MM/yyy")
                }
                
                let df = DateFormatter()
                df.dateFormat = "dd/MM/yyy"
                
                let sortedKeys = groupMessage.keys.sorted{ df.date(from: $0)! < df.date(from: $1)!}
                sortedKeys.forEach{ key in
                    let value = groupMessage[key]
                    if self.presentr.page == 1 {
                        self.presentr.messages.append(value ?? [])
                    }else{
                        self.presentr.tempMessages.append(value ?? [])
                    }
                }
                
                print(data)
                collectionView.reloadData()
            case .failure(let error):
                handleError(error: error)
            }
        }).disposed(by: disposeBag)
    }
}
extension ChatViewController: UIDocumentPickerDelegate{
    
    @objc func handleGallery(){
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.mediaTypes = ["public.image", "public_movie"]
        present(imagePicker, animated: true)
    }
    
    @objc func handleCamera(){
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = ["public.image", "public_movie"]
        present(imagePicker, animated: true)
    }
    
    @available(iOS 14.0, *)
    @objc func handleFile(){
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.heic, .heif, .livePhoto, .png, .jpeg, .archive, .pdf, .text])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .overFullScreen
        present(documentPicker, animated: true)
    }
    
    @available(iOS 12, *)
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        dismiss(animated: true){
            self.presentr.sendParam = SendParam(user: SendUser(id: AppSetting.shared.userId, name: AppSetting.shared.userName), content: SendContent(id: Helper.shared.randomAlphanumericString(26), type: "document", document: FileUploader.uploadFile(url: url)))
            
            if #available(iOS 15, *) {
                self.presentr.messages[self.presentr.messages.count - 1].append(ConversationsData(isReply: false, isFile: true, timeString: Date.now, attachmentURL: FileUploader.urlToBase64(url: url)))
            }
            
            if #available(iOS 13.0, *) {
                self.imageView.image = UIImage(systemName: "newspaper.circle")
            }
            
            self.present(self.fileAlertDialog, animated: true)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true)
    }
}

@available(iOS 15, *)
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true){
            guard let mediaType = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaType.rawValue)] as? String else { return }
            if mediaType == "public.image"{
                guard let image = info[.editedImage] as? UIImage else { return }
                self.imageView.image = image
                
                self.presentr.sendParam = SendParam(user: SendUser(id: AppSetting.shared.userId, name: AppSetting.shared.userName), content: SendContent(id: Helper.shared.randomAlphanumericString(26), type: "image", image: FileUploader.uploadImage(image: image)))
                
                self.presentr.messages[self.presentr.messages.count - 1].append(ConversationsData(isReply: false, isImage: true, timeString: Date.now, rawData: FileUploader.imageToBase64(image: image)))
                
                self.present(self.fileAlertDialog, animated: true)
            }else{
                guard let videoUrl = info[.mediaURL] as? URL else { return }
                
                self.presentr.sendParam = SendParam(user: SendUser(id: AppSetting.shared.userId, name: AppSetting.shared.userName), content: SendContent(id: Helper.shared.randomAlphanumericString(26), type: "video", video: FileUploader.uploadVideo(url: videoUrl)))
                
                self.presentr.messages[self.presentr.messages.count - 1].append(ConversationsData(isReply: false, isVideo: true, timeString: Date.now, attachmentURL: FileUploader.urlToBase64(url: videoUrl)))
                
                self.present(self.fileAlertDialog, animated: true)
            }
        }
    }
}

@available(iOS 13.0, *)
extension ChatViewController: ChatCellDelegate{
    
    func cell(playTheVideo cell: ChatCell, videoUrl: URL?) {
        guard let videoURL = videoUrl else { return }
        let controller = VideoViewController(videoURL: videoURL)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(showTheFile cell: ChatCell, fileUrl: URL?) {
        guard let fileURL = fileUrl else { return }
        download(url: fileURL)
    }
    
    func cell(showTheImage cell: ChatCell, imageUrl: URL?) {
        let slideShow = ImageSlideshow()
        
        guard let imageURL = imageUrl else { return }
        
        AF.request(imageURL).responseImage { response in
            debugPrint(response)

            debugPrint(response.result)

            if case .success(let image) = response.result {
                print("image downloaded: \(image)")
                slideShow.setImageInputs([ ImageSource(image: image)])

                slideShow.delegate = self as? ImageSlideshowDelegate

                let controller = slideShow.presentFullScreenController(from: self)
                controller.slideshow.activityIndicator = DefaultActivityIndicator()
            }
        }
    }
}
