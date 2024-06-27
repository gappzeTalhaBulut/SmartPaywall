
import UIKit
import Kingfisher

final class CankayaPaywallViewController: BasePaywallController {
    private lazy var titleLabel = UIFactory.makeLabel(model: designModel.title)
    private lazy var listView = UIFactory.makeInfoListView(infoList: designModel.infoList)
    private lazy var switchView = makeSwitchView()
    private lazy var switchTitle = UIFactory.makeLabel(model: designModel.switchTitle)
    private lazy var switchButton = UISwitch()
    private lazy var trialView = makeTrialView()
    private lazy var trialTitle = UIFactory.makeLabel(model: designModel.trialTitle)
    private lazy var trialSubtitle = UIFactory.makeCalculatedLabel(model: designModel.trialSubtitle, priceList: self.priceList)
    private lazy var trialViewStack = UIStackView()
    private lazy var trialTagView = makeTagView()
    private lazy var trialTagText = UIFactory.makeLabel(model: designModel.trialTagText)
    private lazy var trialSelectedImage = makeTrialSelected()
    
    private lazy var purchaseView = makeTrialView()
    private lazy var purchaseViewTitle = UIFactory.makeLabel(model: designModel.purchaseTitle)
    private lazy var purchaseViewSubtitle = UIFactory.makeCalculatedLabel(model: designModel.purchaseSubtitle, priceList: self.priceList)
    private lazy var purchaseViewStack = UIStackView()
    private lazy var purchaseSelectedImage = makePurchaseSelected()
    
    private lazy var cancelInfoLabel = UIFactory.makeLabel(model: designModel.cancelInfo)
    private lazy var purchaseButton = makePurchaseButton()
    private lazy var trialPurchaseButton = makeTrialPurchaseButton()
    
    
    private var designModel: CankayaModel
    
    init(designModel: CankayaModel,
         generalModel: PaywallGeneralModel,
         priceList: PriceList) {
        self.designModel = designModel
        super.init(generalModel: generalModel,
                   priceList: priceList)
        self.setSwitchDefaultsValues()
        self.switchButton.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let animationType = AnimationType(rawValue: designModel.subscribeButtons.first?.animation ?? "")
            if let animationType = animationType {
                AnimationManager.shared.startAnimation(animationType, on: self.purchaseButton)
            }
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func setupUI() {
        super.setupUI()
        view.addSubview(titleLabel)
        view.addSubview(listView)
        view.addSubview(switchView)
        view.addSubview(switchTitle)
        view.addSubview(trialView)
        view.addSubview(trialSelectedImage)
        view.addSubview(purchaseView)
        view.addSubview(purchaseSelectedImage)
        view.addSubview(cancelInfoLabel)
        view.addSubview(purchaseButton)
        view.addSubview(trialPurchaseButton)
        trialTagView.addSubview(trialTagText)
        switchView.addSubview(switchButton)
        purchaseView.addSubview(purchaseViewStack)
        trialView.addSubview(trialViewStack)
        trialView.addSubview(trialTagView)
        trialViewStack.addArrangedSubview(trialTitle)
        trialViewStack.addArrangedSubview(trialSubtitle)
        purchaseViewStack.addArrangedSubview(purchaseViewTitle)
        purchaseViewStack.addArrangedSubview(purchaseViewSubtitle)
        trialViewStack.translatesAutoresizingMaskIntoConstraints = false
        purchaseViewStack.translatesAutoresizingMaskIntoConstraints = false
        purchaseView.translatesAutoresizingMaskIntoConstraints = false
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        trialTagView.translatesAutoresizingMaskIntoConstraints = false
        trialTagText.translatesAutoresizingMaskIntoConstraints = false
        
        trialViewStack.axis = .vertical
        trialViewStack.alignment = .leading
        trialViewStack.spacing = 0
        trialViewStack.distribution = .fill
        purchaseViewStack.axis = .vertical
        purchaseViewStack.alignment = .leading
        purchaseViewStack.spacing = 0
        purchaseViewStack.distribution = .fill
      
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: listView.topAnchor, constant: -30).isActive = true
        
        listView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        listView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        listView.bottomAnchor.constraint(equalTo: switchView.topAnchor, constant: -35).isActive = true
        
        
        switchView.leadingAnchor.constraint(equalTo: purchaseButton.leadingAnchor).isActive = true
        switchView.trailingAnchor.constraint(equalTo: purchaseButton.trailingAnchor).isActive = true
        switchView.bottomAnchor.constraint(equalTo: trialView.topAnchor, constant: -25).isActive = true
        switchView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        switchButton.rightAnchor.constraint(equalTo: switchView.rightAnchor, constant: -20).isActive = true
        switchButton.centerYAnchor.constraint(equalTo: switchView.centerYAnchor).isActive = true
        
        switchTitle.leadingAnchor.constraint(equalTo: switchView.leadingAnchor, constant: 20).isActive = true
        switchTitle.centerYAnchor.constraint(equalTo: switchView.centerYAnchor).isActive = true
        
        trialView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        trialView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        trialView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        trialView.bottomAnchor.constraint(equalTo: purchaseView.topAnchor, constant: -15).isActive = true
        
        trialViewStack.leftAnchor.constraint(equalTo: trialView.leftAnchor, constant: 20).isActive = true
        trialViewStack.topAnchor.constraint(equalTo: trialView.topAnchor, constant: 5).isActive = true
        trialViewStack.bottomAnchor.constraint(equalTo: trialView.bottomAnchor, constant: -10).isActive = true
        trialViewStack.centerYAnchor.constraint(equalTo: trialView.centerYAnchor).isActive = true
        
        
        trialTagView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        trialTagView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        trialTagView.topAnchor.constraint(equalTo: trialView.topAnchor, constant: 10).isActive = true
        trialTagView.leadingAnchor.constraint(equalTo: trialViewStack.trailingAnchor, constant: 14).isActive = true

        
        trialTagText.topAnchor.constraint(equalTo: trialTagView.topAnchor).isActive = true
        trialTagText.bottomAnchor.constraint(equalTo: trialTagView.bottomAnchor).isActive = true
        trialTagText.trailingAnchor.constraint(equalTo: trialTagView.trailingAnchor).isActive = true
        trialTagText.leadingAnchor.constraint(equalTo: trialTagView.leadingAnchor).isActive = true
        
        
        trialSelectedImage.trailingAnchor.constraint(equalTo: trialView.trailingAnchor, constant: -20).isActive = true
        trialSelectedImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        trialSelectedImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        trialSelectedImage.centerYAnchor.constraint(equalTo: trialView.centerYAnchor).isActive = true
        
        purchaseView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        purchaseView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        purchaseView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        purchaseView.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -15).isActive = true
        
