/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A shared class for handling payment across an app and its related extensions
*/

import UIKit
import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void

class PaymentHandler: NSObject {

    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler?

    static let supportedNetworks: [PKPaymentNetwork] = [
        .amex,
        .discover,
        .masterCard,
        .visa
    ]

    class func applePayStatus() -> (canMakePayments: Bool, canSetupCards: Bool) {
        return (PKPaymentAuthorizationController.canMakePayments(),
                PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks))
    }
    
    func startPayment(paymentSummaryItems:[PKPaymentSummaryItem], completion: @escaping PaymentCompletionHandler) {

        completionHandler = completion
        
        self.paymentSummaryItems = paymentSummaryItems
        /*
        let amount = PKPaymentSummaryItem(label: "Amount", amount: NSDecimalNumber(string: "8.88"), type: .final)
        let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: "1.12"), type: .final)
        let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: "10.00"), type: .pending)
        paymentSummaryItems = [amount, tax, total]
        */
        
        // Create our payment request
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = Configuration.Merchant.identifier
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        //paymentRequest.requiredShippingContactFields = [.postalAddress, .phoneNumber]
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks
        
        // Display our payment request
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        paymentController?.present(completion: { (presented: Bool) in
            if presented {
                debugPrint("Presented payment controller")
            } else {
                debugPrint("Failed to present payment controller")
                self.completionHandler!(false)
            }
        })
    }
}

/*
    PKPaymentAuthorizationControllerDelegate conformance.
 */
extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        // Perform some very basic validation on the provided contact information
        var errors = [Error]()
        var status = PKPaymentAuthorizationStatus.success
        if payment.shippingContact?.postalAddress?.isoCountryCode != "US" {
            let pickupError = PKPaymentRequest.paymentShippingAddressUnserviceableError(withLocalizedDescription: "Sample App only delivers in the United States")
            let countryError = PKPaymentRequest.paymentShippingAddressInvalidError(withKey: CNPostalAddressCountryKey, localizedDescription: "Invalid country")
            errors.append(pickupError)
            errors.append(countryError)
            status = .failure
        } else {
            // Here you would send the payment token to your server or payment provider to process
            // Once processed, return an appropriate status in the completion handler (success, failure, etc)
        }
        
        self.paymentStatus = status
        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            // We are responsible for dismissing the payment sheet once it has finished
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    self.completionHandler!(true)
                } else {
                    self.completionHandler!(false)
                }
            }
        }
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didSelectPaymentMethod paymentMethod: PKPaymentMethod, handler completion: @escaping (PKPaymentRequestPaymentMethodUpdate) -> Void) {
        // The didSelectPaymentMethod delegate method allows you to make changes when the user updates their payment card
        // Here we're applying a $2 discount when a debit card is selected
        guard paymentMethod.type == .debit else {
            completion(PKPaymentRequestPaymentMethodUpdate(paymentSummaryItems: paymentSummaryItems))
            return
        }

        var discountedSummaryItems = paymentSummaryItems
        let discount = PKPaymentSummaryItem(label: "Debit Card Discount", amount: NSDecimalNumber(string: "-2.00"))
        discountedSummaryItems.insert(discount, at: paymentSummaryItems.count - 1)
        if let total = paymentSummaryItems.last {
            total.amount = total.amount.subtracting(NSDecimalNumber(string: "2.00"))
        }
        completion(PKPaymentRequestPaymentMethodUpdate(paymentSummaryItems: discountedSummaryItems))
    }
    
}
