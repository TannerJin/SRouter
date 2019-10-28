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
    private var defaultNotFoundHandler: ((_ router: String)->())?
}

public extension SRouterManager {
    func registerDefultNotFoundHandler(_ handler: @escaping (_ router: String)->()) {
        self.defaultNotFoundHandler = handler
    }
}

public extension SRouterManager {
    func routeTo(_ router: String) -> SRouterDefaultBlock? {
        let block = self.routeTo(router, routerBlockType: SRouterDefaultBlock.SRouterBlock.self)
        return SRouterDefaultBlock(block)
    }
    
    func routeTo<T>(_ router: String, routerBlockType: T.Type) -> T? {
        assert(MemoryLayout<T>.size == MemoryLayout<UnsafeRawPointer>.size, "T.Type is not @convention(thin) block")

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
    func routeAndHandleNotFound(_ router: String, notFoundHandle handler: (()->())? = nil) -> SRouterDefaultBlock? {
        let routerBlock = routeAndHandleNotFound(router, routerBlockType: SRouterDefaultBlock.SRouterBlock.self, notFoundHandle: handler)
        return SRouterDefaultBlock(routerBlock)
    }
    
    @discardableResult
    func routeAndHandleNotFound<T>(_ router: String, routerBlockType blockType: T.Type, notFoundHandle handler: (()->())? = nil) -> T? {
        if let router = routeTo(router, routerBlockType: blockType) {
           return router
        }
        handler == nil ? defaultNotFoundHandler?(router):handler?()
        return nil
    }
}
