//
//  BaseViewController.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 13/03/24.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController, UIGestureRecognizerDelegate{
    let disposeBag = DisposeBag()
    lazy var loadingIndicator = PopUpLoading(on: view)
    let documentInteractionController = UIDocumentInteractionController()
    var pdfFilePath = URL(string: "")
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preload()
        self.endEditingView()
        self.addObservers()
    }
    
    func preload() {}
    
    func stopRefreshInquiryRate() {}
    
    func endEditingView() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func showPopupGeneral(title: String,
                          message: String,
                          descBottom: String = "",
                          boldValues: [String], error: String = "") {
        let imgName = "illustration-mobile"
        let popUpWindow = PopUpWindow.init(
            imageName: imgName,
            title: title,
            desc: message,
            descBottom: descBottom,
            primaryButtonTitle: "OK",
            secondaryButtonTitle: "",
            primaryButtonTapped: {
                if title == "Berhasil"{
                    self.navigationController?.popToRootViewController(animated: true)
                } else if title == ErrorDetail.INVALID_TOKEN.value || error == ApiError.unauthorized.localizedDescription{
                  
                }
            },
            boldValues: boldValues
        )
        self.present(popUpWindow, animated: true, completion: nil)
    }
}

// MARK: - Download And Share
extension BaseViewController {
    public func download(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        showCustomToast(message: "Berhasil mengunduh \(String(describing: documentInteractionController.name))")
        documentInteractionController.delegate = self
    }
    
    public func sharePdf(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentOptionsMenu(from: view.frame, in: view, animated: true)
        documentInteractionController.delegate = self
    }
    
    public func sharePng(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.delegate = self
        
        let urlPath = url
        guard let document = CGPDFDocument(urlPath as CFURL) else { return }
        
        var imageShare = [UIImage]()
        
        for doc in 1...document.numberOfPages {
            guard let page = document.page(at: doc) else { return }
            let pageRect = page.getBoxRect(.mediaBox)
            let cropRect = pageRect
            let renderer = UIGraphicsImageRenderer(size: cropRect.size)
            let img = renderer.image { ctx in
                UIColor.white.set()
                ctx.fill(CGRect(x: 0, y: 0, width: cropRect.width, height: cropRect.height))
                ctx.cgContext.translateBy(x: -cropRect.origin.x, y: pageRect.size.height - cropRect.origin.y)
                ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                ctx.cgContext.drawPDFPage(page)
            }
            imageShare.append(img)
        }
        let activityViewController = UIActivityViewController(activityItems: imageShare, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        
    }
}

extension BaseViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
    }
    
    func documentInteractionControllerDidDismissOptionsMenu(_ controller: UIDocumentInteractionController) {
    }
}

extension BaseViewController {
    func addObservers() {
        
    }
    
    func handleError(error: ApiError) {
        switch error {
        case .unauthorized:
            self.showPopupGeneral(
                title: error.localizedDescription,
                message: "",
                descBottom: .localized("my_account.call_center"), boldValues: [],
                error: error.localizedDescription)
        case .error(let err):
            self.showPopupGeneral(
                title: err.errorCode,
                message: AppSetting.shared.isBahasa() ? err.idnMessage : err.engMessage,
                boldValues: [])
        case .notFound:
            self.showPopupGeneral(
                title: "0023",
                message: error.localizedDescription,
                descBottom: .localized("my_account.call_center"),
                boldValues: [], error: error.localizedDescription)
        default:
            self.showPopupGeneral(
                title: error.localizedDescription,
                message: "",
                descBottom: .localized("my_account.call_center"),
                boldValues: [])
        }
    }
}

