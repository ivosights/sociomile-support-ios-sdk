//
//  ApiError.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 06/03/24.
//

import Foundation

enum ApiError: Error {
    case unauthorized           // Status code 401
    case forbidden              // Status code 403
    case notFound               // Status code 404
    case conflict               // Status code 409
    case internalServerError    // Status code 500
    case unknown
    case error(ErrorResponse)
    
    var localizedDescription: String {
        switch self {
        case .unauthorized:
            return .localized("login.popup.sessionExp.msg")
        case .forbidden:
            return ""
        case .notFound:
            return "Error code not found"
        case .conflict:
            return ""
        case .internalServerError:
            return .localized("common.error.server")
        case .unknown:
            return .localized("common.error.unknown")
        case let .error(response):
            return response.message
        }
    }
}

enum ErrorApi: Error {
    case unauthorized(ErrorResponse)          // Status code 401
    case forbidden              // Status code 403
    case notFound               // Status code 404
    case conflict               // Status code 409
    case internalServerError    // Status code 500
    case unknown
    case error(ErrorResponse)
    
    var deconstructErrMsg: ErrorResponseApi {
        switch self {
        case let .unauthorized(res):
            let msg: String = res.message
            return ErrorResponseApi(
               errorCode: res.errorCode == ErrorDetail.INVALID_TOKEN.value ? ErrorDetail.INVALID_TOKEN.value : res.errorCode,
               sourceSystem: res.sourceSystem.isEmpty ? "" : "\(res.sourceSystem) - ",
               message: res.errorCode == ErrorDetail.INVALID_TOKEN.value ? .localized("login.popup.sessionExp.msg") : msg,
               transactionId: "",
               activityRefCode: "",
               failedPinAttempts: 0,
               settingFailedPinAttempts: 0)
        case .forbidden:
            return ErrorResponseApi(
               errorCode: "",
               sourceSystem: "",
               message: "",
               transactionId: "",
               activityRefCode: "",
               failedPinAttempts: 0,
               settingFailedPinAttempts: 0)
        case .notFound:
            return ErrorResponseApi(
               errorCode: "",
               sourceSystem: "",
               message: "",
               transactionId: "",
               activityRefCode: "",
               failedPinAttempts: 0,
               settingFailedPinAttempts: 0)
        case .conflict:
            return ErrorResponseApi(
               errorCode: "",
               sourceSystem: "",
               message: "",
               transactionId: "",
               activityRefCode: "",
               failedPinAttempts: 0,
               settingFailedPinAttempts: 0)
        case .internalServerError:
            return ErrorResponseApi(
               errorCode: "",
               sourceSystem: "",
               message: .localized("common.error.server"),
               transactionId: "",
               activityRefCode: "",
               failedPinAttempts: 0,
               settingFailedPinAttempts: 0)
        case .unknown:
            return ErrorResponseApi(
               errorCode: "",
               sourceSystem: "",
               message: .localized("common.error.unknown"),
               transactionId: "",
               activityRefCode: "",
               failedPinAttempts: 0,
               settingFailedPinAttempts: 0)
        case let .error(response):
            let msg: String = response.message
            return ErrorResponseApi(
                errorCode: response.errorCode,
                sourceSystem: response.sourceSystem.isEmpty ? "" : "\(response.sourceSystem) - ",
                message: msg,
                transactionId: response.transactionId,
                activityRefCode: response.activityRefCode,
                failedPinAttempts: response.failedPinAttempts,
                settingFailedPinAttempts: response.settingFailedPinAttempts)
        }
    }
}

