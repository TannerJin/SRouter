//
//  SRouterLock.swift
//  SwiftStubRouter
//
//  Created by jintao on 2019/10/27.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

@available(iOS 10.0, *)
class SpinLock {
    private var _lock = os_unfair_lock_s()

    
    func lock() {
        os_unfair_lock_lock(&_lock)
    }
    
    func unlock() {
        os_unfair_lock_unlock(&_lock)
    }
}


// update: https://github.com/TannerJin/Lock/blob/master/Lock/Sources/SpinLock.swift
class SRouterSpinLock {
    private var value: Int32 = 0
    private static var PreQosClassKey: pthread_key_t = 0

    public func lock() {
        while !OSAtomicCompareAndSwap32(0, 1, &value) {}

        // QOS_CLASS_BACKGROUND        : 9
        // QOS_CLASS_UTILITY           : 17
        // QOS_CLASS_DEFAULT           : 21
        // QOS_CLASS_USER_INITIATED    : 25
        // QOS_CLASS_USER_INTERACTIVE  : 33
        // fix优先级反转(提高获取到锁的线程优先级, 目前是这个) or (降低没获取到锁的线程优先级)
        // lock   提升优先级
        // unlock 恢复线程优先级
        let preQosClassSelf = qos_class_self()

        if preQosClassSelf.rawValue <= QOS_CLASS_DEFAULT.rawValue {
            let pointer = malloc(MemoryLayout<qos_class_t>.size)
            pointer?.bindMemory(to: qos_class_t.self, capacity: 1).initialize(to: preQosClassSelf)

            if Self.PreQosClassKey == 0 {
                pthread_key_create(&Self.PreQosClassKey, nil)
            }
            pthread_setspecific(Self.PreQosClassKey, pointer)

            pthread_set_qos_class_self_np(QOS_CLASS_USER_INITIATED, 0)
        }
    }

    public func unlock() {
        var preQosClassSelf: UnsafeMutablePointer<qos_class_t>?

        if Self.PreQosClassKey != 0 {
            preQosClassSelf = pthread_getspecific(Self.PreQosClassKey)?.assumingMemoryBound(to: qos_class_t.self)
            pthread_setspecific(Self.PreQosClassKey, nil)
        }

        value = 0
        
        if preQosClassSelf != nil {
            pthread_set_qos_class_self_np(preQosClassSelf!.pointee, 0)
            free(preQosClassSelf)
        }
    }
}
