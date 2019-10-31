//
//  SRouterUIViewControllerMetadata.swift
//  SwiftStubRouter
//
//  Created by jintao on 2019/10/30.
//  Copyright © 2019 jintao. All rights reserved.
//

import UIKit

// NOTE: https://github.com/apple/swift/blob/master/docs/ABI/RegisterUsage.md
//                  arm64  x86_64
// self(register)    x20    r13


public struct SRouterViewController<T> {
    typealias T = DefaultInitMethod
       
    internal var controllerType: UIViewController.Type
   
    internal var initFunction: T
   
    internal var selfRegister: Int64 = 0
}

// MARK: Init

// UIViewController()
//      |(SIL)
//      V self -> UIViewController.Type
// @convention(method) (UIViewController.Type) -> UIViewController
//      |(Symbol)
//      V 
// __C.UIViewController.__allocating_init() -> __C.UIViewController

public typealias DefaultInitMethod = @convention(thin) () -> UIViewController

public extension SRouterViewController where T == DefaultInitMethod {
    mutating func `init`() -> UIViewController {
        saveSelfRegister(&selfRegister)
        setSelfRegister(&controllerType)
        
        let controller = self.initFunction()
        
        setSelfRegister(&selfRegister)
        return controller
    }
}

// MARK: Init Nib

// UIViewController(nibName: <#T##String?#>, bundle: <#T##Bundle?#>)
//      |(SIL)
//      V self -> UIViewController.Type
// @convention(method) (String?, Bundle?, UIViewController.Type) -> UIViewController
//      |(Symbol)
//      V
// UIViewController.__allocating_init(nibName: Swift.Optional<Swift.String>, bundle: Swift.Optional<__C.NSBundle>) -> UIViewController

public typealias NibInitMethod = @convention(thin) (_ nibName: String?, _ bundle: Bundle?) -> UIViewController

public extension SRouterViewController where T == NibInitMethod {
    mutating func `init`(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) -> UIViewController {
        saveSelfRegister(&selfRegister)
        setSelfRegister(&controllerType)
       
        let controller = self.initFunction(nibNameOrNil, nibBundleOrNil)
       
        setSelfRegister(&selfRegister)
        return controller
    }
}


// MARK: Others(DIY) Init
