//
//  SRouterLog.swift
//  SwiftStubRouter
//
//  Created by jintao on 2019/10/28.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

public var SRouterLogOn = false

@inlinable
func SRouterLog(router: String, message: String) {
    #if DEBUG
    if SRouterLogOn {
        let logMsg = "[** SRouter **] route to '\(router)' error =>: " + message
        print(logMsg, "\n")
    }
    #endif
}
