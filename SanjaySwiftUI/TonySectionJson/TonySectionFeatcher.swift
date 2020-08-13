//
//  TonySectionFeatcher.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 13/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import Foundation
import Combine

public class TonySectionFeatcher: ObservableObject {
    @Published var categories : [TonySectionCat] = []
    
    let jsonFileName = "getHomeSliderCatRecordTony.json"
    
    init( userEmail:String = "" ) {
        // SSNote to check here if local json file of user is available.
        if userEmail.isEmpty || !loadLocally(userEmail: userEmail) {
            load()
        }
    }
    
    func loadLocally( userEmail:String ) -> Bool {
        
        if let dataFromFile = CommonUtils.readFileFromDocument( folderName:"Users/\(userEmail)", fileName:self.jsonFileName ) {
            do {
                
                //let json = JSON(dataFromFile)  // SSTEST - SwiftyJSON //

                let decodedReturn = try JSONDecoder().decode([TonySectionCat].self, from: dataFromFile)

                DispatchQueue.main.async {
                    self.categories = decodedReturn
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

        guard let url = URL(string: PrivateCommit.nc_tonyselectioncategoriesurl) else {
            print( "Error: Can not create URL" )
            return
        }
        
        var urlRequest = URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 120)
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        var data = Data()
        //do {
            for(key,value) in PrivateCommit.nc_tonyselectioncategoriesDataString {
                // Add the reqtype field and its value to the raw http request data
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                data.append("\(value)".data(using: .utf8)!)
            }
            // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = data
        //} catch {
        //    print( "Error: Can not create JSON" )
        //}
        
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
                    
                    //let json = JSON(dataFromURL)  // SSTEST - SwiftyJSON //

                    let decodedReturn = try JSONDecoder().decode([TonySectionCat].self, from: dataFromURL)
                    
                    // Save the data to local json file
                    let userEmail = PrivateCommit.nc_email  //decodedReturn.users[0].profileData.UserEmail
                    if !userEmail.isEmpty {
                        if CommonUtils.writeFileToDocument(folderName:"Users/\(userEmail)", fileName:self.jsonFileName, fileData:dataFromURL, atomicWrite:true) {
                            // write success
                            
                        } else {
                            // write fail
                        }
                    }
                    
                    if doRefresh {
                        DispatchQueue.main.async {
                            self.categories = decodedReturn
                        }
                    }
                }else {
                    print("No Data")
                }
            } catch {
                print ("Error decoding data :- \(error)")
            }
        }
        task.resume()
    }
}
