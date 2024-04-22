//
//  MessageViewModel.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 07/03/24.
//

import Foundation
import UIKit

struct MessageViewModel{
    let message: ConversationsData
    
    var messageText: String { return message.content ?? "" }
    var messageBackgroundColor: UIColor { return message.isReply == false ? UIColor(hexString: CustomHelper.shared.bgColorSender) : UIColor(hexString: CustomHelper.shared.bgColorReceiver)}
    var messageColor: UIColor { return message.isReply == false ? UIColor(hexString: CustomHelper.shared.lblColorMsgSender) : UIColor(hexString: CustomHelper.shared.lblColorMsgReceiver) }
    
    var rightAnchorActive: Bool { return message.isReply == false ? true : false }
    var leftAnchorActive: Bool { return message.isReply == false ? false : true }
    
    var attachmentURL: URL? { return URL(string: message.attachmentURL ?? "")}
    
    var rawData: String? { return message.attachmentURL ?? nil }
    
    init(message: ConversationsData) {
        self.message = message
    }
}
