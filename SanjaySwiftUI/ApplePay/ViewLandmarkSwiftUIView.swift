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
    @Binding var currentLandmarkId:Int
    //var landmarkOptional: Landmark?

    let paymentHandler = PaymentHandler()

    var filteredLandMark:Landmark? {
        return landmarkData.filter( { $0.id == self.currentLandmarkId } ).first
    }
    
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
        ScrollView {
            
            Text(filteredLandMark?.category.rawValue ?? "")
                .foregroundColor(CommonUtils.cu_activity_light_text_color)
                .shadow(radius: 1.5)
            
            ZStack {
                filteredLandMark?.image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: 250, idealHeight: 250, maxHeight: 250, alignment: .top)
                
                Text(filteredLandMark?.name ?? "")
                    .foregroundColor(CommonUtils.cu_activity_background_color)
                    .shadow(radius: 1.5)
                    .frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: 250, idealHeight: 250, maxHeight: 250, alignment: .top)
                
                // bought text
                if ( filteredLandMark?.bought ?? false ) == true {
                    Text("bought")
                        .shadow(radius: 1.5)
                        .padding(5)
                        .background(CommonUtils.cu_activity_light_theam_color)
                        .cornerRadius(5)
                        .frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: 250, idealHeight: 250, maxHeight: 250, alignment: .bottom)
                        .opacity(0.5)
                } else {
                    Text("")
                }
                
            }
            
            self.bottomBar
            //.frame(alignment: .bottom)
            
            Button(action: { self.loadLandmarkView = false } ) {
                Text("Close")
            }
            .padding(5)
            .background(CommonUtils.cu_activity_light_theam_color)
            .cornerRadius(10)
            
            SSWebView(htmlText: filteredLandMark?.htmlDescription ?? "" )
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 500, maxHeight: .infinity, alignment: .center)
                .padding()
        }
        
    }
    
    func orderItem() {
        var landmark:Landmark
        if let lm = self.filteredLandMark {
            landmark = lm
            
            // category
            // email - .ebook  - [.email]
            // default - [.postalAddress, .phoneNumber] 
            var requiredShippingContactFields:Set<PKContactField> = []
            switch landmark.category {
                case .ebook :    
                    requiredShippingContactFields = [.emailAddress]
                default :    
                    requiredShippingContactFields = [.postalAddress, .phoneNumber]
            }
                          
            var paymentSummaryItems = [PKPaymentSummaryItem]()
            let amount = PKPaymentSummaryItem(label: "Amount", amount: NSDecimalNumber(string: landmark.Amount), type: .final)
            let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: landmark.Tax), type: .final)
            paymentSummaryItems = [amount, tax]
            var shipping = ""
            if landmark.category == .lakes && NSDecimalNumber(string: landmark.Total) > 0.00 {
                shipping = "0.5"
                let fullTotal = NSDecimalNumber(string: landmark.Total).adding(NSDecimalNumber(string: shipping))
                paymentSummaryItems.append(PKPaymentSummaryItem(label: "Shipping", amount: NSDecimalNumber(string: shipping), type: .final))
                paymentSummaryItems.append(PKPaymentSummaryItem(label: "Total", amount: fullTotal, type: .final))
           } else {
                paymentSummaryItems.append(PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: landmark.Total), type: .final))
            }
            
            self.paymentHandler.startPayment( paymentSummaryItems: paymentSummaryItems, requiredShippingContactFields:requiredShippingContactFields )  { (success) in
                
                if let row = landmarkData.firstIndex(where: { $0.id == self.currentLandmarkId }) {
                    if success {
                        print("Apple Pay Success for \(self.filteredLandMark?.name ?? "Unknown")")
                        landmarkData[row].bought = true
                        let landmarkDataSaved = isLandmarkDataSaved
                        print("Modified landmark json file saved = \(landmarkDataSaved)")
                        self.loadLandmarkView = false
                    } else {
                        print("Apple Pay Failed for \(self.filteredLandMark?.name ?? "Unknown")")
                        landmarkData[row].bought = false
                        self.loadLandmarkView = false
                    }
                } else {
                    print("Could not find item id in landmarkData to purchase by Apple Pay")
                }
            }
        } else {
            print("Could not find proper item to purchase by Apple Pay")
        }
    }
    
}

struct ViewLandmarkSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        //ViewLandmarkSwiftUIView(loadLandmarkView: .constant(true), landmarkOptional: landmarkData[0])
        ViewLandmarkSwiftUIView(loadLandmarkView: .constant(true), currentLandmarkId: .constant(0))
    }
}
