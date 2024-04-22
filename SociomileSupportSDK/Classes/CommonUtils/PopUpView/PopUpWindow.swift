import UIKit
import RxCocoa
import RxSwift

protocol SuccessEmailConfirmationDelegate {
    func successConfirmationPopUp()
    func refreshEmailVerification(popupWindow: PopUpWindow)
}

class PopUpWindow: UIViewController {
    private var content = PopUpView()
    
    private var _imageName: String?
    private var _title: String?
    private var _desc: String?
    private var _code: String?
    private var _descBottom: String?
    private var _primaryButtonTitle: String?
    private var _secondaryButtonTitle: String?
    private var _primaryButtonTapped: (() -> Void)?
    private var _secondaryButtonTapped: (() -> Void)?
    private var _copyButtonTapped: (() -> Void)?
    private var _isCtaHorizontal: Bool = false
    private var _boldValues: [String] = []
    private var _isEmailVerification: Bool = false
    private var _isDismissable: Bool = true
    
    private let viewController: UIViewController?
    private let contentHeight: CGFloat?
    lazy var copyContainer = Copy(on: self.view)
    private let disposeBag = DisposeBag()
    
    var successConfirmationDelegate: SuccessEmailConfirmationDelegate?
    public var testClosure: ((UITableView) -> Void)?
    var dataPopupVerifyEmail = BehaviorRelay<[String]>(value: [])
//    var dataStatusVerifyEmail = BehaviorRelay<[RegistrationEmailStatus]>(value: [])
    
    convenience init(
        imageName: String,
        title: String? = nil,
        desc: String,
        descBottom: String? = nil,
        code: String? = nil,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil,
        primaryButtonTapped: (() -> Void)? = nil,
        secondaryButtonTapped: (() -> Void)? = nil,
        copyButtonTapped: (() -> Void)? = nil,
        isCtaHorizontal: Bool = false,
        boldValues: [String] = [],
        isEmailVerification: Bool = false,
        isDismissable: Bool = true
    ) {
        self.init(viewController: nil)
        
        _imageName = imageName
        _title = title
        _desc = desc
        _code = code
        _descBottom = descBottom
        _primaryButtonTitle = primaryButtonTitle
        _secondaryButtonTitle = secondaryButtonTitle
        _primaryButtonTapped = primaryButtonTapped
        _secondaryButtonTapped = secondaryButtonTapped
        _copyButtonTapped = copyButtonTapped
        _isCtaHorizontal = isCtaHorizontal
        _boldValues = boldValues
        _isEmailVerification = isEmailVerification
        _isDismissable = isDismissable
        
    }
    
    init(viewController: UIViewController?, contentHeight: CGFloat? = nil) {
        self.viewController = viewController
        self.contentHeight = contentHeight
        
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        if let viewController = viewController {
            let container = UIView()
            container.backgroundColor = .white
            container.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 40, height: contentHeight ?? viewController.view.bounds.height)
            container.center = view.center
            
            viewController.view.frame = container.bounds
            viewController.view.clipsToBounds = true
            container.addSubview(viewController.view)
            
            container.layer.cornerRadius = 20
            viewController.view.layer.cornerRadius = 20
            view.addSubview(container)
            viewController.didMove(toParent: self)
            
            let bgTap = UITapGestureRecognizer()
            bgTap.cancelsTouchesInView = true
            view.addGestureRecognizer(bgTap)
            bgTap.rx.event
                .asDriver()
                .drive(onNext: { [weak self] _ in
                    self?.dismiss(animated: true, completion: nil)
                })
                .disposed(by: disposeBag)
        } else {
            if _isEmailVerification {
//                self.setupPopupVerifyEmail(data: self.dataPopupVerifyEmail.value, dataStatus: self.dataStatusVerifyEmail.value)
                
            } else {
                content = Bundle.main.loadNibNamed("PopUpView", owner: nil, options: nil)?.first as! PopUpView
                view.addSubview(content)
                view = content
                content.setup(imageName: _imageName ?? "",
                              title: _title,
                              desc: _desc ?? "",
                              code: _code,
                              descBottom: _descBottom ?? "",
                              primaryButtonTitle: _primaryButtonTitle ?? "",
                              secondaryButtonTitle: _secondaryButtonTitle ?? "",
                              isCtaHorizontal: _isCtaHorizontal,
                              boldValues: _boldValues,
                              isDismissable: _isDismissable)
                content.delegate = self
            }
        }
        view.backgroundColor = UIColor(hexaRGB: "#374062", alpha: 0.4)
    }
    
//    func setupPopupVerifyEmail(data: [String], dataStatus: [RegistrationEmailStatus]) {
//        var content = PopUpVerifyEmail()
//        let container = UIView()
//        container.backgroundColor = .white
//        container.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 40, height: 486)
//        container.center = view.center
//
//        content = Bundle.main.loadNibNamed("PopUpVerifyEmail", owner: nil, options: nil)?.first as! PopUpVerifyEmail
//        content.frame = container.bounds
//        content.clipsToBounds = true
//        content.layer.cornerRadius = 20
//        self.dataPopupVerifyEmail.asObservable().subscribe(onNext: { data in
//            content.dataEmail = data
//            DispatchQueue.main.async {
//                content.emailTableView.reloadData()
//            }
//        }).disposed(by: disposeBag)
//        self.dataStatusVerifyEmail.asObservable().subscribe(onNext: { data in
//            content.dataStatusVerif = data
//            DispatchQueue.main.async {
//                content.emailTableView.reloadData()
//            }
//        }).disposed(by: disposeBag)
//        container.addSubview(content)
//
//        container.layer.cornerRadius = 20
//        self.viewController?.view.layer.cornerRadius = 20
//
//        view.addSubview(container)
//
////        let bgTap = UITapGestureRecognizer()
////        bgTap.cancelsTouchesInView = true
////        view.addGestureRecognizer(bgTap)
////        bgTap.rx.event
////            .asDriver()
////            .drive(onNext: { [weak self] _ in
////                self?.dismiss(animated: true, completion: nil)
////            })
////            .disposed(by: disposeBag)
//
//        content.verifikasiButton.rx.tap
//            .asDriver()
//            .drive(onNext: { [weak self] _ in
//                guard let self = self else { return }
//                if !self.dataStatusVerifyEmail.value.contains(.inProgress) && !self.dataStatusVerifyEmail.value.contains(.failed) {
//                    self.dismiss(animated: true, completion: nil)
//                    self.successConfirmationDelegate?.successConfirmationPopUp()
//                }
//            })
//            .disposed(by: disposeBag)
//        
//        content.refreshButton.rx.tapGesture()
//            .when(.recognized)
//            .subscribe(onNext: { [weak self] _ in
//                guard let self = self else { return }
//                self.successConfirmationDelegate?.refreshEmailVerification(popupWindow: self)
//            })
//            .disposed(by: disposeBag)
//    }
}
extension PopUpWindow: PopUpViewDelegate {
    func primaryButtonTapped() {
        self.dismiss(animated: true, completion: { [weak self] in
            self?._primaryButtonTapped?()
        })
    }
    
    func secondaryButtonTapped() {
        self.dismiss(animated: true, completion: { [weak self] in
            self?._secondaryButtonTapped?()
        })
    }
    
    func backgroundViewTapped() {
        if _isDismissable{ self.dismiss(animated: true, completion: nil) }
    }
    
    func copyButtonTapped() {
        if let value = _code {
            UIPasteboard.general.string = value
            copyContainer.show()
        }
    }
}
