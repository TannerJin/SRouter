//
//  SRouterLog.swift
//  SwiftStubRouter
//
//  Created by jintao on 2019/10/28.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

internal var SRouterLogOn = false

internal func SRouterLog(router: String, message: String) {
    if SRouterLogOn {
        let logMsg = "[** SRouter **] route to '\(router)' Error =>: " + message
        print(logMsg, "\n")
    }
}

public extension SRouterManager {
    static func openLog() {
        SRouterLogOn = true
    }
    
    static func closeLog() {
        SRouterLogOn = false
    }
}
