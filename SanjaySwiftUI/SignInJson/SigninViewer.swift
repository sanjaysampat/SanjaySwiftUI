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
        @Environment(\.imageCache) var cache: ImageCache
        @EnvironmentObject  var  userAuth: UserAuth
        
        private let signinSuccess: SigninSuccess
        private var photoFrame : (width:CGFloat, height:CGFloat)
        
        init(signinSuccess: SigninSuccess, photoFrame:(width:CGFloat, height:CGFloat) ) {
            self.signinSuccess = signinSuccess
            self.photoFrame = photoFrame
        }
        
        var body: some View {
            VStack {
                
                ForEach( 0 ..< self.signinSuccess.users.count) { number in
                    
                    VStack {
                        VStack (alignment: .leading) {
                            
                            Text("\(self.signinSuccess.users[number].profileData.UserFirstName) \(self.signinSuccess.users[number].profileData.UserLastName)")
                            Text(self.signinSuccess.users[number].profileData.UserEmail)
                            Text(self.signinSuccess.users[number].profileData.UserMobile)
                            Text(self.signinSuccess.users[number].profileData.UserDateOfBirth)
                            Text("RollId : \(self.signinSuccess.users[number].profileData.UserRoleId) | Roll :  \(self.signinSuccess.users[number].profileData.UserRole) | IsPrimaryUser : \(self.signinSuccess.users[number].profileData.UserIsPrimaryUser) ")
                            
                            Text(self.signinSuccess.users[number].profileData.UserProfileImagePathActual)
                        }
                        
                        SwiftUIAsyncImageView(url: URL(string: self.signinSuccess.users[number].profileData.UserProfileImagePathActual), placeholder: Text("Loading ..."), cache: self.cache)
                            .frame(width: self.photoFrame.width, height: self.photoFrame.height, alignment: .center)
                            .cornerRadius(CommonUtils.cu_CornerRadius)
                        
                        
                        //SSTODO  how to do following and
                        //let user = self.signinSuccess.users[number]
                        /*
                        if !self.userAuth.userEmail.elementsEqual(self.signinSuccess.users[number].profileData.UserEmail) {
                            self.userAuth.userEmail = self.signinSuccess.users[number].profileData.UserEmail
                        }
                        */
                    }
                .onAppear(perform: {
                    let user = self.signinSuccess.users[number]
                    
                    if !self.userAuth.userEmail.elementsEqual(user.profileData.UserEmail) {
                        self.userAuth.userEmail = user.profileData.UserEmail
                    }

                })
                }
            }
        }
    }
    
}
