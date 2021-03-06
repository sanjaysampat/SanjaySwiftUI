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
                    .frame(width: self.photoFrame.width, height: self.photoFrame.height, alignment: .center)
                    .cornerRadius(CommonUtils.cu_CornerRadius)
                
                Text("Company Logo:")
                    .padding(.top, 10)
                Text(self.signinSuccess.users[recordNumber].companyData.UserCompanyLogo)
                    .lineLimit(nil)
                
                SwiftUIAsyncImageView(url: URL(string: self.signinSuccess.users[recordNumber].companyData.UserCompanyLogo), placeholder: Text("Company Logo"), cache: self.cache)
                    .frame(width: self.photoFrame.width, height: self.photoFrame.height, alignment: .top)
                    .cornerRadius(CommonUtils.cu_CornerRadius)
                
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
