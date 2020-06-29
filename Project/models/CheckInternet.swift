//
//  CheckInternet.swift
//  Project
//
//  Created by raz cohen on 31/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import SystemConfiguration



struct CheckInternet{
    
     func isConnected(with flags: SCNetworkReachabilityFlags)->Bool{
        let isReachable = flags.contains(.reachable)

        return isReachable
    }
}