        purchaseViewStack.leftAnchor.constraint(equalTo: purchaseView.leftAnchor, constant: 20).isActive = true
        purchaseViewStack.topAnchor.constraint(equalTo: purchaseView.topAnchor, constant: 5).isActive = true
        purchaseViewStack.bottomAnchor.constraint(equalTo: purchaseView.bottomAnchor, constant: -10).isActive = true
        purchaseViewStack.centerYAnchor.constraint(equalTo: purchaseView.centerYAnchor).isActive = true
        
        purchaseSelectedImage.trailingAnchor.constraint(equalTo: purchaseView.trailingAnchor, constant: -20).isActive = true
        purchaseSelectedImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        purchaseSelectedImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        purchaseSelectedImage.centerYAnchor.constraint(equalTo: purchaseView.centerYAnchor).isActive = true
        
        purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        purchaseButton.bottomAnchor.constraint(equalTo: cancelInfoLabel.topAnchor, constant: -15).isActive = true
        purchaseButton.heightAnchor.constraint(equalToConstant: designModel.subscribeButtons.first?.getHeightAnchor() ?? 62).isActive = true
        
        trialPurchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        trialPurchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        trialPurchaseButton.bottomAnchor.constraint(equalTo: cancelInfoLabel.topAnchor, constant: -15).isActive = true
        trialPurchaseButton.heightAnchor.constraint(equalTo: purchaseButton.heightAnchor).isActive = true
        
