//
//  CombineFormView.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 30/01/21.
//  Copyright © 2021 Sanjay Sampat. All rights reserved.
//

import SwiftUI

enum PasswordStatus {
    case empty
    case notStrong
    case confirmPasswordWrong
    case valid
}

// ViewModel
import Combine

class CombineFormViewModel: ObservableObject {
    @Published var userName = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isValid = false
    
    @Published var inlineErrorForPassword = ""
    @Published var inlineErrorForUsername = ""

    // variable to store subscribed publishers
    private var cancellables = Set<AnyCancellable>()
    
    // password contains leters a-z, special characters $@$#!%*?& and atleast length of 6
    private static let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{6,}$")
    
    // Combine publisher of Bool type which will Never fail
    private var isUserNameValidPublisher: AnyPublisher<Bool, Never> {
        $userName
            // debounce to execute after 0.9 delay on main run loop.
            .debounce(for: 0.9, scheduler: RunLoop.main)
            // remove duplicates as we only require any values which are changed.
            .removeDuplicates()
            // userName entry should be more then 3 characters.
            .map { $0.count > 3 }
            // above lines will give error as "Cannot convert return expression of type 'Publishers.Map<Publishers.RemoveDuplicates<Publishers.Debounce<Published<String>.Publisher, RunLoop>>, Bool>' to return type 'AnyPublisher<Bool, Never>'". To simplify and remove error use following
            .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.9, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
        // CombineLatest - Publisher that receives and combines the latest elements from two publishers.
        // CombineLatest3 or CombineLatest4 : elements from 3 or 4 publishers
        // if we want elements from 8 publishers then we need to use Two CombineLatest4 publishers and then need to combine both using CombineLatest
        Publishers.CombineLatest($password, $confirmPassword)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            // $0 is first element ($password) and $1 is second element ($confirmPassword)
            .map { $0 == $1 }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordStrongPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .map {
                // Self is to access static var with Class reference.
                Self.passwordPredicate.evaluate(with: $0)
            }
            .eraseToAnyPublisher()
    }

    // Publisher to check all three conditions of Password
    private var isPasswordValidPublisher: AnyPublisher<PasswordStatus, Never> {
        Publishers.CombineLatest3(isPasswordEmptyPublisher, arePasswordsEqualPublisher, isPasswordStrongPublisher)
            .map {
                if $0 { return PasswordStatus.empty }
                if !$2 { return PasswordStatus.notStrong }
                if !$1 { return PasswordStatus.confirmPasswordWrong }
                return PasswordStatus.valid
            }
            .eraseToAnyPublisher()
    }
    
    // Publisher to check if Form is valid
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isPasswordValidPublisher, isUserNameValidPublisher)
            .map { $0 == PasswordStatus.valid && $1 }
            .eraseToAnyPublisher()
    }
    
    init() {
        // subscribe to the Publisher
        // As UI will be updating the Published variable isValid, which is being observed by View, on update of View the UI is going to be updated, we need to run on main queue.
        isFormValidPublisher
            .receive(on: RunLoop.main)
            // assign it to variable in self Viewmodel
            .assign(to: \.isValid, on: self)
            .store(in: &cancellables)
        
        isPasswordValidPublisher
            // initially the password check will fail as fields are empty
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { passwordStatus in
                switch passwordStatus {
                case .empty:
                    return "Passweord can not be empty."
                case .notStrong:
                    return "Password should contain atleast a letter a-z, special character $@#!%*?& and length of 6 or above."
                case .confirmPasswordWrong:
                    return "Password does not match with Confirm Password."
                case .valid:
                    return ""
                }
            }
            .assign(to: \.inlineErrorForPassword, on: self)
            .store(in: &cancellables)
        
        isUserNameValidPublisher
            // initially the password check will fail as fields are empty
            .dropFirst()
            .receive(on: RunLoop.main)
            .map {
                return $0 ? "" : "Username length should be of 4 and above."
            }
            .assign(to: \.inlineErrorForUsername, on: self)
            .store(in: &cancellables)
    }
}


// View

struct CombineFormView: View {
    @StateObject private var combineFormViewModel = CombineFormViewModel()
    
    var body: some View {
        NavigationView {
            VStack() {
                Form {
                    Section(header: Text("USERNAME"), footer: Text(combineFormViewModel.inlineErrorForUsername).foregroundColor(.red)) {
                        TextField("User name", text: $combineFormViewModel.userName)
                            .autocapitalization(.none)
                    }
                    Section(header: Text("PASSWORD"), footer: Text(combineFormViewModel.inlineErrorForPassword).foregroundColor(.red)) {
                        SecureField("Password", text: $combineFormViewModel.password)
                        SecureField("Confirm password", text: $combineFormViewModel.confirmPassword)
                    }
                }
                .padding(.bottom, 0)
                
                Button(action: { /* SSTODO */  }) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height:50)
                        .overlay(
                            Text("Continue")
                                .foregroundColor(.white)
                        )
                }
                .padding(.top, 0)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
                .disabled(!combineFormViewModel.isValid)
            }
            .navigationBarTitle(Text("Form using Combine"), displayMode: .inline)
        }

    }
}

struct CombineFormView_Previews: PreviewProvider {
    static var previews: some View {
        CombineFormView()
    }
}
