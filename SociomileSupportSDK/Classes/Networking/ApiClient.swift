//
//  ApiClient.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import Foundation
import Alamofire
import RxSwift

class ApiClient: NSObject {
    
    static let shared = ApiClient()
    
    public lazy var session: Session = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300

//        let evaluators: [String: ServerTrustEvaluating] = [
//            "*.nobubank.com": PinnedCertificatesTrustEvaluator()
//        ]
//
//        let manager = WildcardServerTrustPolicyManager(evaluators: evaluators)
        return Session(configuration: configuration)
    }()

    func request<T: Decodable> (_ urlConvertible: URLRequestConvertible) -> Observable<Result<T, ApiError>> {
        // Create an RxSwift observable, which will be the one to call the request when subscribed to
        return Observable<Result<T, ApiError>>.create { observer in
            // Trigger the HttpRequest using AlamoFire (AF)
            let request = self.session.request(urlConvertible)
                .validate()
                .responseDecodable { (response: DataResponse<T, AFError>) in
                // Check the result from Alamofire's response and check if it's a success or a failure
                    debugPrint(response)
                switch response.result {
                case let .success(value):
                    // get session token
                    if let headerResponse = response.response?.allHeaderFields {
                        if let sessionToken: String = headerResponse["access_token"] as? String {
                            AppSetting.shared.sessionToken = sessionToken
                        }
                    }
                    // Everything is fine, return the value in onNext
                    observer.onNext(.success(value))
                    observer.onCompleted()
                case .failure:
                    // Something went wrong, switch on the status code and return the error
                    
                    switch response.response?.statusCode {
                    case 401:
                        observer.onNext(.failure(ApiError.unauthorized))
                    case 403:
                        observer.onNext(.failure(ApiError.forbidden))
                    case 404:
                        observer.onNext(.failure(ApiError.notFound))
                    case 409:
                        observer.onNext(.failure(ApiError.conflict))
                    case 500:
                        observer.onNext(.failure(ApiError.internalServerError))
                    default:
                        if let data = response.data {
                            do {
                                let response = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                observer.onNext(.failure(ApiError.error(response)))
                            } catch {
                                observer.onNext(.failure(ApiError.unknown))
                            }
                        } else {
                            observer.onNext(.failure(ApiError.unknown))
                        }
                    }
                    observer.onCompleted()
                }
            }
            
            // Finally, we return a disposable to stop the request
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func requestWithEmptyResponse<T: Decodable> (_ urlConvertible: URLRequestConvertible) -> Observable<Result<T?, ApiError>> {
        // Create an RxSwift observable, which will be the one to call the request when subscribed to
        return Observable<Result<T?, ApiError>>.create { observer in
            // Trigger the HttpRequest using AlamoFire (AF)
            let request = self.session.request(urlConvertible)
                .validate()
                .responseDecodable { (response: DataResponse<T, AFError>) in
                // Check the result from Alamofire's response and check if it's a success or a failure
                    debugPrint(response)
                switch response.result {
                case let .success(value):
                    // get session token
                    if let headerResponse = response.response?.allHeaderFields {
                        if let sessionToken: String = headerResponse["access_token"] as? String {
                            AppSetting.shared.sessionToken = sessionToken
                        }
                    }
                    // Everything is fine, return the value in onNext
                    observer.onNext(.success(value))
                    observer.onCompleted()
                case .failure:
                    // Something went wrong, switch on the status code and return the error
                    
                    switch response.response?.statusCode {
                    case 200:
                        observer.onNext(.success(nil))
                    case 401:
                        observer.onNext(.failure(ApiError.unauthorized))
                    case 403:
                        observer.onNext(.failure(ApiError.forbidden))
                    case 404:
                        observer.onNext(.failure(ApiError.notFound))
                    case 409:
                        observer.onNext(.failure(ApiError.conflict))
                    case 500:
                        observer.onNext(.failure(ApiError.internalServerError))
                    default:
                        if let data = response.data {
                            do {
                                let response = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                observer.onNext(.failure(ApiError.error(response)))
                            } catch {
                                observer.onNext(.failure(ApiError.unknown))
                            }
                        } else {
                            observer.onNext(.failure(ApiError.unknown))
                        }
                    }
                    observer.onCompleted()
                }
            }
            
            // Finally, we return a disposable to stop the request
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func requestData(_ urlConvertible: URLRequestConvertible) -> Observable<AFDataResponse<Data>> {
        return Observable<AFDataResponse<Data>>.create { observer in
            let request = self.session.request(urlConvertible)
//                .validate()
                .responseData { response in
                    debugPrint(response)
                    
                    switch response.result {
                    case .success:
                        observer.onNext(response)
                    case .failure:
                        observer.onCompleted()
                    }
                }
            // Finally, we return a disposable to stop the request
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func requestWithResponseErrorObject<T: Decodable> (_ urlConvertible: URLRequestConvertible) -> Observable<Result<T, ErrorApi>> {
        // Create an RxSwift observable, which will be the one to call the request when subscribed to
        return Observable<Result<T, ErrorApi>>.create { observer in
            // Trigger the HttpRequest using AlamoFire (AF)
            let request = self.session.request(urlConvertible)
                .validate()
                .responseDecodable { (response: DataResponse<T, AFError>) in
                // Check the result from Alamofire's response and check if it's a success or a failure
                    debugPrint(response)
                switch response.result {
                case let .success(value):
                    // get session token
                    if let headerResponse = response.response?.allHeaderFields {
                        if let sessionToken: String = headerResponse["access_token"] as? String {
                            AppSetting.shared.sessionToken = sessionToken
                        }
                    }
                    // Everything is fine, return the value in onNext
                    observer.onNext(.success(value))
                    observer.onCompleted()
                case .failure:
                    // Something went wrong, switch on the status code and return the error
                    
                    switch response.response?.statusCode {
                    case Int(ErrorDetail.INVALID_TOKEN.value):
                        if let data = response.data {
                            do {
                                let response = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                observer.onNext(.failure(ErrorApi.unauthorized(response)))
                            } catch {
                                observer.onNext(.failure(ErrorApi.unknown))
                            }
                        } else {
                            observer.onNext(.failure(ErrorApi.unknown))
                        }
                    case 403:
                        observer.onNext(.failure(ErrorApi.forbidden))
                    case 404:
                        observer.onNext(.failure(ErrorApi.notFound))
                    case 409:
                        observer.onNext(.failure(ErrorApi.conflict))
                    case Int(ErrorDetail.ERROR_500.value):
                        observer.onNext(.failure(ErrorApi.internalServerError))
                    default:
                        if let data = response.data {
                            do {
                                let response = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                observer.onNext(.failure(ErrorApi.error(response)))
                            } catch {
                                observer.onNext(.failure(ErrorApi.unknown))
                            }
                        } else {
                            observer.onNext(.failure(ErrorApi.unknown))
                        }
                    }
                    observer.onCompleted()
                }
            }
            
            // Finally, we return a disposable to stop the request
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func requestWithResponseEmpty<T: Decodable> (_ urlConvertible: URLRequestConvertible) -> Observable<Result<T?, ErrorApi>> {
        // Create an RxSwift observable, which will be the one to call the request when subscribed to
        return Observable<Result<T?, ErrorApi>>.create { observer in
            // Trigger the HttpRequest using AlamoFire (AF)
            let request = self.session.request(urlConvertible)
                .validate()
                .responseDecodable { (response: DataResponse<T, AFError>) in
                // Check the result from Alamofire's response and check if it's a success or a failure
                    debugPrint(response)
                switch response.result {
                case let .success(value):
                    // get session token
                    if let headerResponse = response.response?.allHeaderFields {
                        if let sessionToken: String = headerResponse["access_token"] as? String {
                            AppSetting.shared.sessionToken = sessionToken
                        }
                    }
                    // Everything is fine, return the value in onNext
                    observer.onNext(.success(value))
                    observer.onCompleted()
                case .failure:
                    // Something went wrong, switch on the status code and return the error
                    
                    switch response.response?.statusCode {
                    case 200:
                        observer.onNext(.success(nil))
                    case Int(ErrorDetail.INVALID_TOKEN.value):
                        if let data = response.data {
                            do {
                                let response = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                observer.onNext(.failure(ErrorApi.unauthorized(response)))
                            } catch {
                                observer.onNext(.failure(ErrorApi.unknown))
                            }
                        } else {
                            observer.onNext(.failure(ErrorApi.unknown))
                        }
                    case 403:
                        observer.onNext(.failure(ErrorApi.forbidden))
                    case 404:
                        observer.onNext(.failure(ErrorApi.notFound))
                    case 409:
                        observer.onNext(.failure(ErrorApi.conflict))
                    case Int(ErrorDetail.ERROR_500.value):
                        observer.onNext(.failure(ErrorApi.internalServerError))
                    default:
                        if let data = response.data {
                            do {
                                let response = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                observer.onNext(.failure(ErrorApi.error(response)))
                            } catch {
                                observer.onNext(.failure(ErrorApi.unknown))
                            }
                        } else {
                            observer.onNext(.failure(ErrorApi.unknown))
                        }
                    }
                    observer.onCompleted()
                }
            }
            
            // Finally, we return a disposable to stop the request
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