        cancelInfoLabel.topAnchor.constraint(equalTo: purchaseButton.bottomAnchor, constant: 25).isActive = true
        cancelInfoLabel.centerXAnchor.constraint(equalTo: purchaseButton.centerXAnchor).isActive = true
        cancelInfoLabel.bottomAnchor.constraint(equalTo: restoreLabel.topAnchor, constant: -25).isActive = true
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            self.trialView.backgroundColor = .systemBlue
            self.trialTitle.textColor = .white
            self.trialSubtitle.textColor = .white
            self.trialTagView.backgroundColor = .white
            self.trialTagText.textColor = UIColor(hex: "#007AFF")
            self.purchaseView.backgroundColor = .white
            self.purchaseViewTitle.textColor = .black
            self.purchaseViewSubtitle.textColor = .black
            self.purchaseSelectedImage.isHidden = true
            self.trialTagView.isHidden = false
            self.trialSelectedImage.isHidden = false
            self.trialPurchaseButton.isHidden = false
            self.purchaseButton.isHidden = true
        } else {
            self.trialView.backgroundColor = .white
            self.trialTitle.textColor = .black
            self.trialSubtitle.textColor = .black
            self.trialTagView.backgroundColor = UIColor(hex: "#007AFF")
            self.trialTagText.textColor = .white
            
            self.purchaseView.backgroundColor = .systemBlue
            self.purchaseViewTitle.textColor = .white
            self.purchaseViewSubtitle.textColor = .white
            self.purchaseSelectedImage.isHidden = false
            self.trialTagView.isHidden = false
            self.trialSelectedImage.isHidden = true
            self.trialPurchaseButton.isHidden = true
            self.purchaseButton.isHidden = false
        }
    }
    func setSwitchDefaultsValues() {
        self.switchButton.isOn = false
        self.switchButton.onTintColor = designModel.switchView.getSwitchColor()
        self.switchButton.thumbTintColor = designModel.trialView.getThumbColor()
        self.switchButton.tintColor = designModel.trialView.getSwitchOffColor()
        self.switchButton.backgroundColor = designModel.trialView.getSwitchOffColor()
        self.switchButton.layer.cornerRadius = 16.0
        self.switchButton.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        self.trialView.backgroundColor = .white
        self.trialTitle.textColor = .black
        self.trialSubtitle.textColor = .black
        self.trialTagView.backgroundColor = UIColor(hex: "#007AFF")
        self.trialTagText.textColor = .white
        
        self.purchaseView.backgroundColor = .systemBlue
        self.purchaseViewTitle.textColor = .white
        self.purchaseViewSubtitle.textColor = .white
        self.purchaseSelectedImage.isHidden = false
        self.trialTagView.isHidden = false
        self.trialSelectedImage.isHidden = true
        self.trialPurchaseButton.isHidden = true
        self.purchaseButton.isHidden = false
    }
}

private extension CankayaPaywallViewController {
    func makePurchaseButton() -> UIButton {
        let button = UIFactory.makePurchaseButton(model: designModel.subscribeButtons.first)
        button.addTarget(self, action: #selector(didPurchaseButtonTap), for: .touchUpInside)
        return button
    }
    func makeTrialPurchaseButton() -> UIButton {
        let button = UIFactory.makePurchaseButton(model: designModel.subscribeButtons[1])
        button.addTarget(self, action: #selector(didTrialPurchaseButtonTap), for: .touchUpInside)
        return button
    }
    func makeSwitchView() -> UIView {
        let view = UIFactory.makeUIView(model: designModel.switchView)
        view.layer.borderWidth = 0.5
        return view
    }
    func makeTrialView() -> UIView {
        let view = UIFactory.makeUIView(model: designModel.trialView)
        view.layer.borderWidth  = 0.5
       // view.borderColorV = UIColor.systemGray
        return view
    }
    func makePurchaseView() -> UIView {
        let view = UIFactory.makeUIView(model: designModel.purchaseView)
        view.layer.borderWidth  = 0.5
        //view.borderColorV = UIColor.systemGray
        return view
    }
    func makeTagView() -> UIView {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    func makeTrialSelected() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let url = URL(string: designModel.purchaseSelectedImage) {
            imageView.kf.setImage(with: url)
        }
        return imageView
    }
    func makePurchaseSelected() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let url = URL(string: designModel.purchaseSelectedImage) {
            imageView.kf.setImage(with: url)
        }
        return imageView
    }
}

// MARK: - UI Actions
private extension CankayaPaywallViewController {
    @objc
    func didPurchaseButtonTap() {
            self.onPurchase?(self.designModel.subscribeButtons.first?.productId ?? "")
    }
    @objc
    func didTrialPurchaseButtonTap() {
            self.onPurchase?(self.designModel.subscribeButtons[1].productId)
       
    }
}