enum ErrorDetail {
    case ERROR_OTP_RESEND_WAITING
    case USER_MULTIPLE_BLOCKED
    case INVALID_TOKEN
    case ERROR_SERVICE_BAD_GETWAY
    case ERROR_OTP_MAX_ATTEMPT
    case ERROR_400
    case ERROR_500
    case ERROR_SAME_PASSWORD
    case ERROR_BAD_GATEWAY
    case ERROR_SERVICE_UNAVAILABLE
    case ERROR_SOMETHING_WENT_WRONG
    case ERROR_ACCOUNT_NUMBER_ALREADY_REGISTERED
    case ERROR_ACCOUNT_NUMBER_ALREADY_AVAILABLE
    case ERROR_ACCOUNT_NAME_ALREADY_USED
    case ERROR_DAILY_MAXIMUM_LIMIT
    case ERROR_OTP_INVALID
    case ERROR_PARAMETER_NOT_FOUND
    case ERROR_HISTORY_TRANSACTION_NOT_FOUND
    case ERROR_USER_BLOCKED
    case ERROR_USER_ALREADY_BLOCKED
    case ERROR_USER_OR_PASSWORD_NOT_FOUND
    case ERROR_PAYMENT_HISTORY_NOT_FOUND
    case ERROR_EMAIL_ALREADY_REGISTERED
    case ERROR_USERNAME_ALREADY_REGISTERED
    case ERROR_SOF_NOT_ALLOWED
    case ERROR_MPIN_NOT_VALID
    case ERROR_FAVOURITE_NAME_ALREADY_EXIST
    case ERROR_DATA_NOT_FOUND
    case ERROR_INVALID_PASSWORD
    case ERROR_USER_SUSPECTED
    case ERROR_ENCRYPTION_FAILED
    case ERROR_INVALID_USERNAME
    case ERROR_INVALID_ACCOUNT_NUMBER
    case ERROR_USER_ALREADY_LOGIN
    case ERROR_USER_ALREADY_LOGIN_SAME_DEVICE
    case ERROR_USER_INACTIVE
    case ERROR_TRANSACTION_AMOUNT_LESS_THAN_MINIMUM
    case ERROR_TRANSACTION_AMOUNT_MORE_THAN_MAXIMUM
    case CONNECTION_REFUSED
    case TRANSACTION_NOT_FOUND
    case ACCOUNT_NOT_FOUND
    case BENEFICIARY_ALREADY_EXISTS
    case ERROR_FAVORITE_ALREADY_ADDED
    case ERROR_ALREADY_IN_FAVORITE
    case ERROR_TRANSACTION_REACH_MINIMUM_LIMIT
    case ERROR_RTGS_REACH_MINIMUM_LIMIT
    case ERROR_TRANSACTION_DENIED
    case INSUFFICIENT_ACCOUNT_BALANCE
    case INSUFFICIENT_DEBIT_BALANCE
    case CANNOT_MAKE_TRANSACTION
    case INVALID_TRASACTION
    case LOAN_HASBEN_PAID
    case EXCEED_THE_MAXIMUM_LIMIT
    case TRANSFER_BENEFICIARY_NOT_FOUND
    case ERROR_WRONG_PHONE_NUMBER
    case TRANSACTION_ON_PROGRESS
    case CANT_MAKE_TRANSACTION
    case INTERNAL_SERVER_ERROR
    case TRANSACTION_ALREADY_PADI
    case ACCOUNT_NUMBER_NOT_FOUND
    case CANT_PROCESSED_TRANSACTION
    case INVALID_DATA_CUSTOMER
    case SELFIE_PHOTO_NO_SAME
    case TRANSACTION_LIMIT
    case INQUIRY_SUCCES
    case INQUIRY_INVALID_NUMBER
    case INSUFFICIENT_BALANCE
    case PAYMENT_DATA_NOT_FOUND
    case TRANSACTION_REACH_MAX_LIMIT
    case TRANSACTION_LESS_MIN_LIMIT
    case ERROR_TRANSACTION_DAILY_AMOUNT_LIMIT
    case ERROR_TRANSACTION_DAILY_INQUIRY_LIMIT
    case ERROR_TRANSACTION_SOURCE_LIMIT
    case ERROR_MAKER_TRANSACTION_LIMIT
    
