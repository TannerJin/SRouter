//
//  SRouterLock.swift
//  SwiftStubRouter
//
//  Created by jintao on 2019/10/27.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

class SRouterLock {
    private var _lock = os_unfair_lock_s()
    
    func lock() {
        os_unfair_lock_lock(&_lock)
    }
    
    func unlock() {
        os_unfair_lock_unlock(&_lock)
    }
}
