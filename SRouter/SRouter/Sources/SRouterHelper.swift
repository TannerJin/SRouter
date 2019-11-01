//
//  SRouterHelper.swift
//  SwiftStubRouter
//
//  Created by jintao on 2019/10/28.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

// MARK: Swift Runtime

// Swift Type Metadata https://github.com/apple/swift/blob/master/docs/ABI/TypeMetadata.rst#nominal-type-descriptor
func isFunction(_ type: Any.Type) -> Bool {
    assert(MemoryLayout.size(ofValue: type) == MemoryLayout<UnsafeMutablePointer<Int>>.size)
    
    let typePointer = unsafeBitCast(type, to: UnsafeMutablePointer<Int>.self)
    return typePointer.pointee == (2 | 0x100 | 0x200)
}

func swift_demangle(_ mangledName: String) -> String? {
    let cname = mangledName.withCString({ $0 })
    if let demangledName = get_swift_demangle(mangledName: cname, mangledNameLength: UInt(mangledName.utf8.count), outputBuffer: nil, outputBufferSize: nil, flags: 0) {
        return String(cString: demangledName)
    }
    return nil
}

// swift_demangle: Swift/Swift libraries/SwiftDemangling/Header Files/Demangle.h
@_silgen_name("swift_demangle")
private func get_swift_demangle(mangledName: UnsafePointer<CChar>?,
                                mangledNameLength: UInt,
                                outputBuffer: UnsafeMutablePointer<UInt8>?,
                                outputBufferSize: UnsafeMutablePointer<Int>?,
                                flags: UInt32
                                ) -> UnsafeMutablePointer<CChar>?
