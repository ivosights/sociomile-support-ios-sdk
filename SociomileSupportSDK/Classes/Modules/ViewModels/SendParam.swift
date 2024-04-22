//
//  SendParam.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import UIKit

struct SendUser{
    var id: String?
    var name: String?
    
    init(id: String? = nil, name: String? = nil) {
        self.id = id
        self.name = name
    }
}

struct DataContent{
    var name: String?
    var body: String?
    var caption: String?
    
    init(name: String? = nil, body: String? = nil, caption: String? = nil) {
        self.name = name
        self.body = body
        self.caption = caption
    }
}

struct SendContent{
    var id: String?
    var type: String?
    var text: DataContent?
    var image: DataContent?
    var video: DataContent?
    var document: DataContent?
    
    init(id: String? = nil, type: String? = nil, text: DataContent? = nil, image: DataContent? = nil, video: DataContent? = nil, document: DataContent? = nil) {
        self.id = id
        self.type = type
        self.text = text
        self.image = image
        self.video = video
        self.document = document
    }
}

struct SendParam{
    var user: SendUser?
    var content: SendContent?
    
    init(user: SendUser? = nil, content: SendContent? = nil) {
        self.user = user
        self.content = content
    }
}
