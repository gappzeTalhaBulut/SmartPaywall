//
//  BasePaywallController.swift
//  BluetoothScanner
//
//  Created by Talip on 19.06.2023.
//

import UIKit
import Kingfisher

typealias PriceList = [String: (localizedPrice: String?,currencySymbol: String?)]

class BasePaywallController: UIViewController, PaywallControllerProtocol, CloseButtonProtocol {
    var onOpen: (() -> ())?
    var onClose: (() -> ())?
    var onPurchase: ((String) -> ())?
    var onRestore: (() -> ())?
    
    lazy var closeButton = makeCloseButton()
    private lazy var termOfUseLabel = UIFactory.makeTermOfUseLabel(with: self.generalModel)
    lazy var restoreLabel = makeRestoreLabel()
    private lazy var privacyPolicyLabel = UIFactory.makePrivacyPolicyLabel(with: self.generalModel)
    
    private let generalModel: PaywallGeneralModel
    private let videoPlayer: VideoPlayer
    
    let priceList: PriceList
    
    init(generalModel: PaywallGeneralModel,
         videoPlayer: VideoPlayer = .init(),
         priceList: PriceList) {
        self.generalModel = generalModel
        self.videoPlayer = videoPlayer
        self.priceList = priceList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onOpen?()
        applyCloseButtonLogic(isVisible: generalModel.closebutton.isVisible,
                              delay: generalModel.closebutton.delay)
    }
    
    func closePaywall(didClose: @escaping () -> ()) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: didClose)
        }
    }
    
    func setupUI() {
        setupBackgroundType()
    
        view.addSubview(closeButton)
        view.addSubview(termOfUseLabel)
        view.addSubview(restoreLabel)
        view.addSubview(privacyPolicyLabel)
        
        switch generalModel.closebutton.position {
        case .topLeft:
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        case .topRight:
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        }
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        restoreLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        restoreLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        
        termOfUseLabel.trailingAnchor.constraint(equalTo: restoreLabel.leadingAnchor, constant: -30).isActive = true
        termOfUseLabel.centerYAnchor.constraint(equalTo: restoreLabel.centerYAnchor).isActive = true
        
        privacyPolicyLabel.leadingAnchor.constraint(equalTo: restoreLabel.trailingAnchor, constant: 30).isActive = true
        privacyPolicyLabel.centerYAnchor.constraint(equalTo: restoreLabel.centerYAnchor).isActive = true
    }
    
    func setupBackgroundType() {
        switch generalModel.background.type {
        case .video:
            if let url = URL(string: generalModel.background.getCalculatedUrl()) {
                videoPlayer.playVideo(from: url, in: self.view, isLoopingEnabled: generalModel.background.content?.isLoopEnabled ?? false)
            }
        case .image:
            if let url = URL(string: generalModel.background.getCalculatedUrl()) {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.kf.setImage(with: url)
                view.addSubview(imageView)
                
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
                imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            }
        case .color:
            view.backgroundColor = UIColor(hex: generalModel.background.backgroundColor)
        }
    }
}

private extension BasePaywallController {
    func makeRestoreLabel() -> AttributedLabel {
        let label = AttributedLabel { [weak self] in
            self?.onRestore?()
        }
        label.set(text: generalModel.restore.text, attributeList: generalModel.restore.attributes)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeCloseButton() -> UIButton {
        let button = UIButton()
        if let url = URL(string: generalModel.closebutton.image) {
            button.kf.setImage(with: url, for: .normal)
        }
        button.isHidden = true
        button.addTarget(self, action: #selector(didCloseButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    @objc
    func didCloseButtonTap() {
        self.dismiss(animated: true) { [weak self] in
            self?.onClose?()
        }
    }
    
}
