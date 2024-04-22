//
//  BasePresentr.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import Foundation
import RxSwift

protocol PresenterType {
    associatedtype VTP
    associatedtype PTV
    
    func bind(vtp: VTP) -> PTV
    
}

class BasePresenter: NSObject {
    open var bag = DisposeBag()
    
}
