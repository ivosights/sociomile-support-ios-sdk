//
//  ChatPresentr.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import Foundation
import RxCocoa
import RxSwift

class ChatPresentr: PresenterType{
    
    private let interactor: ChatInteractor
    private let router: ChatRouter
    var messages: [[ConversationsData]] = []
    var tempMessages: [[ConversationsData]] = []
    var sendParam: SendParam?
    var page: Int = 1
    var pageLimit: Int = 20
    var pageTotal: Int = 1
    
    init(interactor: ChatInteractor, router: ChatRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    struct VTP {
        let didLoadTrigger: Driver<Void>
    }
    
    struct PTV {
        let componentOutput: Driver<ConversationResponse>
        let dataFailed: Driver<ApiError>
        let isLoading: Driver<Bool>
    }
    
    func bind(vtp: VTP) -> PTV {
        let isLoadingSubject = PublishSubject<Bool>()
        
        let componentOutput = vtp.didLoadTrigger.flatMapLatest{ [self, interactor] _ -> Driver<Result<ConversationResponse, ApiError>> in
            
            isLoadingSubject.onNext(true)
            return interactor.getConversation(page: page).asDriver(onErrorDriveWith: .never())
        }.do(onNext: { [isLoadingSubject] _ in
            isLoadingSubject.onNext(false)
        })
        
        let componentOutputSuccess = componentOutput.compactMap{ result -> ConversationResponse? in
            guard case let .success(data) = result else { return nil }
            self.messages.removeAll()
            self.processingData(data: data)
            return data
        }
        
        let componentOutputFailed = componentOutput.compactMap{ result -> ApiError? in
            guard case let .failure(error) = result else { return nil }
            return error
        }
        
        return PTV(componentOutput: componentOutputSuccess, dataFailed: componentOutputFailed, isLoading: isLoadingSubject.asDriver(onErrorDriveWith: .never()))
    }
    
    func processingData(data: ConversationResponse){
        self.tempMessages.removeAll()
        pageTotal = data.meta?.lastPage ?? 1
        page = data.meta?.currentPage ?? 1
        let groupMessage = Dictionary(grouping: data.data ?? []){ (element) -> String in
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
            if page == 1 {
                self.messages.append(value ?? [])
            }else{
                self.tempMessages.append(value ?? [])
            }
        }
        if page != 1{
            self.messages.insert(contentsOf: self.tempMessages, at: 0)}
    }
    
    func getMessages() -> Observable<Result<ConversationResponse, ApiError>>{
        return interactor.getConversation(page: page)
    }
    
    func sendMessage(param: SendParam) -> Observable<Result<SendResponse, ApiError>>{
        return interactor.sendMessage(param: param)
    }
    
    func readMessage() -> Observable<Result<ReadResponse, ApiError>> {
        return interactor.readMessage()
    }
}
