//
//  PaymentSwiftUIView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 30/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI
import PassKit


struct PaymentSwiftUIView: View {
    ////var paymentSummaryItems = [PKPaymentSummaryItem]()
    ////@State private var payAvailable = false
    //@State private var landmarkOptional:Landmark? = nil
    @State private var currentLandmarkId:Int = -1
    @State private var loadLandmarkView = false
    @State private var reloadView = false
    
    // SSNote : paymentHandler code is currently not working
    let paymentHandler = PaymentHandler()

    var bottomBar: some View {
        // SSNote : currently not working
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
        ZStack(alignment: .top) {
            if self.loadLandmarkView {
                //ViewLandmarkSwiftUIView(loadLandmarkView: $loadLandmarkView, landmarkOptional: self.landmarkOptional )
                ViewLandmarkSwiftUIView(loadLandmarkView: $loadLandmarkView, currentLandmarkId: $currentLandmarkId )
            } else {
                /*
                 // SSTODO can not refresh view after deleting json file
                 // tried self.reloadView.toggle(). But could not find solution.
                 // I do not want to exit this view and again call PaymentSiwftUIView
                if self.reloadView {
                    Text("true")
                } else {
                    Text("false")
                }
                Button( action: {
                    let cleared = isLandmarkDataFileDeleted
                    print("Landmark data file deleted = \(cleared)")
                    if cleared {
                        self.reloadView.toggle()
                    }
                } ) {
                    Text("Clear all Bought data")
                }
                */
                ScrollView {
                    ////
                    /*
                     // working applepaycode with single item for test
                    VStack {
                        ZStack {
                            Text("item")
                            
                                self.bottomBar
                                    .frame(alignment: .bottom)
                                
                                Divider()
                            }
                    }
                    */
                    ////
                    ForEach(landmarkData) { landmark in
                        Button( action: {
                            //self.landmarkOptional = landmark
                            self.currentLandmarkId = landmark.id
                            self.loadLandmarkView = true
                        } ) {
                            VStack {
                                ZStack {
                                    Text("item")

                                    landmark.image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(20)
                                        .frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: 250, idealHeight: 250, maxHeight: 250, alignment: .top)
                                    
                                    Text(landmark.name)
                                        .foregroundColor(CommonUtils.cu_activity_background_color)
                                        .shadow(radius: 1.5)
                                        .frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: 250, idealHeight: 250, maxHeight: 250, alignment: .top)

                                    // bought text
                                    if landmark.bought {
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
                                Divider()
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                    ////
                }
                .offset(y: 40)
                
            }
        }
    }
    
    func orderItem() {
        // SSNote : currently not working
        var paymentSummaryItems = [PKPaymentSummaryItem]()
        let amount = PKPaymentSummaryItem(label: "Amount", amount: NSDecimalNumber(string: "8.88"), type: .final)
        let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: "1.12"), type: .final)
        let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: "10.00"), type: .pending)
        paymentSummaryItems = [amount, tax, total]
        
        self.paymentHandler.startPayment(paymentSummaryItems: paymentSummaryItems) { (success) in
            if success {
                print("Apple Pay Success ")
            } else {
                print("Apple Pay Failed ")
            }
        }
    }

}

struct PaymentSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentSwiftUIView()
    }
}
