//
//  SubscriptionOffer.swift
//  Diet
//
//  Created by Даниил on 13/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import Purchases
import SafariServices
import AppsFlyerLib

class SubscriptionOfferView: UIViewController {
    
    static func storyboardInstance() -> UIViewController? {
        let storyboard = UIStoryboard(name: "\(self)", bundle: nil)
        let subscriptionOfferView = storyboard.instantiateInitialViewController() as? SubscriptionOfferView
        return subscriptionOfferView
    }
    
    @IBOutlet weak var arcView: UIView!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var offset: NSLayoutConstraint!
    @IBOutlet weak var offsetFromTop: NSLayoutConstraint!
    @IBOutlet weak var trialTermsLabel: UILabel!
    @IBOutlet weak var termsAndServiceButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    @IBOutlet weak var logo: UIView!
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var popularPlanPriceLabel: UILabel!
    @IBOutlet weak var pupularPlanButton: UIButton!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var popularPlanContainerView: UIView!
    fileprivate let trialExpiredMessage = "Your trial period has expired.".localized
    fileprivate let trialAvailableMessage = "Free period available".localized
    fileprivate let disclaimerMessage = "Payment will be charged to your iTunes Account at confirmation of purchase. Subscriptions will automatically renew unless canceled within 24-hours before the end of the current period. Subscription auto-renewal may be turned off by going to the Account Settings after purchase. Any unused portion of a free trial will be forfeited when you purchase a subscription.".localized
    fileprivate let perText = "/week after 3 days".localized
    fileprivate var cheapPlan: SKProduct!
    fileprivate var popularPlan: SKProduct!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        let loadingVc = LoadingViewController()
        add(loadingVc)
        Purchases.shared.delegate = self
        headline.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Demi Bold", size: 0), size: ((self.view.frame.height + self.view.frame.width) / 2) / 25)
        
        logo.frame = CGRect(x: (view.frame.width / 2) - (view.frame.width / 5) / 2,
                            y: logo.frame.minY,
                            width: view.frame.width / 5,
                            height: view.frame.height / 5)

        SwiftyStoreKit.retrieveProductsInfo([ProductId.popular.rawValue, ProductId.cheap.rawValue]) { result in
            loadingVc.remove()
            if let popPlan = result.retrievedProducts.filter({ product in product.productIdentifier == ProductId.popular.rawValue }).first{
                self.popularPlan = popPlan
                    
                    self.popularPlanPriceLabel.text = self.popularPlan.localizedPrice! + self.perText
                self.popularPlanPriceLabel.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Regular", size: 0), size: ((self.view.frame.height + self.view.frame.width) / 2) / 40)
                
                let priceString = self.popularPlan.localizedPrice!
                print("Product: \(self.popularPlan.localizedDescription), price: \(priceString)")
                if let invalidProductId = result.invalidProductIDs.first {
                    print("Invalid product identifier: \(invalidProductId)")
                }
                else {
                    print("Error: \(String(describing: result.error))")
                }
                
                self.cheapPlan = result.retrievedProducts.filter({ product in product.productIdentifier == ProductId.cheap.rawValue }).first
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let path = UIBezierPath(arcCenter: CGPoint(x: arcView.frame.width / 2, y: 37), radius: 39, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)
        
        arcView.layer.masksToBounds = false
        arcView.layer.shadowColor = UIColor.lightGray.cgColor
        arcView.layer.shadowOffset = CGSize(width: 1, height: 1)
        arcView.layer.shadowOpacity = 0.5
        arcView.layer.shadowRadius = 16
        arcView.layer.shadowPath = path.cgPath
        cardView.dropShadow(opacity: 0.3, offSet: CGSize(width: 1, height: 1), radius: 16)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDiets" {
            if let destinationVc = segue.destination as? DietView {
                destinationVc.accessStatus = .available
            }
        }
    }
    
    private func setupView() {
        
        arcView.makeCornerRadius(arcView.frame.height / 2)
        restoreButton.makeCornerRadius(5)
        purchaseButton.makeCornerRadius(5)
        skipButton.makeCornerRadius(5)
        termsAndServiceButton.makeCornerRadius(5)
        privacyPolicyButton.makeCornerRadius(5)
        cardView.makeCornerRadius(5)
        popularPlanContainerView.makeCornerRadius(5)
        popularPlanContainerView.layer.borderWidth = 1
        popularPlanContainerView.layer.borderColor = UIColor(red: 0, green: 234 / 255, blue: 134 / 255, alpha: 1).cgColor
    }
    
