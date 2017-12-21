//
//  ViewController.swift
//  WebTriggerCollection
//
//  Created by Yusuke Ohashi on 2017/12/15.
//  Copyright © 2017 Yusuke Ohashi. All rights reserved.
//

import UIKit
import WebKit
import PassKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: "observe")

        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        self.view.addSubview(webView)

        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingConstant:CGFloat = 0.0;
        webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: paddingConstant).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -paddingConstant).isActive = true
        webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: paddingConstant).isActive = true
        webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -paddingConstant).isActive = true

        let url = URL(string: "http://localhost:5000/")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
}

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        debugPrint(navigationAction.request.url?.absoluteString)
        decisionHandler(.allow)
    }

    func summaryItemsWithShippingCost(shippingCost: NSDecimalNumber) -> [PKPaymentSummaryItem] {
        let wax = PKPaymentSummaryItem(label: "Mustache Wax", amount: 1000)
        let shippingCost = PKPaymentSummaryItem(label: "shipping", amount: shippingCost)
        return [wax, shippingCost]
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (PKPaymentAuthorizationController.canMakePayments()) {
            let request = PKPaymentRequest()
            request.supportedNetworks = [.visa, .masterCard, .idCredit, .amex, .chinaUnionPay, .discover]
            request.merchantIdentifier = "merchant.me.junkpiano.ios.testmarchant"
            request.countryCode = "JP"
            request.currencyCode = "JPY"
            request.shippingType = .shipping
            request.merchantCapabilities = .capability3DS
            request.requiredBillingContactFields = Set<PKContactField>([PKContactField.emailAddress, PKContactField.name, PKContactField.phoneticName])
            request.requiredShippingContactFields = Set<PKContactField>([PKContactField.emailAddress, PKContactField.name, PKContactField.phoneticName])
            
            let shippingContact = PKContact()
            var name = PersonNameComponents()
            var phoneticName = PersonNameComponents()
            phoneticName.givenName = "Yusuke"
            phoneticName.familyName = "Ohashi"
            name.namePrefix = "Mr."
            name.givenName = "Yusuke"
            name.familyName = "Ohashi"
            name.phoneticRepresentation = phoneticName
            shippingContact.name = name
            shippingContact.emailAddress = "test@example.com"
            request.shippingContact = shippingContact
            
            var shippingMethods = [PKShippingMethod]()
            let method = PKShippingMethod()
            method.identifier = "2"
            method.detail = "Arrive in 24h"
            method.label = "Home, Tokyo, Yoga"
            method.amount = 325
            shippingMethods.append(method)
            request.paymentSummaryItems = summaryItemsWithShippingCost(shippingCost: 325)
            let viewController: PKPaymentAuthorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: request)!
            viewController.delegate = self as PKPaymentAuthorizationViewControllerDelegate
            present(viewController, animated: true, completion: {
                
            })
        }
    }
}

extension ViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) {
            
        }
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        controller.dismiss(animated: true) {
            
        }
    }
}
