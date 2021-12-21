//
//  SigninViewer.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 08/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct SigninViewer: View {
    
    @ObservedObject var signinFetcher:SigninFetcher
    
    @Binding var photoFrame : (width:CGFloat, height:CGFloat)
    
    var body: some View {
        VStack {
            if signinFetcher.signinSuccess.users.count > 0 {
                UserView(signinSuccess: signinFetcher.signinSuccess, photoFrame: photoFrame)
                
            }
            else if !signinFetcher.signinSuccess.ErrorCode.isEmpty {
                ErrorView(signinSuccess: signinFetcher.signinSuccess)
            }
            
            else {
                VStack (alignment: .leading) {
                    ForEach(0 ..< 6) {_ in
                        Text("")
                    }
                }
            }
            
        }
    }
    
    
}

extension SigninViewer {
    struct ErrorView: View {
        private let signinSuccess: SigninSuccess
        
        init(signinSuccess: SigninSuccess) {
            self.signinSuccess = signinSuccess
        }
        
        var body: some View {
            VStack (alignment: .leading) {
                
                Text("ErrorCode : \(self.signinSuccess.ErrorCode)")
                Text("ErrorMessage : \(self.signinSuccess.ErrorMessage)")
                Text("AccessToken : \(self.signinSuccess.AccessToken)")
                Text("CompanyUserId : \(self.signinSuccess.CompanyUserId)")
                ForEach(0 ..< 2) {_ in
                    Text("")
                }
                
            }
        }
    }
    
    struct UserView: View {
        @EnvironmentObject  var  userAuth: UserAuth
        @Environment(\.imageCache) var cache: ImageCache

        let signinSuccess: SigninSuccess
        let photoFrame : (width:CGFloat, height:CGFloat)
        
        init(signinSuccess: SigninSuccess, photoFrame:(width:CGFloat, height:CGFloat) ) {
            self.signinSuccess = signinSuccess
            self.photoFrame = photoFrame
        }
        
        var body: some View {
            VStack {
                
                ForEach( 0 ..< self.signinSuccess.users.count) { number in
                    
                    ExtractedView(signinSuccess: signinSuccess, photoFrame: photoFrame, number: number)
                }
            }
        }
    }
    
}

struct ExtractedView: View {
    
    @EnvironmentObject  var  userAuth: UserAuth
    @Environment(\.imageCache) var cache: ImageCache

    let signinSuccess: SigninSuccess
    let photoFrame : (width:CGFloat, height:CGFloat)
    let recordNumber:Int
    
    init( signinSuccess: SigninSuccess, photoFrame:(width:CGFloat, height:CGFloat), number:Int ) {
        self.signinSuccess = signinSuccess
        self.recordNumber = number
        self.photoFrame = photoFrame
    }
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                Group {
                    Group {
                        Text("\(self.signinSuccess.users[recordNumber].profileData.UserFirstName) \(self.signinSuccess.users[recordNumber].profileData.UserLastName)")
                        Text(self.signinSuccess.users[recordNumber].profileData.UserEmail)
                        Text(self.signinSuccess.users[recordNumber].profileData.UserMobile)
                        Text(self.signinSuccess.users[recordNumber].profileData.UserDateOfBirth)
                        Text("RollId : \(self.signinSuccess.users[recordNumber].profileData.UserRoleId) | Roll :  \(self.signinSuccess.users[recordNumber].profileData.UserRole) | IsPrimaryUser : \(self.signinSuccess.users[recordNumber].profileData.UserIsPrimaryUser) ")
                    }
                    
                    Group {
                        Text("Company Details :")
                        Text("Email : \(self.signinSuccess.users[recordNumber].companyData.UserCompanyEmail)")
                        Text("Website : \(self.signinSuccess.users[recordNumber].companyData.UserCompanyWebsite)")
                        Text("Address : \(self.signinSuccess.users[recordNumber].companyData.UserCompanyAddress)")
                    }
                    
                }
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                
            }
            
            Group {
                
                Text(self.signinSuccess.users[recordNumber].profileData.UserProfileImagePathActual)
                    .lineLimit(nil)
                
                SwiftUIAsyncImageView(url: URL(string: self.signinSuccess.users[recordNumber].profileData.UserProfileImagePathActual), placeholder: Text("User Photo"), cache: self.cache)
                    .frame(minWidth: 0, idealWidth: self.photoFrame.width, maxWidth: .infinity, minHeight: 0, idealHeight: self.photoFrame.height, maxHeight: 400, alignment: .center)
                    .cornerRadius(CommonUtils.cu_CornerRadius)

                Divider()
                
                Text("Company Logo:")
                    .padding(.top, 10)
                Text(self.signinSuccess.users[recordNumber].companyData.UserCompanyLogo)
                    .lineLimit(nil)
                
                SwiftUIAsyncImageView(url: URL(string: self.signinSuccess.users[recordNumber].companyData.UserCompanyLogo), placeholder: Text(""), cache: self.cache)
                    .frame(minWidth: 0, idealWidth: self.photoFrame.width, maxWidth: .infinity, minHeight: 0, idealHeight: self.photoFrame.height, maxHeight: 400, alignment: .center)
                    .cornerRadius(CommonUtils.cu_CornerRadius)
                    .padding(0)
                
                SSWebViewBrowse(urlString: "<html><header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=5.0, minimum-scale=0.5, user-scalable=yes'><meta name='color-scheme' content='dark light'></header><p align='justify'>\(self.signinSuccess.users[recordNumber].companyData.UserCompanyDescription)</p></html>", isHtmlText: true, siteTitle:"Company Description (in html justified text)", showNavigationBar:false)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 300, maxHeight: 400, alignment: .center)
                    .padding(0)
                
                // SSNote :
                // Example of SwiftUI view AsyncImage ( iOS 15.0 or newer )
                // view that downloads and shows an image via URL
                // AsyncImagePhase enum defines a bunch of image loading states like empty, success, and failed. You can handle all these cases.
                // Another parameter of the currently used initializer is the SwiftUI transaction. By default, AsyncImage creates a new transaction with the default configuration. In this example, a custom transaction with a particular animation that AsyncImage will use whenever phase changes.
                
                if #available(iOS 15.0, *) {
                    AsyncImage(
                        url: URL(string: self.signinSuccess.users[recordNumber].companyData.UserCompanyLogo),
                        transaction: Transaction(animation: .easeInOut)
                    ) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .transition(.scale(scale: 0.1, anchor: .center))
                        case .failure:
                            Image(systemName: "wifi.slash")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.yellow)
                    .clipShape(Circle())
                } else {
                    // Fallback on earlier versions
                }

            }
            
            //SSTODO  how to do following and
            //let user = self.signinSuccess.users[number]
            /*
             if !self.userAuth.userEmail.elementsEqual(self.signinSuccess.users[number].profileData.UserEmail) {
             self.userAuth.userEmail = self.signinSuccess.users[number].profileData.UserEmail
             }
             */
        }
        .onAppear(perform: {
            let user = self.signinSuccess.users[recordNumber]
            
            if !self.userAuth.userEmail.elementsEqual(user.profileData.UserEmail) {
                self.userAuth.userEmail = user.profileData.UserEmail
            }
            
        })
    }
}
