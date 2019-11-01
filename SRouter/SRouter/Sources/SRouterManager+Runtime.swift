//
//  SRouterManager+UIViewController.swift
//  SwiftStubRouter
//
//  Created by jintao on 2019/10/30.
//  Copyright © 2019 jintao. All rights reserved.
//

import MachO
import UIKit

// MARK: objc Runtime

public extension SRouterManager {
    typealias AllocWithZone = @convention(c) (NSObject.Type) -> NSObject
    
    static func initController(_ controller: String) -> UIViewController? {
        guard let className = objc_getClass(controller) as? UIViewController.Type else {
            return nil
        }
        for i in 0..<_dyld_image_count() {
            if String(cString: _dyld_get_image_name(i)).components(separatedBy: "/").last == "libobjc.A.dylib" {
                // objc_allocWithZone is EXPORT at libobjc.A.dylib
                if let handle = dlopen(_dyld_get_image_name(i), RTLD_NOW), let pointer = dlsym(handle, "objc_allocWithZone") {
                    let allocWithZone = unsafeBitCast(pointer, to: AllocWithZone.self)
                    let objc = allocWithZone(className)
                    return objc.perform(#selector(NSObject.init))?.takeRetainedValue() as? UIViewController
                }
            }
        }
        return nil
    }
    
    static func initNibController(_ controller: String, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) -> UIViewController? {
        guard let className = objc_getClass(controller) as? UIViewController.Type else {
            return nil
        }
        for i in 0..<_dyld_image_count() {
            if String(cString: _dyld_get_image_name(i)).components(separatedBy: "/").last == "libobjc.A.dylib" {
                // objc_allocWithZone is EXPORT at libobjc.A.dylib
                if let handle = dlopen(_dyld_get_image_name(i), RTLD_NOW), let pointer = dlsym(handle, "objc_allocWithZone") {
                    let allocWithZone = unsafeBitCast(pointer, to: AllocWithZone.self)
                    let objc = allocWithZone(className)
                    return objc.perform(#selector(UIViewController.init(nibName:bundle:)), with: nibNameOrNil, with: nibBundleOrNil)?.takeRetainedValue() as? UIViewController
                }
            }
        }
        return nil
    }
}