    private func showErrorAlert(for error: SubscriptionServiceError) {
        let title: String
        let message: String
        
        switch error {
        case .missingAccountSecret, .invalidSession, .internalError:
            title = "Internal error".localized
            message = "Please try again.".localized
        case .noActiveSubscription:
            title = "No Active Subscription".localized
            message = "Please verify that you have an active subscription".localized
        case .other(let otherError):
            title = "Unexpected Error".localized
            message = otherError.localizedDescription
        case .wrongEnviroment: return
        case .purchaseFailed:
            title = "Purchase failed".localized
            message = "Purchase transaction failed. Try again".localized
        case .restoreFailed:
            title = "Error".localized
            message = "Could not restore purchases".localized
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let backAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(backAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func purchaseButtonPressed(_ sender: Any) {
        
        if pupularPlanButton.isSelected {
           makePurhase(productId: ProductId.popular.rawValue)
        } else {
            makePurhase(productId: ProductId.cheap.rawValue)
        }
    }
    
    fileprivate func makePurhase(productId: String) {
        
        let loadingVc = LoadingViewController()
        add(loadingVc)

        SwiftyStoreKit.purchaseProduct(productId, atomically: true) { result in
            loadingVc.remove()
            
            if case .success(let purchase) = result {
                
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                
                let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "41b8fe92dbd9448ab3e06f3507b01371")
                SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
                    
                    if case .success(let receipt) = result {
                        
                        let purchaseResult = SwiftyStoreKit.verifySubscription(
                            ofType: .autoRenewable,
                            productId: productId,
                            inReceipt: receipt)
                        
                        switch purchaseResult {
                        case .purchased(let expiryDate, let receiptItems):
                            
                            let isTrialPeriod = receiptItems.filter { $0.isTrialPeriod == false }.count == 0
                            if isTrialPeriod == true {
                                
                                EventManager.sendEvent(with: AFEventStartTrial)
                            }
                            
                            print("Product is valid until \(expiryDate)")
                            
                            if let nextViewController = DietView.storyboardInstance(){
                                
                                self.present(nextViewController, animated: true, completion: nil)
                            }
                        case .expired(let expiryDate):
                            print("Product is expired since \(expiryDate)")
                        case .notPurchased:
                            print("This product has never been purchased")
                        }
                    } else {
                        self.showErrorAlert(for: .internalError)
                    }
                }
            } else {
                // non success
            }
        }
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        //EventManager.sendCustomEvent(with: "Subscription offer was skiped")
        performSegue(withIdentifier: "showTestResult", sender: self)
    }
    
    @IBAction func restoreButtonPressed(_ sender: Any) {
        
        //EventManager.sendCustomEvent(with: "User tried to restore subscription")
        let loadingVc = LoadingViewController()
        add(loadingVc)
        
        Purchases.shared.restoreTransactions { (purchaserInfo, error) in
            
            loadingVc.remove()
            if let e = error {
                print("RESTORE ERROR: - \(e.localizedDescription)")
                self.showErrorAlert(for: .restoreFailed)
            } else if purchaserInfo?.activeSubscriptions.contains(ProductId.popular.rawValue) ?? false ||
                purchaserInfo?.activeSubscriptions.contains(ProductId.cheap.rawValue) ?? false {
                
                if let nextViewController = DietView.storyboardInstance(){
                    self.present(nextViewController, animated: true, completion: nil)
                }
            } else {
                self.showErrorAlert(for: .noActiveSubscription)
            }
        }
    }
    
    @IBAction func termsAndServiceButtonPressed(_ sender: Any) {
        guard let url = URL(string: "https://sfbtech.org/terms") else { return }
        let webView = SFSafariViewController(url: url)
        present(webView, animated: true, completion: nil)
    }
    
    @IBAction func privacyPolicyButtonPressed(_ sender: Any) {
        guard let url = URL(string: "https://sfbtech.org/policy") else { return }
        let webView = SFSafariViewController(url: url)
        present(webView, animated: true, completion: nil)
    }
}

extension SubscriptionOfferView: PurchasesDelegate {
    
    func purchases(_ purchases: Purchases, didReceiveUpdated purchaserInfo: PurchaserInfo) {
        
    }
}