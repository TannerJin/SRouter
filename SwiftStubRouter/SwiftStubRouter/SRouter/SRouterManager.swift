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

    private var cacheSymbols = [String: UnsafeRawPointer]()
    private var lock = SRouterLock()
    private var defaultNotFoundHandle: (()->())?
}

public extension SRouterManager {
    func registerDefultNotFoundHander(_ handle: @escaping ()->()) {
        self.defaultNotFoundHandle = handle
    }
}

public extension SRouterManager {
    func routeTo(_ router: String) -> SRouter? {
        if let block = self.routeTo(router, sRouterType: SRouter.SRouterBlock.self) {
            return SRouter(block)
        }
        return nil
    }
    
    func routeTo<T>(_ router: String, sRouterType: T.Type) -> T? {
        lock.lock()
        defer {
            lock.unlock()
        }
        if let symbol = cacheSymbols[router] {
            let routerBlock = unsafeBitCast(symbol, to: T.self)
            return routerBlock
        }
        
        guard let module = router.components(separatedBy: "://").first,
            let routerSymbol = stubRouteToModule(module, symbol: router) else { return nil }
        
        cacheSymbols[router] = routerSymbol
        let routerBlock = unsafeBitCast(routerSymbol, to: T.self)
        
        return routerBlock
    }
}

public extension SRouterManager {
    @discardableResult
    func routeTo<T>(_ router: String, sRouterType: T.Type, notFoundHandle handle: (()->())?) -> T? {
        if let router = routeTo(router, sRouterType: sRouterType) {
           return router
        }
        handle == nil ? defaultNotFoundHandle?():handle?()
        return nil
    }
}
