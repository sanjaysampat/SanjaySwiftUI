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
    
    let jsonFileName = "signin.json"
    
    init( userEmail:String = "" ) {
        // SSNote to check here if local json file of user is available.
        if userEmail.isEmpty || !loadLocally(userEmail: userEmail) {
            load()
        }
    }
    
    func loadLocally( userEmail:String ) -> Bool {
        
        if let dataFromFile = CommonUtils.readFileFromDocument( folderName:"Users/\(userEmail)", fileName:self.jsonFileName ) {
            do {
                
                //let json = JSON(d)  // SSTEST - SwiftyJSON //

                let decodedReturn = try JSONDecoder().decode(SigninSuccess.self, from: dataFromFile)
                // SSTODO - Save profile image to user's document folder
                
                DispatchQueue.main.async {
                    self.signinSuccess = decodedReturn
                    
                    self.load(doRefresh: false)
                }
                return true
            } catch {
                print ("Error decoding data")
            }
        } else {
            print ("Error reading file")
        }
        return false
    }
    
    // in case of doRefresh, it will write the JSON file in document folder.
    func load( doRefresh:Bool = true ) {

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
                if let dataFromURL = data {
                    
                    //let json = JSON(d)  // SSTEST - SwiftyJSON // 

                    let decodedReturn = try JSONDecoder().decode(SigninSuccess.self, from: dataFromURL)
                    
                    // Save the data to local json file
                    let userEmail = decodedReturn.users[0].profileData.UserEmail
                    if !userEmail.isEmpty {
                        if CommonUtils.writeFileToDocument(folderName:"Users/\(userEmail)", fileName:self.jsonFileName, fileData:dataFromURL, atomicWrite:true) {
                            // write success
                            
                        } else {
                            // write fail
                        }
                    }
                    // SSTODO - Save profile image to user's document folder
                    if doRefresh {
                        DispatchQueue.main.async {
                            self.signinSuccess = decodedReturn
                        }
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
