//
//  Reachability.swift
//  Connected
//
//  Created by Brian Coleman on 2015-03-23.
//  Copyright (c) 2015 Brian Coleman. All rights reserved.
//
//

import Foundation
import SystemConfiguration

// Reachability - THIS CLASS IS NOT IN USE. ( The methods used in other methods are not in use. )
// Please check ReachablityDg class.
open class Reachability { 
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
       /* let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            //SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }*/
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
            return false
        }
        
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired
        
        return isReachable && !needsConnection
        
    }
}
