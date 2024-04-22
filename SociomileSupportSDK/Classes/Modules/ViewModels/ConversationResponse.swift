//
//  ConversationResponse.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import Foundation

struct ConversationResponse: Codable{
    var status: Bool?
    var message: String?
    var data: [ConversationsData]?
    var meta: Meta?
}


struct ConversationsData: Codable{
    var id: String?
    var content: String?
    var time: Int?
    var timeString: Date?
    var isRead: Bool?
    var isReply: Bool?
    var isImage: Bool? = false
    var isVideo: Bool? = false
    var isFile: Bool? = false
    var isSent: Bool?
    var isLocal: Bool?
    var repliedBy: RepliedBy?
    var image: [AttachmentData]?
    var video: AttachmentData?
    var file: AttachmentData?
    var attachmentURL: String?
    var rawData: String?
    
    enum CodingKeys: String, CodingKey{
        case id, content, time, image, video, file, timeString, attachmentURL, rawData
        case repliedBy = "replied_by"
        case isRead = "is_read"
        case isReply = "is_reply"
        case isImage = "is_image"
        case isVideo = "is_video"
        case isFile = "is_file"
        case isSent = "is_sent"
        case isLocal = "is_local"
    }
    
    init(id: String? = nil, content: String? = nil, time: Int? = nil, isRead: Bool? = nil, isReply: Bool? = nil, isImage: Bool? = false, isVideo: Bool? = false, isFile: Bool? = false, isSent: Bool? = nil, isLocal: Bool? = nil, image: [AttachmentData]? = nil, video: AttachmentData? = nil, file: AttachmentData? = nil, timeString: Date? = nil, repliedBy: RepliedBy? = nil, attachmentURL: String? = nil, rawData: String? = nil) {
        self.id = id
        self.content = content
        self.time = time
        self.repliedBy = repliedBy
        self.isRead = isRead
        self.isReply = isReply
        self.isImage = isImage
        self.isVideo = isVideo
        self.isFile = isFile
        self.isSent = isSent
        self.isLocal = isLocal
        self.image = image
        self.video = video
        self.file = file
        self.timeString = timeString
        self.attachmentURL = attachmentURL
        self.rawData = rawData
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.time = try container.decodeIfPresent(Int.self, forKey: .time)
        self.repliedBy = try container.decodeIfPresent(RepliedBy.self, forKey: .repliedBy)
        self.image = try container.decodeIfPresent([AttachmentData].self, forKey: .image)
        self.video = try container.decodeIfPresent(AttachmentData.self, forKey: .video)
        self.file = try container.decodeIfPresent(AttachmentData.self, forKey: .file)
        self.isRead = try container.decodeIfPresent(Bool.self, forKey: .isRead)
        self.isReply = try container.decodeIfPresent(Bool.self, forKey: .isReply)
        self.isImage = try container.decodeIfPresent(Bool.self, forKey: .isImage) ?? false
        self.isVideo = try container.decodeIfPresent(Bool.self, forKey: .isVideo) ?? false
        self.isFile = try container.decodeIfPresent(Bool.self, forKey: .isFile) ?? false
        self.isSent = try container.decodeIfPresent(Bool.self, forKey: .isSent)
        self.isLocal = try container.decodeIfPresent(Bool.self, forKey: .isLocal)
        if #available(iOS 15, *) {
            self.timeString = self.time == nil ? Date.now : self.time?.convertToDate()
        }
        self.attachmentURL = isFile == false ? isVideo == false ? isImage == true ? image?[0].standard : "" : video?.url : file?.url
    }
}

struct AttachmentData: Codable{
    var thumbnail: String?
    var standard: String?
    var url: String?
    var duration: Int?
    var name: String?
    
    init(thumbnail: String? = nil, standard: String? = nil, url: String? = nil, duration: Int? = nil, name: String? = nil) {
        self.thumbnail = thumbnail
        self.standard = standard
        self.url = url
        self.duration = duration
        self.name = name
    }
}

struct Meta: Codable{
    var currentPage: Int?
    var from: Int?
    var lastPage: Int?
    var to: Int?
    var total: Int?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case lastPage = "last_page"
        case from, to, total
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currentPage = try container.decodeIfPresent(Int.self, forKey: .currentPage)
        self.from = try container.decodeIfPresent(Int.self, forKey: .from)
        self.lastPage = try container.decodeIfPresent(Int.self, forKey: .lastPage)
        self.to = try container.decodeIfPresent(Int.self, forKey: .to)
        self.total = try container.decodeIfPresent(Int.self, forKey: .total)
    }
    
}

struct RepliedBy: Codable{
    var name: String?
    var photo: String?
    
    init(name: String? = nil, photo: String? = nil) {
        self.name = name
        self.photo = photo
    }
}