    var value: String {
        switch self {
        case .ERROR_OTP_RESEND_WAITING: return "0049"
        case .USER_MULTIPLE_BLOCKED: return "0185"
        case .INVALID_TOKEN: return "401"
        case .ERROR_SERVICE_BAD_GETWAY: return "502"
        case .ERROR_OTP_MAX_ATTEMPT: return "0043"
        case .ERROR_400: return "400"
        case .ERROR_500: return "500"
        case .ERROR_SAME_PASSWORD: return "0165"
        case .ERROR_BAD_GATEWAY: return "502"
        case .ERROR_SERVICE_UNAVAILABLE: return "503"
        case .ERROR_SOMETHING_WENT_WRONG: return "0019"
        case .ERROR_ACCOUNT_NUMBER_ALREADY_REGISTERED: return "0092"
        case .ERROR_ACCOUNT_NUMBER_ALREADY_AVAILABLE: return "0094"
        case .ERROR_ACCOUNT_NAME_ALREADY_USED: return "0020"
        case .ERROR_DAILY_MAXIMUM_LIMIT: return "0021"
        case .ERROR_OTP_INVALID: return "0022"
        case .ERROR_PARAMETER_NOT_FOUND: return "0023"
        case .ERROR_HISTORY_TRANSACTION_NOT_FOUND: return "0024"
        case .ERROR_USER_BLOCKED: return "0025"
        case .ERROR_USER_ALREADY_BLOCKED: return "0120"
        case .ERROR_USER_OR_PASSWORD_NOT_FOUND: return "0026"
        case .ERROR_PAYMENT_HISTORY_NOT_FOUND: return "0027"
        case .ERROR_EMAIL_ALREADY_REGISTERED: return "0028"
        case .ERROR_USERNAME_ALREADY_REGISTERED: return "0029"
        case .ERROR_SOF_NOT_ALLOWED: return "0030"
        case .ERROR_MPIN_NOT_VALID: return "0031"
        case .ERROR_FAVOURITE_NAME_ALREADY_EXIST: return "0032"
        case .ERROR_DATA_NOT_FOUND: return "0033"
        case .ERROR_INVALID_PASSWORD: return "0034"
        case .ERROR_USER_SUSPECTED: return "0035"
        case .ERROR_ENCRYPTION_FAILED: return "0036"
        case .ERROR_INVALID_USERNAME: return "0037"
        case .ERROR_INVALID_ACCOUNT_NUMBER: return "0038"
        case .ERROR_USER_ALREADY_LOGIN: return "0039"
        case .ERROR_USER_ALREADY_LOGIN_SAME_DEVICE: return ""
        case .ERROR_USER_INACTIVE: return "0158"
        case .ERROR_TRANSACTION_AMOUNT_LESS_THAN_MINIMUM: return "0040"
        case .ERROR_TRANSACTION_AMOUNT_MORE_THAN_MAXIMUM: return "0041"
        case .CONNECTION_REFUSED: return "0042"
        case .TRANSACTION_NOT_FOUND: return "404"
        case .ACCOUNT_NOT_FOUND: return "0033"
        case .BENEFICIARY_ALREADY_EXISTS: return "0190"
        case .ERROR_FAVORITE_ALREADY_ADDED: return "0094"
        case .ERROR_ALREADY_IN_FAVORITE: return "0138"
        case .ERROR_TRANSACTION_REACH_MINIMUM_LIMIT: return "0097"
        case .ERROR_RTGS_REACH_MINIMUM_LIMIT: return "0040"
        case .ERROR_TRANSACTION_DENIED: return "0096"
        case .INSUFFICIENT_ACCOUNT_BALANCE: return "02"
        case .INSUFFICIENT_DEBIT_BALANCE: return "06"
        case .CANNOT_MAKE_TRANSACTION: return "C0107"
        case .INVALID_TRASACTION: return "971"
        case .LOAN_HASBEN_PAID: return "79"
        case .EXCEED_THE_MAXIMUM_LIMIT: return "0095"
        case .TRANSFER_BENEFICIARY_NOT_FOUND: return "0117"
        case .ERROR_WRONG_PHONE_NUMBER: return "0114"
        case .TRANSACTION_ON_PROGRESS: return "68"
        case .CANT_MAKE_TRANSACTION: return "05"
        case .INTERNAL_SERVER_ERROR: return "99"
        case .TRANSACTION_ALREADY_PADI: return "XY"
        case .ACCOUNT_NUMBER_NOT_FOUND: return "01"
        case .CANT_PROCESSED_TRANSACTION: return "89"
        case .INVALID_DATA_CUSTOMER: return "14"
        case .SELFIE_PHOTO_NO_SAME: return"0140"
        case .TRANSACTION_LIMIT: return "54"
        case .INQUIRY_SUCCES: return "00"
        case .INQUIRY_INVALID_NUMBER: return "01"
        case .INSUFFICIENT_BALANCE: return "0045"
        case .PAYMENT_DATA_NOT_FOUND: return "0033"
        case .TRANSACTION_REACH_MAX_LIMIT: return "0179"
        case .TRANSACTION_LESS_MIN_LIMIT: return "0178"
        case .ERROR_TRANSACTION_DAILY_AMOUNT_LIMIT: return "0180"
        case .ERROR_TRANSACTION_DAILY_INQUIRY_LIMIT: return "0181"
        case .ERROR_TRANSACTION_SOURCE_LIMIT: return "0182"
        case .ERROR_MAKER_TRANSACTION_LIMIT: return "0183"
        }
    }
}

