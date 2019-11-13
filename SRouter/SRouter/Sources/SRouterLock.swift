//
//  SRouterLock.swift
//  SwiftStubRouter
//
//  Created by jintao on 2019/10/27.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

class SRouterSpinLock {
    private var _lock = os_unfair_lock_s()

    func lock() {
        os_unfair_lock_lock(&_lock)
    }
    
    func unlock() {
        os_unfair_lock_unlock(&_lock)
    }
}

class SRouterLock {
    private var lock_value: Int32 = 0
    
    func lock() {
        // 单核：停止多线程调度(关中断)
        // 多核：1.锁住总线 2.锁住缓存的lock_value行
        while !OSAtomicCompareAndSwap32(0, 1, &lock_value) {
            // QOS_CLASS_BACKGROUND        : 9
            // QOS_CLASS_UTILITY           : 17
            // QOS_CLASS_DEFAULT           : 21
            // QOS_CLASS_USER_INITIATED    : 25
            // QOS_CLASS_USER_INTERACTIVE  : 33
            if qos_class_self().rawValue <= QOS_CLASS_BACKGROUND.rawValue {
                pthread_set_qos_class_self_np(QOS_CLASS_UTILITY, 0)
            }
        }
    }
    
    func unlock() {
        // 结果储存在当前线程的rax寄存器中，if判断没有多线程问题
        if OSAtomicDecrement32(&lock_value) != 0 {
           abort()
        }
    }
}
