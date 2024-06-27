//
//  IstanbulPaywallViewController.swift
//  BluetoothScanner
//
//  Created by Talha on 31.01.2024.
//

import UIKit

final class IstanbulPaywallViewController: BasePaywallController {
    private lazy var titleLabel = UIFactory.makeLabel(model: designModel.title)
    private lazy var trialInfoLabel = UIFactory.makeLabel(model: designModel.trialInfo)
    private lazy var priceInfoLabel = UIFactory.makeCalculatedLabel(model: designModel.priceInfo,
                                                               priceList: self.priceList)
    private lazy var purchaseButton = makePurchaseButton()
    private lazy var cancelInfoLabel = UIFactory.makeLabel(model: designModel.cancelInfo)
    
    private lazy var listTableView: UITableView = {
       let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor(hex: designModel.viewColor).withAlphaComponent(0.8)
        table.separatorStyle = .none
        table.layer.cornerRadius = 13
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let designModel: IstanbulModel
    
    init(designModel: IstanbulModel,
         generalModel: PaywallGeneralModel,
         priceList: PriceList) {
        self.designModel = designModel
        super.init(generalModel: generalModel,
                   priceList: priceList)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let animationType = AnimationType(rawValue: designModel.subscribeButtons.first?.animation ?? "")
            if let animationType = animationType {
                AnimationManager.shared.startAnimation(animationType, on: self.purchaseButton)
            }
        }
        self.listTableView.register(HorizontalListCell.self)
       
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(titleLabel)
        view.addSubview(listTableView)
        view.addSubview(trialInfoLabel)
        view.addSubview(priceInfoLabel)
        view.addSubview(purchaseButton)
        view.addSubview(cancelInfoLabel)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: listTableView.bounds.width, height: 30))
        listTableView.tableHeaderView = headerView

        titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 50).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true

        listTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //listTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        listTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 45).isActive = true
        listTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90).isActive = true
        listTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.29).isActive = true
        
        trialInfoLabel.leadingAnchor.constraint(equalTo: priceInfoLabel.leadingAnchor).isActive = true
        trialInfoLabel.trailingAnchor.constraint(equalTo: priceInfoLabel.trailingAnchor).isActive = true
        trialInfoLabel.bottomAnchor.constraint(equalTo: priceInfoLabel.topAnchor, constant: -10).isActive = true

        priceInfoLabel.leadingAnchor.constraint(equalTo: purchaseButton.leadingAnchor).isActive = true
        priceInfoLabel.trailingAnchor.constraint(equalTo: purchaseButton.trailingAnchor).isActive = true
        priceInfoLabel.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -10).isActive = true

        
        purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        purchaseButton.heightAnchor.constraint(equalToConstant: designModel.subscribeButtons.first?.getHeightAnchor() ?? 62).isActive = true

        cancelInfoLabel.topAnchor.constraint(equalTo: purchaseButton.bottomAnchor, constant: 25).isActive = true
        cancelInfoLabel.centerXAnchor.constraint(equalTo: purchaseButton.centerXAnchor).isActive = true
        cancelInfoLabel.bottomAnchor.constraint(equalTo: restoreLabel.topAnchor, constant: -25).isActive = true
    }
}

private extension IstanbulPaywallViewController {
    func makePurchaseButton() -> UIButton {
        let button = UIFactory.makePurchaseButton(model: designModel.subscribeButtons.first)
        button.addTarget(self, action: #selector(didPurchaseButtonTap), for: .touchUpInside)
        return button
    }
}

// MARK: - UI Actions
private extension IstanbulPaywallViewController {
    @objc
    func didPurchaseButtonTap() {
        self.onPurchase?(designModel.subscribeButtons.first?.productId ?? "")
    }
}
extension IstanbulPaywallViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: HorizontalListCell.self, for: indexPath)
        let items = self.designModel.infoList[indexPath.item]
        cell.setup(at: items)
        cell.backgroundColor = .clear
        cell.containerView.backgroundColor = .clear
       // cell.containerView.backgroundColor = UIColor(hex: designModel.viewColor).withAlphaComponent(0.8)
        if indexPath.row == 0 {
            cell.freeText.isHidden = false
            cell.proText.isHidden = false
        } else {
            cell.freeText.isHidden = true
            cell.proText.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.designModel.infoList.count
    }
}
