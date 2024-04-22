import UIKit

protocol PopUpViewDelegate: AnyObject {
    func primaryButtonTapped()
    func secondaryButtonTapped()
    func backgroundViewTapped()
    func copyButtonTapped()
}

class PopUpView: UIView {
    @IBOutlet weak private var illustImageView: UIImageView!
    @IBOutlet weak private var primaryButton: BaseButton!
    @IBOutlet weak private var secondaryButton: BaseButton!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    
    @IBOutlet weak var contactLabel: UILabel!
    
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var backgroundView: UIView!
    @IBOutlet weak private var titleHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ctaHorizontalView: UIView!
    @IBOutlet weak var secondaryButtonHorizontal: BaseButton!
    @IBOutlet weak var primaryButtonHorizontal: BaseButton!
    @IBOutlet weak var codeViewContainer: UIView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    
    var delegate: PopUpViewDelegate?
    
    var primaryButtonTitle: String = "" {
        didSet {
            primaryButton.setTitle(primaryButtonTitle, for: .normal)
        }
    }
    
    var secondaryButtonTitle: String = "" {
        didSet {
            secondaryButton.setTitle(secondaryButtonTitle, for: .normal)
        }
    }
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var desc: String = "" {
        didSet {
            descriptionLabel.font = UIFont(name: "Futura Bk BT", size: 13)
            descriptionLabel.text = desc
        }
    }
    
    var contactCenter: String = "" {
        didSet {
            contactLabel.font = UIFont(name: "Futura Bk BT", size: 13)
            contactLabel.text = contactCenter
        }
    }
    
    var code: String = "" {
        didSet {
            codeLabel.text = code
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup(
            imageName: "illustration-offline",
            title: "Title",
            desc: "Desc",
            code: "123456",
            descBottom: "",
            primaryButtonTitle: "Ok",
            secondaryButtonTitle: "Lewati"
        )
    }
    
    func setup(
        imageName: String,
        title: String? = nil,
        desc: String,
        code: String? = nil,
        descBottom: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil,
        isCtaHorizontal: Bool = false,
        boldValues: [String] = [],
        isDismissable: Bool = true
    ) {
        containerView.layer.cornerRadius = 20
        
        if let image = UIImage(named: imageName) {
            illustImageView.image = image
        }
        
        if let safeTitle = title {
            titleLabel.text = safeTitle
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
            titleHeightConstraint.constant = 0
        }
        
        if let challangeCode = code {
            codeLabel.text = challangeCode
//            codeLabel.addCharacterSpacing()
            codeViewContainer.isHidden = false
            codeLabel.isHidden = false
            self.copyButton.isHidden = false
        } else {
            codeViewContainer.isHidden = true
            codeLabel.isHidden = true
            copyButton.isHidden = true
        }
        
        let font = UIFont.systemFont(ofSize: 13, weight: .regular)
        let boldFont = UIFont.systemFont(ofSize: 13, weight: .bold)
        descriptionLabel.attributedText = desc.withBoldText(
            boldPartsOfString: boldValues, font: font, boldFont: boldFont)
        
        contactLabel.attributedText = descBottom.withBoldText(
            boldPartsOfString: boldValues, font: font, boldFont: boldFont)

        primaryButton.setup(type: .fill(), title: primaryButtonTitle)
        primaryButtonHorizontal.setup(type: .fill(), title: primaryButtonTitle)
        
        if let btnTitle = secondaryButtonTitle {
            if btnTitle.isNotEmpty {
                secondaryButton.setup(type: .border(), title: btnTitle)
                secondaryButtonHorizontal.setup(type: .border(), title: btnTitle)
                secondaryButton.isHidden = false
                secondaryButtonHorizontal.isHidden = false
            } else {
                secondaryButton.isHidden = true
                secondaryButtonHorizontal.isHidden = true
            }
            
        } else {
            secondaryButton.isHidden = true
            secondaryButtonHorizontal.isHidden = true
        }
        
        if isCtaHorizontal {
            ctaHorizontalView.isHidden = false
            primaryButton.isHidden = true
            secondaryButton.isHidden = true
        } else {
            ctaHorizontalView.isHidden = true
            primaryButton.isHidden = false
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped))
        backgroundView.addGestureRecognizer(tap)
        backgroundView.isUserInteractionEnabled = true
        
    }
    
    @objc private func backgroundViewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.backgroundViewTapped()
    }
    
    @IBAction func primaryButtonTapped(_ sender: BaseButton) {
        delegate?.primaryButtonTapped()
    }
    
    @IBAction func secondaryButtonTapped(_ sender: BaseButton) {
        delegate?.secondaryButtonTapped()
    }
    
    @IBAction func copyButtonTapped(_ sender: Any) {
        delegate?.copyButtonTapped()
    }
}
