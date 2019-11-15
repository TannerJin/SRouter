//
//  SRouterLock.swift
//  SwiftStubRouter
//
//  Created by jintao on 2019/10/27.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

class SpinLock {
    private var _lock = os_unfair_lock_s()

    func lock() {
        os_unfair_lock_lock(&_lock)
    }
    
    func unlock() {
        os_unfair_lock_unlock(&_lock)
    }
}

class SRouterSpinLock {
    private static var pre_qos_class_key: pthread_key_t = 0
    private var lock_value: Int32 = 0
    
    func lock() {
        // 单核：停止多线程调度(关中断)
        // 多核：1.锁住总线 2.锁住缓存的lock_value行
        while !OSAtomicCompareAndSwap32(0, 1, &lock_value) {}
        
        // QOS_CLASS_BACKGROUND        : 9
        // QOS_CLASS_UTILITY           : 17
        // QOS_CLASS_DEFAULT           : 21
        // QOS_CLASS_USER_INITIATED    : 25
        // QOS_CLASS_USER_INTERACTIVE  : 33

        // 优先级反转:
        // lock   提升优先级
        // unlock 恢复线程优先级
        let pre_qos_class_self = qos_class_self()
        
        if pre_qos_class_self.rawValue <= QOS_CLASS_BACKGROUND.rawValue {
            
            let pointer = malloc(MemoryLayout<qos_class_t>.size)
            pointer?.bindMemory(to: qos_class_t.self, capacity: 1).initialize(to: pre_qos_class_self)
            
            if SRouterSpinLock.pre_qos_class_key == 0 {
                pthread_key_create(&SRouterSpinLock.pre_qos_class_key, nil)
            }
            pthread_setspecific(SRouterSpinLock.pre_qos_class_key, pointer)
            
            pthread_set_qos_class_self_np(QOS_CLASS_DEFAULT, 0)
        }
    }
    
    func unlock() {
        var pre_qos_class: UnsafeMutablePointer<qos_class_t>?

        if SRouterSpinLock.pre_qos_class_key != 0 {
            pre_qos_class = pthread_getspecific(SRouterSpinLock.pre_qos_class_key)?.assumingMemoryBound(to: qos_class_t.self)
            pthread_setspecific(SRouterSpinLock.pre_qos_class_key, nil)
        }
        
        OSAtomicCompareAndSwap32(1, 0, &lock_value)
        
        if pre_qos_class != nil {
            pthread_set_qos_class_self_np(pre_qos_class!.pointee, 0)
            free(pre_qos_class)
        }
    }
}