struct ErrorResponse: Decodable {
    let errorCode: String
    let sourceSystem: String
    let message: String
    let transactionId: String
    let engMessage: String
    let idnMessage: String
    let activityRefCode: String
    let failedPinAttempts: Int
    let settingFailedPinAttempts: Int
    
    private enum CodingKeys: String, CodingKey {
        case errorCode, sourceSystem, message,
             transactionId, engMessage, idnMessage,
             activityRefCode, failedPinAttempts, settingFailedPinAttempts
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        errorCode = (try? values.decodeIfPresent(String.self, forKey: .errorCode)) ?? ""
        sourceSystem = (try? values.decodeIfPresent(String.self, forKey: .sourceSystem)) ?? ""
        message = (try? values.decodeIfPresent(String.self, forKey: .message)) ?? ""
        transactionId = (try? values.decodeIfPresent(String.self, forKey: .transactionId)) ?? ""
        engMessage = (try? values.decodeIfPresent(String.self, forKey: .engMessage)) ?? ""
        idnMessage = (try? values.decodeIfPresent(String.self, forKey: .idnMessage)) ?? ""
        activityRefCode = (try? values.decodeIfPresent(String.self, forKey: .activityRefCode)) ?? ""
        failedPinAttempts = (try? values.decodeIfPresent(Int.self, forKey: .failedPinAttempts)) ?? 0
        settingFailedPinAttempts = (try? values.decodeIfPresent(Int.self, forKey: .settingFailedPinAttempts)) ?? 0
    }
    
    init(_ idnMessage: String, engMessage: String = "", errorCode: String = "", message: String = "") {
        self.idnMessage = idnMessage
        self.engMessage = engMessage
        self.errorCode = errorCode
        sourceSystem = ""
        self.message = message
        transactionId = ""
        activityRefCode = ""
        failedPinAttempts = 0
        settingFailedPinAttempts = 0
    }
}

struct ErrorResponseApi {
    let errorCode: String
    let sourceSystem: String
    let message: String
    let transactionId: String
    let activityRefCode: String
    let failedPinAttempts: Int
    let settingFailedPinAttempts: Int
}
