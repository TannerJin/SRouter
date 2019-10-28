//
//  SRouterHelper.swift
//  SwiftStubRouter
//
//  Created by jintao on 2019/10/28.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

// Swift Type Metadata https://github.com/apple/swift/blob/master/docs/ABI/TypeMetadata.rst#nominal-type-descriptor
internal func isFunction<T>(_ type: T.Type) -> Bool {
    assert(MemoryLayout<T>.size == MemoryLayout<UnsafeMutablePointer<Int>>.size)
    
    let typePointer = unsafeBitCast(type, to: UnsafeMutablePointer<Int>.self)
    return typePointer.pointee == (2 | 0x100 | 0x200)
}
