//
//  CustomRouterManager.swift
//  Base
//
//  Created by jintao on 2019/10/24.
//  Copyright © 2019 jintao. All rights reserved.
//

import Foundation

open class SRouterManager {
    public static let `default` = SRouterManager()

    internal var lock = SRouterLock()
    internal var cacheSymbols = [String: UnsafeRawPointer]()
    internal var defaultNotFoundHandler: ((_ router: String)->())?
}

public extension SRouterManager {
    func registeredDefultNotFoundHandler(_ handler: @escaping (_ router: String)->()) {
        self.defaultNotFoundHandler = handler
    }
}

public extension SRouterManager {
    func routeTo(_ router: String) -> SRouterDefaultSILFunction? {
        let function = self.routeTo(router, routerSILFunctionType: SRouterDefaultSILFunction.SRouterSILFunction.self)
        return SRouterDefaultSILFunction(function)
    }
    
    func routeTo<T>(_ router: String, routerSILFunctionType functionType: T.Type) -> T? {
        assert(MemoryLayout<T>.size == MemoryLayout<UnsafeRawPointer>.size, "\(T.self) is not @convention(thin) Function Type")
        
        if !isFunction(functionType) {
            SRouterLog(router: router, message: "\(functionType) Is Not FunctionType")
            return nil
        }
        
        lock.lock()
        defer {
            lock.unlock()
        }
        
        if let symbol = cacheSymbols[router] {
            let routerFunction = unsafeBitCast(symbol, to: T.self)
            return routerFunction
        }
        
        guard let module = router.components(separatedBy: "://").first,
            let routerSymbol = SRouteLookupSymbolAtModule(module, symbol: router) else { return nil }
        
        cacheSymbols[router] = routerSymbol
        let routerFunction = unsafeBitCast(routerSymbol, to: T.self)
        return routerFunction
    }
}

public extension SRouterManager {
    @discardableResult
    func routeAndHandleNotFound(_ router: String, notFoundHandle handler: (()->())? = nil) -> SRouterDefaultSILFunction? {
        let routerFunction = routeAndHandleNotFound(router, routerSILFunctionType: SRouterDefaultSILFunction.SRouterSILFunction.self, notFoundHandle: handler)
        return SRouterDefaultSILFunction(routerFunction)
    }
    
    @discardableResult
    func routeAndHandleNotFound<T>(_ router: String, routerSILFunctionType functionType: T.Type, notFoundHandle handler: (()->())? = nil) -> T? {
        if let router = routeTo(router, routerSILFunctionType: functionType) {
           return router
        }
        handler == nil ? defaultNotFoundHandler?(router):handler?()
        return nil
    }
}
