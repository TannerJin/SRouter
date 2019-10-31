//
//  SRouterManager+UIViewController.swift
//  SwiftStubRouter
//
//  Created by jintao on 2019/10/30.
//  Copyright © 2019 jintao. All rights reserved.
//

import UIKit

public extension SRouterManager {
    
    func unsafeRouteToController(_ controller: String) -> SRouterViewController<DefaultInitMethod>? {
        // hard code depend on compiler
        return routeToController(controller, controllerInitMethod: DefaultInitMethod.self, symbol: "__C.UIViewController.__allocating_init() -> __C.UIViewController")
    }
    
    func unsafeRouteToNibController(_ controller: String) -> SRouterViewController<NibInitMethod>? {
        // hard code depend on compiler
        return routeToController(controller, controllerInitMethod: NibInitMethod.self, symbol: "\(controller).__allocating_init(nibName: Swift.Optional<Swift.String>, bundle: Swift.Optional<__C.NSBundle>) -> \(controller)")
    }
    
    // TODO
    func unsafeRouteToController<T>(_ controller: String, controllerInitMethod initType: T.Type) -> SRouterViewController<T>?  {
        return routeToController(controller, controllerInitMethod: initType, symbol: "")
    }
    
    private func routeToController<T>(_ controller: String, controllerInitMethod initType: T.Type, symbol: String) -> SRouterViewController<T>? {
        guard let className = objc_getClass(controller) as? UIViewController.Type,
            let module = controller.components(separatedBy: ".").first else { return nil }
                
        if let pointer = stubRouteToControllerInit(module, symbol: symbol) {
            let alloc_init = unsafeBitCast(pointer, to: initType.self)
            return SRouterViewController(controllerType: className, initFunction: alloc_init)
        }
        return nil
    }
}
