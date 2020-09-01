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
        VStack {
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
                        .foregroundColor(CommonUtils.cu_activity_foreground_color)
                        .shadow(radius: 1.5)
                        .frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: 250, idealHeight: 250, maxHeight: 250, alignment: .bottom)
                        //.opacity(0.5)
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
            
        }

    }
    
    func orderItem() {
        var landmark:Landmark
        if let lm = self.filteredLandMark {
            landmark = lm
            var paymentSummaryItems = [PKPaymentSummaryItem]()
            let amount = PKPaymentSummaryItem(label: "Amount", amount: NSDecimalNumber(string: landmark.Amount), type: .final)
            let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: landmark.Tax), type: .final)
            let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: landmark.Total), type: .pending)
            paymentSummaryItems = [amount, tax, total]
            
            self.paymentHandler.startPayment(paymentSummaryItems: paymentSummaryItems)  { (success) in
                
                if let row = landmarkData.firstIndex(where: { $0.id == self.currentLandmarkId }) {
                    if success {
                        print("Apple Pay Success for \(self.filteredLandMark?.name ?? "Unknown")")
                        landmarkData[row].bought = true
                        self.loadLandmarkView = false
                    } else {
                        print("Apple Pay Failed for \(self.filteredLandMark?.name ?? "Unknown")")
                        // SSNote : for testing only // SSTODO
                        landmarkData[row].bought = true
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
