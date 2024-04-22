//
//  FileUploader.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 14/03/24.
//

import UIKit
import MobileCoreServices
import AVFoundation

struct FileUploader{
    //MARK: - upload image
    static func uploadImage(image: UIImage) -> DataContent{
        let base64String: String = imageToBase64(image: image)
        
        let filename = NSUUID().uuidString
        
        let dataContent: DataContent = DataContent(name: filename, body: base64String, caption: "")
        return dataContent
    }
    
    static func uploadFile(url: URL) -> DataContent{
        let data = try? Data(contentsOf: url)

        let base64String = data?.base64EncodedString(options: .lineLength64Characters)
        let filename = NSUUID().uuidString
        
        let dataContent: DataContent = DataContent(name: filename, body: base64String, caption: "")
        return dataContent
    }
    
    //MARK: - upload video
    static func uploadVideo(url: URL) -> DataContent{

        let name = "\(Int(Date().timeIntervalSince1970)).mp4"
        let path = NSTemporaryDirectory() + name

        let dispatchgroup = DispatchGroup()

        dispatchgroup.enter()

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputurl = documentsURL.appendingPathComponent(name)
        var ur = outputurl
        self.convertVideo(toMPEG4FormatForVideo: url as URL, outputURL: outputurl) { (session) in

            ur = session.outputURL!
            dispatchgroup.leave()

        }
        dispatchgroup.wait()

        let data = NSData(contentsOf: ur as URL)

        do {

            try data?.write(to: URL(fileURLWithPath: path), options: .atomic)

        } catch {

            print(error)
        }

        let base64String = data?.base64EncodedString(options: .lineLength64Characters)
//        let convertedString = base64String?.urlQueryValueEscaped
        
        let filename = NSUUID().uuidString
        
        let dataContent: DataContent = DataContent(name: filename, body: base64String, caption: "")
        return dataContent
    }
    
    static func convertVideo(toMPEG4FormatForVideo inputURL: URL, outputURL: URL, handler: @escaping (AVAssetExportSession) -> Void) {
        let asset = AVURLAsset(url: inputURL as URL, options: nil)

        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously(completionHandler: {
            handler(exportSession)
        })
    }
    
    static func based64ToImage(base64String: String) -> UIImage{
        let imageData: Data? = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)
        return UIImage.init(data: imageData!)!
    }
    
    static func imageToBase64(image: UIImage) -> String{
        let imageData = image.jpegData(compressionQuality: 0.75)
        let base64String = imageData?.base64EncodedString(options: .lineLength64Characters)
        
        return base64String!
    }
    
    static func urlToBase64(url: URL) -> String{
        let data = try? Data(contentsOf: url)

        let base64String = data?.base64EncodedString(options: .lineLength64Characters)
        return base64String!
    }
}

