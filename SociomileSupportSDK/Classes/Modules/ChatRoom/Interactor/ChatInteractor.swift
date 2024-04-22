//
//  ChatInteractor.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import RxSwift
import Foundation
import Alamofire

class ChatInteractor{
    private let apiClient = ApiClient.shared
    
    func getConversation(page: Int) -> Observable<Result<ConversationResponse, ApiError>>{
        return apiClient.request(MessageService.getConversations(page))
    }
    
    func sendMessage(param: SendParam) -> Observable<Result<SendResponse, ApiError>>{
        
        let params: [String : Any?]
        
        if param.content?.type == "text"{
            params = [
                "user": [
                    "id": param.user?.id,
                    "name": param.user?.name
                ],
                "content": [
                    "id": param.content?.id ?? "",
                    "type": param.content?.type ?? "",
                    "text": [
                        "body": param.content?.text?.body
                    ]
                ] as [String : Any]
            ] as [String : Any?]
        }else if param.content?.type == "image"{
            params = [
                "user": [
                    "id": param.user?.id,
                    "name": param.user?.name
                ],
                "content": [
                    "id": param.content?.id ?? "",
                    "type": param.content?.type ?? "",
                    "image": [
                        "name": param.content?.image?.name,
                        "body": param.content?.image?.body,
                        "caption": param.content?.image?.caption
                    ]
                ] as [String : Any]
            ] as [String : Any?]
        }else if param.content?.type == "video"{
            params = [
                "user": [
                    "id": param.user?.id,
                    "name": param.user?.name
                ],
                "content": [
                    "id": param.content?.id ?? "",
                    "type": param.content?.type ?? "",
                    "video": [
                        "name": param.content?.video?.name,
                        "body": param.content?.video?.body,
                        "caption": param.content?.video?.caption
                    ]
                ] as [String : Any]
            ] as [String : Any?]
        }else{
            params = [
                "user": [
                    "id": param.user?.id,
                    "name": param.user?.name
                ],
                "content": [
                    "id": param.content?.id ?? "",
                    "type": param.content?.type ?? "",
                    "document": [
                        "name": param.content?.document?.name,
                        "body": param.content?.document?.body,
                        "caption": param.content?.document?.caption
                    ]
                ] as [String : Any]
            ] as [String : Any?]
        }
        
        return apiClient.request(MessageService.sendMessages(params as Parameters))
    }
    
    func readMessage() -> Observable<Result<ReadResponse, ApiError>>{
        return apiClient.request(MessageService.readMessages)
    }
}
