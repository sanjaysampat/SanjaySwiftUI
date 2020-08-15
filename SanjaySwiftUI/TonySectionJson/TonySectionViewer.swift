//
//  TonySectionViewer.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 13/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct TonySectionViewer: View {
    
    @ObservedObject var tonySectionFeatcher:TonySectionFeatcher
    
    @Binding var photoFrame : (width:CGFloat, height:CGFloat)
    
    var body: some View {
        VStack {
            
            
            if tonySectionFeatcher.categories.count > 0 {
                CategoryView(categories: tonySectionFeatcher.categories, photoFrame: photoFrame)
            } else if tonySectionFeatcher.categoriesInArrays.count > 0 {
                CategoryView(categoriesInArrays: tonySectionFeatcher.categoriesInArrays, photoFrame: photoFrame)
            }

            /*
            if signinFetcher.signinSuccess.users.count > 0 {
                UserView(signinSuccess: signinFetcher.signinSuccess, photoFrame: photoFrame)
                
            }
            else if !signinFetcher.signinSuccess.ErrorCode.isEmpty {
                ErrorView(signinSuccess: signinFetcher.signinSuccess)
            }
            
            else {
                VStack (alignment: .leading) {
                    ForEach(0 ..< 6) {row in
                        Text("test sanjay \(row)")
                    }
                }
            }
            */
        }
    }
    
    
}

extension TonySectionViewer {
    struct CategoryView: View {
        @Environment(\.imageCache) var cache: ImageCache
        @EnvironmentObject  var  userAuth: UserAuth
        
        private var categories : [TonySectionCat] = []
        private var categoriesInArrays : [[[TonySectionCat]]] = [[[]]]
        //private let tonySectionCatagories: TonySectionCatagories
        private var photoFrame : (width:CGFloat, height:CGFloat)
        
        init(categories: [TonySectionCat], photoFrame:(width:CGFloat, height:CGFloat) ) {
            self.categories = categories
            self.photoFrame = photoFrame
        }
        
        init(categoriesInArrays: [[[TonySectionCat]]], photoFrame:(width:CGFloat, height:CGFloat) ) {
            self.categoriesInArrays = categoriesInArrays
            self.photoFrame = photoFrame
        }
        
        var body: some View {
            VStack {
                if self.categories.count > 0 {
                    InnerCategoryView(innerCategories: categories, photoFrame: photoFrame)
                }
                else if self.categoriesInArrays.count > 0 {
                    ForEach(self.categoriesInArrays, id:\.self) { array1 in
                        ForEach(array1, id:\.self) { categories in
                            InnerCategoryView(innerCategories: categories, photoFrame: self.photoFrame)
                        }
                    }
                    
                }
            }
            
        }
    }

    struct InnerCategoryView: View {
        @Environment(\.imageCache) var cache: ImageCache
        @EnvironmentObject  var  userAuth: UserAuth

        private var innerCategories : [TonySectionCat] = []
        private var photoFrame : (width:CGFloat, height:CGFloat)

        init(innerCategories: [TonySectionCat], photoFrame:(width:CGFloat, height:CGFloat) ) {
            self.innerCategories = innerCategories
            self.photoFrame = photoFrame
        }

        var body: some View {
            ScrollView(.horizontal) {
                HStack {
                    ForEach( 0 ..< self.innerCategories.count, id: \.self) { index in
                        VStack {
                            //Text("\(self.categories[index].catFirstTitle)  \(self.categories[index].catSecondTitle)")
                            
                            SwiftUIAsyncImageView(url: URL(string: self.innerCategories[index].imgPath), placeholder: Text("Loading ..."), cache: self.cache)
                                .frame(width: self.photoFrame.width, height: self.photoFrame.height, alignment: .center)
                                .cornerRadius(CommonUtils.cu_CornerRadius)
                        }
                    }
                }
                .onAppear(perform: {
                    
                    if !self.userAuth.userEmail.elementsEqual(PrivateCommit.nc_email) {
                        self.userAuth.userEmail = PrivateCommit.nc_email
                    }
                    
                })
            }
        }
    }
}

/*
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
*/
