//
//  ViewLandmarkSwiftUIView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 01/09/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI
import PassKit

struct ViewLandmarkSwiftUIView: View {
    @Binding var loadLandmarkView:Bool
    var landmarkOptional: Landmark?

    let paymentHandler = PaymentHandler()

    var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
            Group {
                PaymentButton(action: orderItem)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
        }
        .background(VisualEffectBlur().edgesIgnoringSafeArea(.all))
    }

    var body: some View {
        VStack {
            ZStack {
                
                landmarkOptional?.image
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: 250, idealHeight: 250, maxHeight: 250, alignment: .top)
                    .cornerRadius(20)
                
                Text(landmarkOptional?.name ?? "")
                    .foregroundColor(CommonUtils.cu_activity_background_color)
                    .shadow(radius: 1.5)
                    .frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: 250, idealHeight: 250, maxHeight: 250, alignment: .top)
            }

            self.bottomBar
                //.frame(alignment: .bottom)
            
        }

    }
    
    func orderItem() {
        if let landmark = self.landmarkOptional {
            var paymentSummaryItems = [PKPaymentSummaryItem]()
            let amount = PKPaymentSummaryItem(label: "Amount", amount: NSDecimalNumber(string: landmark.Amount), type: .final)
            let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: landmark.Tax), type: .final)
            let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: landmark.Total), type: .pending)
            paymentSummaryItems = [amount, tax, total]
            
            self.paymentHandler.startPayment(paymentSummaryItems: paymentSummaryItems)  { (success) in
                if success {
                    print("Apple Pay Success for \(landmark.name)")
                } else {
                    print("Apple Pay Failed for \(landmark.name)")
                }
            }
        } else {
            print("Could not find proper item to purchase by Apple Pay")
        }
    }
    
}

struct ViewLandmarkSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ViewLandmarkSwiftUIView(loadLandmarkView: .constant(true), landmarkOptional: landmarkData[0])
    }
}
