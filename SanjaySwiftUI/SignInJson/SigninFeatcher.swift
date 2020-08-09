//
//  SigninFetcher.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 08/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import Foundation
import Combine

public class SigninFetcher: ObservableObject {
    @Published var signinSuccess : SigninSuccess = SigninSuccess()
    
    init() {
        load()
    }
    
    func load() {

        guard let url = URL(string: PrivateCommit.nc_signinurl) else {
            print( "Error: Can not create URL" )
            return
        }
        
        var urlRequest = URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 120)
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: PrivateCommit.nc_signinDataString, options: [])
            let postLength = String(describing: jsonData.count)
            urlRequest.setValue(postLength, forHTTPHeaderField: "Content-Length")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
        } catch {
            print( "Error: Can not create JSON" )
        }
        
        urlRequest.httpMethod = "POST"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                print( "Error: \(String(describing: error?.localizedDescription))")
                return
            }
            do {
                if let d = data {
                    
                    //let json = JSON(d)  // SSTEST // 

                    let decodedReturn = try JSONDecoder().decode(SigninSuccess.self, from: d)
                    
                    DispatchQueue.main.async {
                        self.signinSuccess = decodedReturn
                    }
                }else {
                    print("No Data")
                }
            } catch {
                print ("Error decoding data")
            }
        }
        task.resume()
    }
}
