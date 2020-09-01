//
//  ApplePayController.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 30/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import Foundation
import PassKit
import SwiftUI

// SSNote : Currently not working

struct ApplePayController: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    ////@EnvironmentObject var userData: UserData
    ////@Binding var purchase: Purchase
    @Binding var isPresenting: Bool

    let items: [PKPaymentSummaryItem]

    func updateUIViewController(_ uiViewController: PKPaymentAuthorizationViewController, context: Context) {

    }

    typealias UIViewControllerType = PKPaymentAuthorizationViewController


    func makeUIViewController(context: Context) ->  PKPaymentAuthorizationViewController {
        let applePayManager = ApplePayManager(items: items)
        let apm = applePayManager.paymentViewController()!
        apm.delegate = context.coordinator
        return apm
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PKPaymentAuthorizationViewControllerDelegate  {
        var parent: ApplePayController

        init(_ parent: ApplePayController) {
            self.parent = parent
        }

        func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
            controller.dismiss(animated: true) {
                    self.parent.isPresenting = false
                }
        }

        func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
            print("did authorize payment")

        }

        func paymentAuthorizationViewControllerWillAuthorizePayment(_ controller: PKPaymentAuthorizationViewController) {
            print("Will authorize payment")
        }
    }

    class ApplePayManager: NSObject {
        let currencyCode: String
        let countryCode: String
        let merchantID: String
        let paymentNetworks: [PKPaymentNetwork]
        let items: [PKPaymentSummaryItem]

        init(items: [PKPaymentSummaryItem],
               currencyCode: String = "USD",
               countryCode: String = "US",
               merchantID: String = Configuration.Merchant.identifier,
               paymentNetworks: [PKPaymentNetwork] = [PKPaymentNetwork.amex, PKPaymentNetwork.masterCard, PKPaymentNetwork.visa]
        ) {
            self.items = items
            self.currencyCode = currencyCode
            self.countryCode = countryCode
            self.merchantID = merchantID
            self.paymentNetworks = paymentNetworks
        }

        func paymentViewController() -> PKPaymentAuthorizationViewController? {
            if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
                let request = PKPaymentRequest()
                request.currencyCode = self.currencyCode
                request.countryCode = self.countryCode
                request.supportedNetworks = paymentNetworks
                request.merchantIdentifier = self.merchantID
                request.paymentSummaryItems = items
                request.merchantCapabilities = [.capabilityCredit, .capabilityDebit]
                return PKPaymentAuthorizationViewController(paymentRequest: request)
            }
            return nil
        }
    }
}
