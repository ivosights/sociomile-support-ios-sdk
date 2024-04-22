//
//  NotificationController.swift
//  SociomileIosSDKLibrary
//
//  Created by Meynisa on 05/04/24.
//

struct SystemNotification{
    static let newEvent = Notification.Name("newEvent")
}

enum ChatType{
    case IMAGE, VIDEO, FILE, TEXT
}

extension ChatViewController{
    func setupNotif(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.onSystemUpdatedContent), name: SystemNotification.newEvent, object: nil)
    }
    
    @objc private func onSystemUpdatedContent(notification: Notification) {
        let content: String = notification.userInfo?["content"] as? String ?? ""
        let time: Int = Int(Double(notification.userInfo?["time"] as? String ?? "0") ?? 0)
        let timeString: Date = time.convertToDate()
        let isReply: Bool = notification.userInfo?["is_reply"] as? String == "true" ? true : false
        let isImage: Bool = notification.userInfo?["is_image"] as? String == "true" ? true : false
        let isVideo: Bool = notification.userInfo?["is_video"] as? String == "true" ? true : false
        let isFile: Bool = notification.userInfo?["is_file"] as? String == "true" ? true : false
        
        let type: ChatType =  !isImage ? !isVideo ? !isFile ? .TEXT : .FILE : .VIDEO : .IMAGE
        
        switch type{
        case .IMAGE:
            self.presentr.messages[self.presentr.messages.count - 1].append(ConversationsData(content: content, time: time, isReply: isReply, isImage: true, image: [AttachmentData(thumbnail: notification.userInfo?["image_url"] as? String, standard: notification.userInfo?["image_url"] as? String)], timeString: timeString, attachmentURL: notification.userInfo?["image_url"] as? String))
        case .VIDEO:
            self.presentr.messages[self.presentr.messages.count - 1].append(ConversationsData(content: content, time: time, isReply: isReply, isVideo: true, video: AttachmentData(url: notification.userInfo?["video_url"] as? String), timeString: timeString, attachmentURL: notification.userInfo?["video_url"] as? String))
        case .FILE:
            self.presentr.messages[self.presentr.messages.count - 1].append(ConversationsData(content: content, time: time, isReply: isReply, isFile: true, file: AttachmentData(url: notification.userInfo?["file_url"] as? String), timeString: timeString, attachmentURL: notification.userInfo?["file_url"] as? String))
        default:
            presentr.messages[presentr.messages.count - 1].append(ConversationsData(content: content, time: time, isReply: isReply, timeString: timeString))
        }

        collectionView.reloadData()
    }
}
